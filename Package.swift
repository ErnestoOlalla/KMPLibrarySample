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
            url: "https://github.com/owner/repo/releases/download/v0.0.0/shared.xcframework.zip",
            checksum: "0000000000000000000000000000000000000000000000000000000000000000"
        )
    ]
)
