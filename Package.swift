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
            url: "https://github.com/ErnestoOlalla/KMPLibrarySample/releases/download/v1.0.7/shared.xcframework.zip",
            checksum: "d1ddb824a277d8dde6a5e74e1a4d4d92531913e5fd7a5c501c7d049e7008e355"
        )
    ]
)
