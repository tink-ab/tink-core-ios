// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "TinkCore",
    platforms: [
        .iOS(.v13),
        .macOS(.v11)
    ],
    products: [
        .library(
            name: "TinkCore",
            targets: ["TinkCore"]
        )
    ],
    targets: [
        .binaryTarget(
            name: "TinkCore",
            url: "https://github.com/tink-ab/tink-core-ios/releases/download/2.0.0/TinkCore.xcframework.zip", checksum: "3195937510ae58cb173868021a6c1cddfb9fea69e868c372afd5cacf71fc129d"
        ),
    ]
)
