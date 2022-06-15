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
        .library(name: "BSONCompose", targets: ["BSONCompose"]),
        .library(name: "BSONParse", targets: ["BSONParse"]),
        .library(name: "BSONKit", targets: ["BSONCompose", "BSONParse"]),
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


        .target(name: "BSONCompose", dependencies: ["ObjectID"]),
        .testTarget(name: "BSONComposeTests", dependencies: ["BSONCompose"]),

        .target(
            name: "BSONParse",
            dependencies: [
                .product(name: "OrderedCollections", package: "swift-collections"),
                "ObjectID"
            ]),
        .testTarget( name: "BSONParseTests", dependencies: ["BSONParse", "BSONCompose"]),

        .target(name: "BSONEncodable", dependencies: ["BSONCompose"]),
        .testTarget(name: "BSONEncodableTests", dependencies: ["BSONEncodable", "BSONCompose"]),

        .target(name: "BSONDecodable", dependencies: ["BSONParse"]),
        .testTarget(
            name: "BSONDecodableTests", 
            dependencies: ["BSONParse", "BSONEncodable", "BSONDecodable", "BSONCompose"]),
        
    ]
)
