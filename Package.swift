// swift-tools-version:5.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Turing",
    products: [
        // Products define the executables and libraries produced by a package, and make them visible to other packages.
        .executable(
            name: "Turing",
            targets: ["Turing"]),
        .library(
            name: "TuringLib",
            targets: ["TuringLib"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        .package(url: "https://github.com/onevcat/Rainbow", from: "3.0.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        .target(
            name: "Turing",
            dependencies: ["TuringLib"]),
        .target(
            name: "TuringLib",
            dependencies: ["Rainbow"]),
        .testTarget(
            name: "TuringTests",
            dependencies: ["TuringLib"]),
    ]
)
