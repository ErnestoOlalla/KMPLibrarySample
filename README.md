# KMPLibrarySample

A Kotlin Multiplatform library that provides a ready-to-use product listing feature — networking, business logic, and UI — for both **Android** and **iOS** from a single shared codebase.

The library fetches products from [dummyjson.com](https://dummyjson.com/products), exposes them through a shared ViewModel, and ships a Compose UI component for Android and a SwiftUI view for iOS.

---

## Repository structure

```
KMPLibrarySample/
├── shared/                        # KMP library module
│   └── src/
│       ├── commonMain/            # Shared Kotlin (all targets)
│       ├── androidMain/           # Android-only code (Compose UI)
│       └── iosMain/               # iOS-only code (Koin init + FlowWrapper)
├── Sources/
│   └── KmpProductsLib/            # Swift source target (SPM)
│       ├── KmpProductsLib.swift   # Public init function
│       └── ProductListView.swift  # SwiftUI view
├── Samples/
│   ├── KMPLibraryAndroidTest/     # Android sample app
│   └── KMPLibraryiOSTest/         # iOS sample app
├── Package.swift                  # SPM package definition (auto-updated on release)
└── .github/workflows/publish.yml  # CI/CD release pipeline
```

---

## Architecture

### Overview

```
┌─────────────────────────────────────────────────────────────────┐
│                         shared (KMP)                            │
│                                                                 │
│  ┌─────────────┐   ┌─────────────┐   ┌───────────────────────┐ │
│  │    data/    │   │   domain/   │   │     presentation/     │ │
│  │             │──▶│             │──▶│                       │ │
│  │  Ktor HTTP  │   │  Repository │   │  ProductListViewModel │ │
│  │  ProductApi │   │  interface  │   │  ProductListState     │ │
│  │  DTOs       │   │  UseCase    │   │  StateFlow<State>     │ │
│  │  Mapper     │   │             │   │                       │ │
│  └─────────────┘   └─────────────┘   └───────────┬───────────┘ │
│                                                   │             │
│              ┌────────────────────────────────────┘             │
│              │                                                  │
│       androidMain                          iosMain              │
│  ┌────────────────────┐        ┌───────────────────────────┐   │
│  │  ProductListScreen │        │  KmpLibIosHelper (Koin)   │   │
│  │  (Jetpack Compose) │        │  FlowWrapper<T>           │   │
│  │  collectAsState()  │        │  StateFlow → Swift bridge  │   │
│  └────────────────────┘        └───────────────────────────┘   │
└─────────────────────────────────────────────────────────────────┘
         │                                      │
         ▼                                      ▼
┌─────────────────┐                  ┌────────────────────────┐
│  Android app    │                  │  Sources/KmpProductsLib│
│                 │                  │  (Swift SPM target)    │
│  initKmpLib()   │                  │                        │
│  ProductList    │                  │  initializeKmpLib()    │
│  Screen()       │                  │  ProductListView       │
└─────────────────┘                  └────────────────────────┘
```

### Layers

| Layer | Location | Responsibility |
|-------|----------|---------------|
| **Remote data** | `commonMain/data/remote/` | Ktor HTTP client + `ProductApi` (platform engine injected via `expect/actual`) |
| **DTOs** | `commonMain/data/dto/` | JSON response models deserialized by kotlinx.serialization |
| **Mapper** | `commonMain/data/mapper/` | `ProductsResponse` → `List<Product>` |
| **Repository** | `commonMain/data/repository/` | `ProductRepositoryImpl` implements the domain interface |
| **Domain** | `commonMain/domain/` | `Product` model, `ProductRepository` interface, `GetProductsUseCase` |
| **ViewModel** | `commonMain/presentation/` | `ProductListViewModel` holds a `StateFlow<ProductListState>` and manages loading/error/success |
| **Android UI** | `androidMain/ui/` | `ProductListScreen` — Compose screen that calls `collectAsState()` on the ViewModel's flow |
| **iOS bridge** | `iosMain/` | `FlowWrapper<T>` wraps `StateFlow` into an observable that Swift can subscribe to; `KmpLibIosHelper` initializes Koin |
| **Swift UI** | `Sources/KmpProductsLib/` | `ProductListView` — SwiftUI view that observes state via `FlowWrapper`; `initializeKmpLib()` bootstraps Koin |

### Dependency injection

Koin is the DI framework used across both platforms. Three modules are declared in `commonMain`:

- **`dataModule`** — `HttpClient`, `ProductApi`, `ProductRepositoryImpl`
- **`domainModule`** — `GetProductsUseCase`
- **`presentationModule`** — `ProductListViewModel`

On **Android**, `initKmpLib()` calls `startKoin { modules(...) }` directly (called once from `Activity.onCreate` or `Application.onCreate`).

On **iOS**, `initializeKmpLib()` (Swift) calls `KmpLibIosHelperKt.startKmpLibIos()` (Kotlin/Native), which in turn calls the same `initKmpLib()`. The `KmpLibIosProvider` object is a `KoinComponent` used to retrieve the ViewModel from the DI graph.

### StateFlow → Swift bridge

Kotlin's `StateFlow<T>` is not directly observable in Swift. The `FlowWrapper<T>` class (in `iosMain`) wraps a `StateFlow` and exposes an `observe(onChange:)` method that subscribes on the main dispatcher and returns a `Cancellable`. In Swift, the `ProductListObservable` class holds the subscription and publishes state changes to an `@Published var state` that SwiftUI reacts to.

```
Kotlin StateFlow<ProductListState>
  └── FlowWrapper.observe { newState -> ... }   ← runs on Main dispatcher
        └── Swift: (AnyObject?) cast to ProductListState
              └── DispatchQueue.main.async { self.state = newState }
                    └── @Published triggers SwiftUI re-render
```

> **Note on Kotlin/Native generics:** ObjC/Swift interop erases generic type parameters, so `FlowWrapper<T>.observe` exposes its callback value as `AnyObject?`. The Swift layer casts it to the concrete type with `as? ProductListState`.

> **Note on ObjC naming:** Kotlin/Native does not export top-level functions whose names start with `init` (reserved for ObjC initializers). The iOS entry-point function is therefore named `startKmpLibIos()`.

---

## Distribution

### Android — GitHub Packages (Maven)

Each release publishes a `.aar` to GitHub Packages under:

```
com.example.kmplib:shared-android:<version>
```

GitHub Packages requires authentication even for public packages. Consumers need a [Personal Access Token](https://github.com/settings/tokens) with `read:packages` scope.

### iOS — Swift Package Manager (binary XCFramework)

Each release:
1. Builds a universal `shared.xcframework` (iosArm64, iosX64, iosSimulatorArm64)
2. Zips and uploads it as a GitHub Release asset
3. Automatically updates `Package.swift` with the new download URL and SHA-256 checksum

The SPM package is **mixed**: it exposes a binary target (`shared` — the XCFramework) and a Swift source target (`KmpProductsLib`) that wraps it and ships the SwiftUI `ProductListView`.

---

## Sample apps

### Android — `Samples/KMPLibraryAndroidTest`

A minimal Android app (`MainActivity`) that initializes the library and renders `ProductListScreen`.

**Prerequisites:**
- Android Studio Hedgehog or later
- A GitHub Personal Access Token with `read:packages` scope

**Setup:**

1. Add your credentials to `Samples/KMPLibraryAndroidTest/local.properties` (this file is gitignored):
   ```properties
   gpr.user=YOUR_GITHUB_USERNAME
   gpr.token=YOUR_PERSONAL_ACCESS_TOKEN
   ```
2. Open `Samples/KMPLibraryAndroidTest/` in Android Studio
3. Run the `app` configuration on an emulator or device (API 29+)

The app fetches and displays a list of products from the library. `initKmpLib()` is called in `MainActivity.onCreate` before the Compose content is set.

---

### iOS — `Samples/KMPLibraryiOSTest`

A minimal SwiftUI app that uses the library via SPM.

**Prerequisites:**
- Xcode 15 or later
- macOS 13+

**Setup:**

1. Open `Samples/KMPLibraryiOSTest/KMPLibraryiOSTest.xcodeproj` in Xcode
2. Wait for SPM to resolve the package (it fetches the XCFramework from GitHub Releases automatically — no credentials required)
3. Run on a simulator or device (iOS 15+)

The app calls `initializeKmpLib()` in `KMPLibraryiOSTestApp.init()` to start Koin, then renders `ProductListView()` from the `KmpProductsLib` package.

---

## Installation in your own app

### Android

Add the repository in `settings.gradle.kts`:

```kotlin
dependencyResolutionManagement {
    repositories {
        maven {
            url = uri("https://maven.pkg.github.com/ErnestoOlalla/KMPLibrarySample")
            credentials {
                username = providers.gradleProperty("gpr.user").orElse("").get()
                password = providers.gradleProperty("gpr.token").orElse("").get()
            }
        }
    }
}
```

Store credentials in `local.properties` (gitignored) or `~/.gradle/gradle.properties`:

```properties
gpr.user=YOUR_GITHUB_USERNAME
gpr.token=YOUR_PERSONAL_ACCESS_TOKEN
```

Add the dependency:

```kotlin
dependencies {
    implementation("com.example.kmplib:shared-android:1.0.8")
}
```

Initialize once (e.g. in `Activity.onCreate` or a custom `Application`):

```kotlin
import com.example.kmplib.di.initKmpLib

initKmpLib()
```

Use the screen:

```kotlin
import com.example.kmplib.ui.ProductListScreen

@Composable
fun MyScreen() {
    ProductListScreen()
}
```

---

### iOS

1. In Xcode: **File → Add Package Dependencies…**
2. Enter `https://github.com/ErnestoOlalla/KMPLibrarySample`
3. Select the desired version and click **Add Package**

Initialize once in your `App` entry point:

```swift
import KmpProductsLib

@main
struct MyApp: App {
    init() {
        initializeKmpLib()
    }
    var body: some Scene {
        WindowGroup { ContentView() }
    }
}
```

Use the SwiftUI view:

```swift
import KmpProductsLib

struct ContentView: View {
    var body: some View {
        ProductListView()
    }
}
```

---

## Releasing a new version

### One-click via GitHub Actions (recommended)

1. Go to the **Actions** tab → **"Release Library"** workflow
2. Click **"Run workflow"**, enter the version number (e.g. `1.2.0`), and confirm

GitHub Actions will:
- Create and push the git tag
- Build the Android AAR and publish it to GitHub Packages
- Build the iOS XCFramework, create a GitHub Release with the zip, and update `Package.swift`

### Via git tag

```bash
git tag v1.2.0
git push origin v1.2.0
```

---

## Tech stack

| | Technology |
|--|-----------|
| Networking | [Ktor](https://ktor.io/) 2.3 |
| Serialization | [kotlinx.serialization](https://github.com/Kotlin/kotlinx.serialization) |
| DI | [Koin](https://insert-koin.io/) 3.5 |
| Async / state | Kotlin Coroutines + `StateFlow` |
| Android UI | Jetpack Compose (BOM 2024.12) |
| iOS UI | SwiftUI |
| Build | Gradle 8.x, Kotlin 2.0, AGP 8.5 |
| CI/CD | GitHub Actions |
| Android distribution | GitHub Packages (Maven) |
| iOS distribution | SPM binary XCFramework via GitHub Releases |

---

## Requirements

| Target | Minimum |
|--------|---------|
| Android | API 29 (Android 10) |
| iOS | 15.0 |
| JVM toolchain | 17 |
| Xcode | 15+ |

---

## License

MIT
