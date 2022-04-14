# BSONKit

Binary JSON encoding and decoding in Swift.

## Overview

The BSONKit package exposes two main modules:
* `BSONKit` for fast, flexible and type-safe document encoding and decoding.
* `BSONCodable` to adapt existing Swift `Codable` code already in your project.

Each of these modules is available for encoding or decoding only by importing:
* `BSONCompose` & `BSONParse` as alternatives to the full `BSONKit`.
* `BSONEncodable` & `BSONDecodable` as alternatives to the full `BSONCodable`.

This project is tested in continuous integration on the following platforms:
* macOS 11
* iOS 15
* tvOS 15
* watchOS 8
* ubuntu 20.04
* Windows Server 2022

## Usage

You can import this package by adding the following line to your `Package.swift` dependencies:
```swift
.package(url: "https://github.com/crichez/swift-bson", .upToNextMinor("0.0.1"))
```

*Note:* versions before 1.0.0 are considered pre-release, and code-breaking changes may be 
introduced with a minor version bump. Once the project graduates to 1.0.0, regular semantic
versioning rules will apply.

### BSONCompose

When using `BSONCompose`, document structure is declared using a custom result builder.
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

When using `BSONParse`, decoding is done in two steps:
1. Validate the document's structure by intializing a `ParsedDocument`
2. Decode individual values using their `init(bsonBytes:)` initializer

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

### BSONCodable

`BSONCodable` is meant as a drop-in replacement for `PropertyListEncoder` or `JSONDecoder`,
including error handling using Swift `EncodingError` and `DecodingError`.
You can use the `BSONEncoder` and `BSONDecoder` types as analogs that produce BSON documents.

```swift
import BSONCodable

struct Person: Codable {
    let name: String
    let age: Int
}

let person = Person(name: "Bob Belcher", age: 41)
let encodedPerson = try BSONEncoder().encode(person)
let decodedPerson = try BSONDecoder().decode(Person.self, from: encodedPerson)
```
