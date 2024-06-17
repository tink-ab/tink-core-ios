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
            url: "https://github.com/tink-ab/tink-core-ios/releases/download/2.4.0/TinkCore.xcframework.zip", checksum: "3bd7e8c8b7df9c3d7cd0fc8bbcd70ebb9c2d2f2aaee7f516816527143cf47a84"
        ),
    ]
)
