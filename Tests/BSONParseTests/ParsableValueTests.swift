//
//  ParsableValueTests.swift
//  ParsableValueTests
//
//  Created by Christopher Richez on March 20 2022
//

import BSONParse
import BSONCompose
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

    /// Asserts attempting to decode a `Double` from other than 8 bytes throws the appropriate
    /// error with the expected attached values.
    func testDoubleSizeMismatch() throws {
        let faultyBytes: [UInt8] = [0, 1, 2, 3]
        do {
            let decodedValue = try Double(bsonBytes: faultyBytes)
            XCTFail("expected decoding to fail, but returned \(decodedValue)")
        } catch ValueParseError.sizeMismatch(let need, let have) {
            XCTAssertEqual(need, MemoryLayout<Double>.size)
            XCTAssertEqual(have, faultyBytes.count)
        }
    }

    // MARK: String

    /// Asserts encoding and decoding a valid `String` returns the same value.
    func testStringParsed() throws {
        let value = "this is a test! \u{10097}"
        let decodedValue = try String(bsonBytes: value.bsonBytes)
        XCTAssertEqual(value, decodedValue)
    }

    /// Asserts attempting to decode a `String` from less than 5 bytes throws the appropriate
    /// error with the expected attached values.
    func testStringDataTooShort() throws {
        let faultyBytes: [UInt8] = [0, 1, 2]
        do {
            let decodedValue = try String(bsonBytes: faultyBytes)
            XCTFail("expected decoding to fail, but returned \(decodedValue)")
        } catch ValueParseError.dataTooShort(let needAtLeast, let have) {
            XCTAssertEqual(needAtLeast, 5)
            XCTAssertEqual(have, faultyBytes.count)
        }
    }

    /// Asserts attempting to decode a `String` with a declared size different from its
    /// actual size throws the appropriate error with the expected attached values.
    func testStringSizeMismatch() throws {
        let value = "this is a test! \u{10097}"
        var encodedValue = value.bsonBytes
        do {
            encodedValue.replaceSubrange(0..<4, with: Int32(100).bsonBytes)
            let decodedValue = try String(bsonBytes: encodedValue)
            XCTFail("expected decoding to fail, but returned \(decodedValue)")
        } catch ValueParseError.sizeMismatch(let need, let have) {
            XCTAssertEqual(need, 104)
            XCTAssertEqual(have, encodedValue.count)
        }
    }

    // MARK: Bool

    /// Asserts decoding a `Bool` from valid data returns the expected value.
    func testBoolParsed() throws {
        let value = Bool.random()
        let decodedValue = try Bool(bsonBytes: value.bsonBytes)
        XCTAssertEqual(value, decodedValue)
    }

    /// Asserts decoding a `Bool` from more than 1 byte throws the appropriate error with the
    /// expected attached values.
    func testBoolSizeMismatch() throws {
        let faultyBytes = [UInt8](repeating: 1, count: 3)
        do {
            let decodedValue = try Bool(bsonBytes: faultyBytes)
            XCTFail("expected decoding to fail, but returned \(decodedValue)")
        } catch ValueParseError.sizeMismatch(let need, let have) {
            XCTAssertEqual(need, MemoryLayout<Bool>.size)
            XCTAssertEqual(have, faultyBytes.count)
        }
    }

    // MARK: Int32

    /// Asserts decoding an `Int32` from valid data returns the expected value.
    func testInt32Parsed() throws {
        let value = Int32.random(in: .min ... .max)
        let decodedValue = try Int32(bsonBytes: value.bsonBytes)
        XCTAssertEqual(value, decodedValue)
    }

    /// Asserts decoding an `Int32` from less than 4 bytes throws the appropriate error with the
    /// expected attached values.
    func testInt32SizeMismatch() throws {
        let faultyBytes = [UInt8](repeating: 1, count: 3)
        do {
            let decodedValue = try Int32(bsonBytes: faultyBytes)
            XCTFail("expected decoding to fail, but returned \(decodedValue)")
        } catch ValueParseError.sizeMismatch(let need, let have) {
            XCTAssertEqual(need, MemoryLayout<Int32>.size)
            XCTAssertEqual(have, faultyBytes.count)
        }
    }

    // MARK: UInt64

    /// Asserts decoding a `UInt64` from valid data returns the expected value.
    func testUInt64Parsed() throws {
        let value = UInt64.random(in: .min ... .max)
        let decodedValue = try UInt64(bsonBytes: value.bsonBytes)
        XCTAssertEqual(value, decodedValue)
    }

    /// Asserts decoding a `UInt64` from less than 4 bytes throws the appropriate error with the
    /// expected attached values.
    func testUInt64SizeMismatch() throws {
        let faultyBytes = [UInt8](repeating: 1, count: 3)
        do {
            let decodedValue = try UInt64(bsonBytes: faultyBytes)
            XCTFail("expected decoding to fail, but returned \(decodedValue)")
        } catch ValueParseError.sizeMismatch(let need, let have) {
            XCTAssertEqual(need, MemoryLayout<UInt64>.size)
            XCTAssertEqual(have, faultyBytes.count)
        }
    }

    // MARK: Int64

    /// Asserts decoding a `Int64` from valid data returns the expected value.
    func testInt64Parsed() throws {
        let value = Int64.random(in: .min ... .max)
        let decodedValue = try Int64(bsonBytes: value.bsonBytes)
        XCTAssertEqual(value, decodedValue)
    }

    /// Asserts decoding a `Int64` from less than 4 bytes throws the appropriate error with the 
    /// expected attached values.
    func testInt64SizeMismatch() throws {
        let faultyBytes = [UInt8](repeating: 1, count: 3)
        do {
            let decodedValue = try Int64(bsonBytes: faultyBytes)
            XCTFail("expected decoding to fail, but returned \(decodedValue)")
        } catch ValueParseError.sizeMismatch(let need, let have) {
            XCTAssertEqual(need, MemoryLayout<Int64>.size)
            XCTAssertEqual(have, faultyBytes.count)
        }
    }
}
