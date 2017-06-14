// swift-tools-version:4.0
import PackageDescription

let package = Package(
    name: "Kuery",
    products: [
        .library(
            name: "Kuery",
            targets: ["Kuery"]),
    ],
    targets: [
        .target(
            name: "Kuery",
            dependencies: []),
        .testTarget(
            name: "KueryTests",
            dependencies: ["Kuery"]),
    ]
)
