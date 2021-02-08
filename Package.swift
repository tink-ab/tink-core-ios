// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "TinkCore",
    platforms: [
        .iOS(.v11),
        .macOS(.v10_13)
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
            url: "https://github.com/tink-ab/tink-core-ios/releases/download/0.7.0/TinkCore.xcframework.zip", checksum: "c8f7b21a5c9c2901c456d5189392a0b594e3b7c0aa0381c072022c3670cf7983"
        ),
    ]
)
