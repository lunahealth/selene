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
    dependencies: [
        .package(name: "Archivable", url: "https://github.com/archivable/package.git", .branch("main")),
        .package(name: "Dater", url: "https://github.com/archivable/dater.git", .branch("main"))
    ],
    targets: [
        .target(
            name: "Selene",
            dependencies: ["Archivable", "Dater"],
            path: "Sources"),
        .testTarget(
            name: "Tests",
            dependencies: ["Selene"],
            path: "Tests"),
    ]
)
