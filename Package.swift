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
            url: "https://github.com/ErnestoOlalla/KMPLibrarySample/releases/download/v1.0.4/shared.xcframework.zip",
            checksum: "79b156076446873cb3c81f8d81ca5a19f533a53797c3f541cf2cbdc79cbef057"
        )
    ]
)
