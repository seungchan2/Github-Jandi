// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "JandiNetwork",
    platforms: [
        .iOS(.v17)
    ],
    products: [
        .library(
            name: "JandiNetwork",
            targets: ["JandiNetwork"]),
    ],
    dependencies: [
        .package(path: "./Core"),
    ],
    targets: [
        .target(
            name: "JandiNetwork",
            dependencies: [
                .product(name: "Core", package: "Core"),
            ]),
        .testTarget(
            name: "JandiNetworkTests",
            dependencies: ["JandiNetwork"]),
    ]
)
