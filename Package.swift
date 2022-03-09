// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "swift-bson-kit",
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "BSONKit",
            targets: ["BSONKit"]),
    ],
    dependencies: [
        .package(
            name: "swift-collections", 
            url: "https://github.com/apple/swift-collections", 
            .upToNextMajor(from: "1.0.0"))
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "BSONKit",
            dependencies: [
                .product(name: "OrderedCollections", package: "swift-collections"),
            ],
            resources: [
                .copy("Encoding/DocBuilder.swifttemplate"),
                .copy("Encoding/Tuples/Tuple+DocComponent.swifttemplate"),
                .copy("Encoding/Chains/Chain+Sequence.swifttemplate"),
                .copy("Encoding/Chains/Chain+Collection.swifttemplate"),
            ]),
        .testTarget(
            name: "BSONKitTests",
            dependencies: ["BSONKit"]),
    ]
)
