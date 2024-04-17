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
            url: "https://github.com/tink-ab/tink-core-ios/releases/download/2.3.0/TinkCore.xcframework.zip", checksum: "d6c46de0ba239417a2b41c2418350bdbb6cae4df1deec2b354d58539a4a568e3"
        ),
    ]
)
