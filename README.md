# BSONKit

Binary JSON encoding and decoding in Swift.

## Overview

BSONKit is a Swift Package Manager project that exposes three modules:
* `BSONCompose` to encode BSON documents into byte arrays.
* `BSONParse` to decode BSON documents from raw data.
* `BSONKit` for both encoding and decoding functionality.

You can import this package by adding the following line to your Package.swift dependencies:
```swift
.package(url: "https://github.com/crichez/swift-bson", .upToNextMinor("0.0.1"))
```

*Note:* versions before 1.0.0 are considered pre-release, and code-breaking changes may be 
introduced with a minor version bump. Once the project graduates to 1.0.0, regular semantic
versioning rules will apply.

### BSONCompose

Document encoding is done through `DocBuilder` declarations.
```swift
import BSONCompose

// Use the => operator to pair keys and values
let doc = ComposedDocument {
    "one" => 1
    "two" => 2.0
    "three" => "3"
    "doc" => ComposedDocument { 
        "flag" => true
        "maybe?" => String?.none
    }
}

// Encode the final document using the bsonBytes computed property
let encodedDoc: [UInt8] = doc.bsonBytes
```

### BSONParse

Document decoding is done in two steps:
1. Parse the document's structure using `ParsedDocument`
2. Decode individual values using their `init(bsonBytes:)` initializer.

```swift
import BSONParse

// Parse the keys and structure first
let doc = try ParsedDocument(bsonBytes: encodedDoc)

// Get values individually from the document
let one = try Int(bsonBytes: doc["one"])
let two = try Double(bsonBytes: doc["two"])
let three = try String(bsonBytes: doc["three"])

// Nested documents are treated as values
let nestedDoc = try ParsedDocument(bsonBytes: doc["doc"])

// And they expose their contents the same way
let flag = try Bool(bsonBytes: nestedDoc["flag"])
let maybe = try String?(bsonBytes: nestedDoc["maybe?"])
```
