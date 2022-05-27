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
            url: "https://github.com/tink-ab/tink-core-ios/releases/download/1.8.1/TinkCore.xcframework.zip", checksum: "b193a69b592010db69f158496c41cd238979681f8a0e7e01022b5c1e58b1d6d0"
        ),
    ]
)
