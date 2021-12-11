// swift-tools-version:5.5
import PackageDescription

let package = Package(
    name: "Selene",
    platforms: [
        .iOS(.v15),
        .macOS(.v12),
        .watchOS(.v8)
    ],
    products: [
        .library(
            name: "Selene",
            targets: ["Selene"]),
    ],
    targets: [
        .target(
            name: "Selene",
            path: "Sources"),
        .testTarget(
            name: "Tests",
            dependencies: ["Selene"],
            path: "Tests"),
    ]
)
