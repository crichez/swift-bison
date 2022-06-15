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
        .library(name: "BisonWrite", targets: ["BisonWrite"]),
        .library(name: "BisonRead", targets: ["BisonRead"]),
        .library(name: "BSONKit", targets: ["BisonWrite", "BisonRead"]),
        .library(name: "BSONDecodable", targets: ["BSONDecodable"]),
        .library(name: "BSONEncodable", targets: ["BSONEncodable"]),
        .library(name: "BSONCodable", targets: ["BSONEncodable", "BSONDecodable"]),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-collections", .upToNextMajor(from: "1.0.0"))
    ],
    targets: [
        // The target that declares the ObjectID type. This excludes Bison integration.
        .target(name: "ObjectID", dependencies: []),
        .testTarget(name: "ObjectIDTests", dependencies: ["ObjectID"]),

        // The target for composing and encoding documents.
        .target(name: "BisonWrite", dependencies: ["ObjectID"]),
        .testTarget(name: "BisonWriteTests", dependencies: ["BisonWrite"]),

        .target(
            name: "BisonRead",
            dependencies: [
                .product(name: "OrderedCollections", package: "swift-collections"),
                "ObjectID"
            ]),
        .testTarget( name: "BisonReadTests", dependencies: ["BisonRead", "BisonWrite"]),

        .target(name: "BSONEncodable", dependencies: ["BisonWrite"]),
        .testTarget(name: "BSONEncodableTests", dependencies: ["BSONEncodable", "BisonWrite"]),

        .target(name: "BSONDecodable", dependencies: ["BisonRead"]),
        .testTarget(
            name: "BSONDecodableTests", 
            dependencies: ["BisonRead", "BSONEncodable", "BSONDecodable", "BisonWrite"]),
        
    ]
)
