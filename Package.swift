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
        // The core modules for composition and parsing, or both.
        .library(name: "BisonWrite", targets: ["BisonWrite"]),
        .library(name: "BisonRead", targets: ["BisonRead"]),
        .library(name: "Bison", targets: ["BisonWrite", "BisonRead"]),

        // Adapters for Swift Encodable and Decodable, or both.
        .library(name: "BisonDecode", targets: ["BisonDecode"]),
        .library(name: "BisonEncode", targets: ["BisonEncode"]),
        .library(name: "BisonCodable", targets: ["BisonEncode", "BisonDecode"]),
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

        // The target for parsing and decoding documents.
        .target(name: "BisonRead", dependencies: [
            .product(name: "OrderedCollections", package: "swift-collections"),
            "ObjectID",
        ]),
        .testTarget( name: "BisonReadTests", dependencies: ["BisonRead", "BisonWrite"]),

        // The target that exposes BSONEncoder.
        .target(name: "BisonEncode", dependencies: ["BisonWrite"]),
        .testTarget(name: "BisonEncodeTests", dependencies: ["BisonEncode", "BisonWrite"]),

        // The target that exposes BSONDecoder.
        .target(name: "BisonDecode", dependencies: ["BisonRead"]),
        .testTarget(
            name: "BisonDecodeTests", 
            dependencies: ["BisonRead", "BisonEncode", "BisonDecode", "BisonWrite"]
        ),
    ]
)
