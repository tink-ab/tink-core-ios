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
            name: "TinkCoreSources",
            targets: ["TinkCoreSources"]
        ),
        .library(
            name: "TinkCore",
            targets: ["TinkCore"]
        )
    ],
    targets: [
        .target(
            name: "TinkCoreSources",
            path: "Sources/TinkCore",
            exclude: ["Info.plist"]
        ),
        .binaryTarget(
            name: "TinkCore",
            url: "https://github.com/tink-ab/tink-core-ios/releases/download/0.6.0/TinkCore.xcframework.zip", checksum: "332b9a9bfe3ede375c2f09b3ef73d76340914ba6f16a773da60b0f0fa0aa7977"
        ),
        .testTarget(
            name: "TinkCoreTests",
            dependencies: ["TinkCoreSources"],
            exclude: ["Info.plist"]
        ),
    ]
)
