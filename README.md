# Bison

BSON (binary JSON) encoding and decoding in Swift.

## Overview

The swift-bison package exposes four main modules:
* `BisonRead` and `BisonWrite` for fast, flexible and type-safe document encoding and decoding.
* `BisonEncode` and `BisonDecode` to adapt existing Swift `Codable` code already in your project.

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
.package(url: "https://github.com/crichez/swift-bison", .upToNextMinor("0.0.1"))
```

*Note:* versions before 1.0.0 are considered pre-release, and code-breaking changes may be 
introduced with a minor version bump. Once the project graduates to 1.0.0, regular semantic
versioning rules will apply.

## Documentation

This package is extensively documented using [docc](https://github.com/apple/swift-docc).
You can find inline documentation on all source files.
