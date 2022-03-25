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

    /// Asserts attempting to decode a `String` from less than 5 bytes throws
    /// `String.Error.dataTooShort`.
    func testStringDataTooShort() throws {
        do {
            let faultyBytes: [UInt8] = [0, 1, 2]
            let decodedValue = try String(bsonBytes: faultyBytes)
            XCTFail("expected decoding to fail, but returned \(decodedValue)")
        } catch String.Error.dataTooShort {
            return
        }
    }

    /// Asserts attempting to decode a `String` with a declared size different from its
    /// actual size throws `String.Error.sizeMismatch`.
    func testStringSizeMismatch() throws {
        do {
            let value = "this is a test! \u{10097}"
            var encodedValue = value.bsonBytes
            encodedValue.replaceSubrange(0..<4, with: Int32(5).bsonBytes)
            let decodedValue = try String(bsonBytes: encodedValue)
            XCTFail("expected decoding to fail, but returned \(decodedValue)")
        } catch String.Error.sizeMismatch {
            return
        }
    }

    // MARK: Bool

    /// Asserts decoding a `Bool` from valid data returns the expected value.
    func testBoolParsed() throws {
        let value = Bool.random()
        let decodedValue = try Bool(bsonBytes: value.bsonBytes)
        XCTAssertEqual(value, decodedValue)
    }

    /// Asserts decoding a `Bool` from more than 1 byte throws `Bool.Error.sizeMismatch`.
    func testBoolSizeMismatch() throws {
        let faultyBytes = [UInt8](repeating: 1, count: 3)
        do {
            let decodedValue = try Bool(bsonBytes: faultyBytes)
            XCTFail("expected decoding to fail, but returned \(decodedValue)")
        } catch Bool.Error.sizeMismatch {
            // This is expected
        }
    }

    // MARK: Int32

    /// Asserts decoding an `Int32` from valid data returns the expected value.
    func testInt32Parsed() throws {
        let value = Int32.random(in: .min ... .max)
        let decodedValue = try Int32(bsonBytes: value.bsonBytes)
        XCTAssertEqual(value, decodedValue)
    }

    /// Asserts decoding an `Int32` from less than 4 bytes throws `Int32.Error.sizeMismatch`.
    func testInt32SizeMismatch() throws {
        let faultyBytes = [UInt8](repeating: 1, count: 3)
        do {
            let decodedValue = try Int32(bsonBytes: faultyBytes)
            XCTFail("expected decoding to fail, but returned \(decodedValue)")
        } catch Int32.Error.sizeMismatch {
            // This is expected
        }
    }

    // MARK: UInt64

    /// Asserts decoding a `UInt64` from valid data returns the expected value.
    func testUInt64Parsed() throws {
        let value = UInt64.random(in: .min ... .max)
        let decodedValue = try UInt64(bsonBytes: value.bsonBytes)
        XCTAssertEqual(value, decodedValue)
    }

    /// Asserts decoding a `UInt64` from less than 4 bytes throws `UInt64.Error.sizeMismatch`.
    func testUInt64SizeMismatch() throws {
        let faultyBytes = [UInt8](repeating: 1, count: 3)
        do {
            let decodedValue = try UInt64(bsonBytes: faultyBytes)
            XCTFail("expected decoding to fail, but returned \(decodedValue)")
        } catch UInt64.Error.sizeMismatch {
            // This is expected
        }
    }

    // MARK: Int64

    /// Asserts decoding a `Int64` from valid data returns the expected value.
    func testInt64Parsed() throws {
        let value = Int64.random(in: .min ... .max)
        let decodedValue = try Int64(bsonBytes: value.bsonBytes)
        XCTAssertEqual(value, decodedValue)
    }

    /// Asserts decoding a `Int64` from less than 4 bytes throws `Int64.Error.sizeMismatch`.
    func testInt64SizeMismatch() throws {
        let faultyBytes = [UInt8](repeating: 1, count: 3)
        do {
            let decodedValue = try Int64(bsonBytes: faultyBytes)
            XCTFail("expected decoding to fail, but returned \(decodedValue)")
        } catch Int64.Error.sizeMismatch {
            // This is expected
        }
    }
}
