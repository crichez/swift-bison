//
//  ReadableValueTests.swift
//  Copyright 2022 Christopher Richez
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

import BisonRead
import BisonWrite
import XCTest

/// A test suite for the `ReadableValue.init(bsonBytes:)` initializer's code branches.
class ReadableValueTests: XCTestCase {
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
        } catch BisonError.sizeMismatch(let need, let have) {
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
        } catch BisonError.dataTooShort(let needAtLeast, let have) {
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
        } catch BisonError.sizeMismatch(let need, let have) {
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
        } catch BisonError.sizeMismatch(let need, let have) {
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
        } catch BisonError.sizeMismatch(let need, let have) {
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
        } catch BisonError.sizeMismatch(let need, let have) {
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
        } catch BisonError.sizeMismatch(let need, let have) {
            XCTAssertEqual(need, MemoryLayout<Int64>.size)
            XCTAssertEqual(have, faultyBytes.count)
        }
    }

    // MARK: Date

    func testDateParsed() throws {
        let value = Date()
        let decodedValue = try Date(bsonBytes: value.bsonBytes)
        let minTolerated = value - 0.001
        let maxTolerated = value + 0.001
        // The BSON date is a millisecond-precision value, so allow for some error
        XCTAssertTrue(decodedValue >= minTolerated) 
        XCTAssertTrue(decodedValue <= maxTolerated)
    }
}
