// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "swift-bson",
    platforms: [
        // We need to explicitly declare the minimum macOS version to support opaque return types
        .macOS(.v10_15),
    ],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "BSONKit",
            targets: ["BSONKit"]),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-collections", .upToNextMajor(from: "1.0.0"))
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "BSONKit",
            dependencies: [
                .product(name: "OrderedCollections", package: "swift-collections"),
            ]),
        .testTarget(
            name: "BSONKitTests",
            dependencies: ["BSONKit"]),
    ]
)
