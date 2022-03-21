//
//  ParsableValueTests.swift
//  ParsableValueTests
//
//  Created by Christopher Richez on March 20 2022
//

import BSONKit
import XCTest

/// A test suite for the `ParsableValue.init(bsonBytes:)` initializer's code branches.
class ParsableValueTests: XCTestCase {
    // MARK: Double

    /// Asserts encoding and decoding a valid `Double` returns the same value.
    func testDoubleParsed() throws {
        let value = Double.random(in: .leastNonzeroMagnitude ... .greatestFiniteMagnitude)
        let decodedValue = try Double(bsonBytes: value.bsonBytes)
        XCTAssertEqual(value, decodedValue)
    }

    /// Asserts attempting to decode a `Double` from other than 8 bytes throws
    /// `Double.Error.sizeMismatch`.
    func testDoubleSizeMismatch() throws {
        do {
            let faultyBytes: [UInt8] = [0, 1, 2, 3]
            let decodedValue = try Double(bsonBytes: faultyBytes)
            XCTFail("expected decoding to fail, but returned \(decodedValue)")
        } catch Double.Error.sizeMismatch {
            return
        }
    }

    // MARK: String

    /// Asserts encoding and decoding a valid `String` returns the same value.
    func testStringParsed() throws {
        let value = "this is a test! \u{10097}"
        let decodedValue = try String(bsonBytes: value.bsonBytes)
        XCTAssertEqual(value, decodedValue)
    }
}