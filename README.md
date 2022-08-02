# 🦬 Bison

BSON (binary JSON) encoding and decoding in Swift.

## Overview

The swift-bison package features **two flavors** of BSON document management:
* `BisonRead` & `BisonWrite`: custom APIs designed for flexibility and performance.
* `BisonEncode` & `BisonDecode`: Swift `Codable` adapters to start working with BSON today.

This project is tested in continuous integration on the following platforms:
* macOS 11
* iOS 15
* tvOS 15
* watchOS 8
* ubuntu 20.04
* Windows Server 2022

## Version

You can import this package by adding the following line to your `Package.swift` dependencies:
```swift
.package(url: "https://github.com/crichez/swift-bison", .upToNextMinor("0.0.1"))
```

*Note:* versions before 1.0.0 are considered pre-release, and sources-breaking changes may be 
introduced with a minor version bump. Once the project graduates to 1.0.0, regular semantic
versioning rules will apply.

## Documentation

**This package is documented using [swift-docc](https://github.com/apple/swift-docc)**. You can 
build the documentation for a specific module by following instructions at that repository,
or read inline documentation for each source file. The following sections give a brief 
introduction to the most common APIs of each module.

### BisonWrite

Import the `BisonWrite` module to compose and encode complex documents using a custom result 
builder. The following example declares a simple BSON document with conditionals and nesting,
then encodes it to an Array of bytes.

```swift
import BisonWrite

let ownerDoc = WritableDoc {
    "name" => "Bob Belcher"
    if season8 {
        "age" => Int64(46)
    } else {
        "age" => Int64(45)
    }
    "children" => WritableArray {
        "Tina"
        "Louise"
        "Gene"
    }
}
.encode(as: [UInt8].self)
```

### BisonRead

Import the `BisonRead` module to parse and decode documents from raw bytes. The following example
parses a document, then extracts select values.

```swift
import BisonRead

do {
    // Parse and validate the document.
    let doc = try ReadableDoc(bsonBytes: ownerDoc)
    // Get the "name" value and initialize it as a String.
    guard let nameData = doc["name"] else { return }
    let name = try String(bsonBytes: nameData)
    // Get the "children" nested document and initialize each value.
    guard let childrenData = doc["children"] else { return }
    let childrenDoc = try ReadableDoc(bsonBytes: childrenData)
    for childNameData in childrenDoc.values {
        let childName = try String(bsonBytes: childNameData)
    }
} catch DocError<[UInt8]>.unknownType(let type, let key, let progress) {
    // Handle document parsing errors.
} catch ValueError.sizeMismatch {
    // Handle value parsing errors.
}
```

### BisonEncode & BisonDecode

Import the `BisonEncode` & `BisonDecode` modules to use the `BSONEncoder` and `BSONDecoder` types.
These expose a similar API to Foundation's JSON encoder and decoder, while still featuring support
for custom BSON types through `BisonWrite` & `BisonRead` APIs.

```swift
import BisonEncode
import BisonDecode
import Foundation

struct Owner: Codable {
    let name: String
    let age: Int64
    let children: [String]
}

do {
    let owner = Owner(name: "Bob Belcher", age: 46, children: ["Tina", "Louise", "Gene"])
    let encodedOwnerDoc = try BSONEncoder<Data>().encode(owner)
    let decodedOwner = try BSONDecoder().decode(Owner.self, from: encodedOwnerDoc)
} catch DecodingError.typeMismatch(let requested, let context) {
    // Handle traditional Swift EncodingErrors and DecodingErrors
}
```

### ObjectID

The `ObjectID` module includes a full-featured BSON ObjectID implementation.

```swift
import ObjectID

// Initialize IDs randomly or from hexadecimal data.
var randomID = ObjectID()
// Use the timestamp property for chronological tracking.
let created: Date = randomID.timestamp
// Use the increment property for version tracking.
let version: Int = randomID.increment
// Easily output hexadecimal strings using custom LosslessStringConvertible conformance
let hexID = String(describing: randomID)
```
