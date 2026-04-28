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
            url: "https://github.com/ErnestoOlalla/KMPLibrarySample/releases/download/v1.0.6/shared.xcframework.zip",
            checksum: "f31cb89f5846ce6acf1909f0ee26b2e4a5a933cc6a2d95ee6443635bb5ad4a1e"
        )
    ]
)
