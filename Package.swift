// swift-tools-version:5.9
import PackageDescription

// Este archivo es actualizado automáticamente por GitHub Actions en cada release.
let package = Package(
    name: "KmpProductsLib",
    platforms: [.iOS(.v15)],
    products: [
        .library(name: "shared", targets: ["shared"]),
    ],
    targets: [
        .binaryTarget(
            name: "shared",
            url: "https://github.com/ErnestoOlalla/KMPLibrarySample/releases/download/v1.0.3/shared.xcframework.zip",
            checksum: "be553e68df722cb7347b8277de985fe115aad21b0a6cd37514dab3b718d21b9f"
        )
    ]
)
