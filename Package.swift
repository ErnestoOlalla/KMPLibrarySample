// swift-tools-version:5.9
import PackageDescription

// Este archivo es actualizado automáticamente por GitHub Actions en cada release.
let package = Package(
    name: "KmpProductsLib",
    platforms: [.iOS(.v15)],
    products: [
        .library(name: "KmpProductsLib", targets: ["KmpProductsLib"]),
    ],
    targets: [
        .target(
            name: "KmpProductsLib",
            dependencies: ["shared"],
            path: "Sources/KmpProductsLib"
        ),
        .binaryTarget(
            name: "shared",
            url: "https://github.com/ErnestoOlalla/KMPLibrarySample/releases/download/v1.0.5/shared.xcframework.zip",
            checksum: "7da468fac34e4c3b3a48da7b358741a5c2cf6a2652df51210eed12bb0386da9a"
        )
    ]
)
