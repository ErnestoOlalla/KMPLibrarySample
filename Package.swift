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
            url: "https://github.com/ErnestoOlalla/KMPLibrarySample/releases/download/v1.0.8/shared.xcframework.zip",
            checksum: "55365a321db34724c2b2913fb514416659246d753e2d545d5ed1a273ea7f7cae"
        )
    ]
)
