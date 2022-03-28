// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "swift-bson",
    platforms: [
        // We need to explicitly declare the minimum macOS version to support opaque return types
        .macOS(.v10_15),
        .iOS(.v13),
        .tvOS(.v13),
    ],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "BSONCompose",
            targets: ["BSONCompose"]),
        .library(
            name: "BSONParse", 
            targets: ["BSONParse"]),
        .library(
            name: "BSONKit", 
            targets: ["BSONCompose", "BSONParse"])
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-collections", .upToNextMajor(from: "1.0.0")),
        .package(url: "https://github.com/apple/swift-docc-plugin", from: "1.0.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "BSONCompose",
            dependencies: []),
        .testTarget(
            name: "BSONComposeTests",
            dependencies: ["BSONCompose"]),
        .target(
            name: "BSONParse",
            dependencies: [
                .product(name: "OrderedCollections", package: "swift-collections"),
            ]),
        .testTarget(
            name: "BSONParseTests",
            dependencies: ["BSONParse"]),
    ]
)
