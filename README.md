# KMPLibrarySample

A Kotlin Multiplatform library that provides a ready-to-use product listing feature — including networking, business logic, and UI — for both **Android** and **iOS** from a single shared codebase.

The library fetches products from [dummyjson.com](https://dummyjson.com/products), exposes them through a shared ViewModel, and ships a Compose UI component for Android and a Swift-friendly API for iOS.

---

## What's inside

| Layer | Technology |
|-------|-----------|
| Networking | [Ktor](https://ktor.io/) (OkHttp engine on Android, Darwin on iOS) |
| Serialization | [kotlinx.serialization](https://github.com/Kotlin/kotlinx.serialization) |
| Dependency injection | [Koin](https://insert-koin.io/) |
| Async / state | [Kotlin Coroutines](https://kotlinlang.org/docs/coroutines-overview.html) + `StateFlow` |
| Android UI | [Jetpack Compose](https://developer.android.com/compose) |
| iOS UI | SwiftUI (consuming exposed flows via `FlowWrapper`) |

---

## Architecture

```
shared/
├── commonMain/
│   ├── data/
│   │   ├── remote/          # Ktor client + ProductApi
│   │   ├── dto/             # JSON response models
│   │   ├── mapper/          # DTO → domain mapping
│   │   └── repository/      # ProductRepositoryImpl
│   ├── domain/
│   │   ├── model/           # Product data class
│   │   ├── repository/      # ProductRepository interface
│   │   └── usecase/         # GetProductsUseCase
│   ├── presentation/
│   │   ├── ProductListViewModel.kt
│   │   └── ProductListState.kt
│   └── di/
│       └── KmpLibModule.kt  # Koin modules + initKmpLib()
├── androidMain/
│   └── ui/
│       └── ProductListScreen.kt   # Compose UI
└── iosMain/
    ├── di/KmpLibIosHelper.kt      # iOS Koin initializer
    └── presentation/FlowWrapper.kt
```

---

## Installation

### Android

The library is published to **GitHub Packages** (Maven). GitHub Packages requires authentication even for public packages — you need a [Personal Access Token](https://github.com/settings/tokens) with the `read:packages` scope.

Add the repository and credential in your project's `settings.gradle.kts`:

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

Store your token locally in `~/.gradle/gradle.properties` (never commit this file):

```properties
gpr.user=YOUR_GITHUB_USERNAME
gpr.token=YOUR_PERSONAL_ACCESS_TOKEN
```

Add the dependency in your module's `build.gradle.kts`:

```kotlin
dependencies {
    implementation("com.example.kmplib:shared:1.0.0")
}
```

#### Initialize the library (once, in your `Application` class)

```kotlin
class MyApp : Application() {
    override fun onCreate() {
        super.onCreate()
        initKmpLib()
    }
}
```

#### Use the Compose screen

```kotlin
import com.example.kmplib.ui.ProductListScreen

@Composable
fun MyScreen() {
    ProductListScreen()
}
```

---

### iOS

The library is distributed as a **binary XCFramework** via [Swift Package Manager](https://www.swift.org/package-manager/).

In Xcode:
1. **File → Add Package Dependencies…**
2. Enter the repository URL: `https://github.com/ErnestoOlalla/KMPLibrarySample`
3. Select the version rule and click **Add Package**

> The `Package.swift` in the root of this repo is automatically updated on every release with the correct download URL and checksum.

#### Initialize the library (once, in your `App` entry point)

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

#### Use the SwiftUI view

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

### Option 1 — One-click via GitHub Actions (recommended)

1. Go to the **Actions** tab in this repository
2. Select **"Release Library"** workflow
3. Click **"Run workflow"**
4. Enter the version number (e.g. `1.2.0`) and click **"Run workflow"**

GitHub Actions will:
- Create and push the git tag
- Build the Android AAR and publish it to GitHub Packages
- Build the iOS XCFramework, create a GitHub Release with the zip, and update `Package.swift`

### Option 2 — Via git tag

```bash
git tag v1.2.0
git push origin v1.2.0
```

---

## Requirements

| Target | Minimum version |
|--------|----------------|
| Android | API 24 (Android 7.0) |
| iOS | 15.0 |
| JVM (toolchain) | 17 |

---

## License

MIT
