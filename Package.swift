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
        ),
        .library(
            name: "TinkCoreXCFramework",
            targets: ["TinkCoreXCFramework"]
        )
    ],
    targets: [
        .target(
            name: "TinkCore"
        ),
        .binaryTarget(
            name: "TinkCoreXCFramework",
            path: "TinkCore.xcframework"
        ),
        .testTarget(
            name: "TinkCoreTests",
            dependencies: ["TinkCore"]
        ),
    ]
)
