//
//  BSONSingleValueDecodingContainerTests.swift
//
//
//  Created by Christopher Richez on April 3 2022
//

@testable
import BSONDecodable
import BSONCompose
import BSONParse
import XCTest

class BSONSingleValueDecodingContainerTests: XCTestCase {
    func testDecodeNil() throws {
        var bytes: [UInt8] = []
        let trueContainer = BSONSingleValueDecodingContainer(contents: bytes, codingPath: [])
        XCTAssertTrue(trueContainer.decodeNil())
        bytes.append(1)
        let falseContainer = BSONSingleValueDecodingContainer(contents: bytes, codingPath: [])
        XCTAssertFalse(falseContainer.decodeNil())
    }

    // MARK: Bool

    func testBool() throws {
        let value = Bool.random()
        let container = BSONSingleValueDecodingContainer(contents: value.bsonBytes, codingPath: [])
        XCTAssertEqual(try container.decode(Bool.self), value)
    }

    func testBoolSizeMismatch() throws {
        do {
            let container = BSONSingleValueDecodingContainer(contents: [1, 2, 3], codingPath: [])
            let decodedValue = try container.decode(Bool.self)
            XCTFail("expected decoding to fail, but returned \(decodedValue)")
        } catch DecodingError.typeMismatch(let attemptedType, let context) {
            XCTAssert(attemptedType == Bool.self)
            XCTAssertTrue(context.codingPath.isEmpty)
            let underlyingError = try XCTUnwrap(context.underlyingError as? Bool.Error)
            XCTAssertEqual(underlyingError, .sizeMismatch)
        }
    }

    // MARK: Double

    func testDouble() throws {
        let value = Double.random(in: .leastNonzeroMagnitude ... .greatestFiniteMagnitude)
        let container = BSONSingleValueDecodingContainer(contents: value.bsonBytes, codingPath: [])
        XCTAssertEqual(try container.decode(Double.self), value)
    }

    func testDoubleSizeMismatch() throws {
        do {
            let container = BSONSingleValueDecodingContainer(contents: [1, 2, 3], codingPath: [])
            let decodedValue = try container.decode(Double.self)
            XCTFail("expected decoding to fail, but returned \(decodedValue)")
        } catch DecodingError.typeMismatch(let attemptedType, let context) {
            XCTAssert(attemptedType == Double.self)
            XCTAssertTrue(context.codingPath.isEmpty)
            let underlyingError = try XCTUnwrap(context.underlyingError as? Double.Error)
            XCTAssertEqual(underlyingError, .sizeMismatch)
        }
    }

    // MARK: String

    func testString() throws {
        let value = "test"
        let container = BSONSingleValueDecodingContainer(contents: value.bsonBytes, codingPath: [])
        XCTAssertEqual(try container.decode(String.self), value)
    }

    func testStringDataTooShort() throws {
        do {
            let container = BSONSingleValueDecodingContainer(contents: [1, 2, 3], codingPath: [])
            let decodedValue = try container.decode(String.self)
            XCTFail("expected decoding to fail, but returned \(decodedValue)")
        } catch DecodingError.typeMismatch(let attemptedType, let context) {
            XCTAssert(attemptedType == String.self)
            XCTAssertTrue(context.codingPath.isEmpty)
            let underlyingError = try XCTUnwrap(context.underlyingError as? String.Error)
            XCTAssertEqual(underlyingError, .dataTooShort)
        }
    }

    func testStringSizeMismatch() throws {
        do {
            let container = BSONSingleValueDecodingContainer(
                contents: [9, 0, 0, 0, 0], 
                codingPath: [])
            let decodedValue = try container.decode(String.self)
            XCTFail("expected decoding to fail, but returned \(decodedValue)")
        } catch DecodingError.typeMismatch(let attemptedType, let context) {
            XCTAssert(attemptedType == String.self)
            XCTAssertTrue(context.codingPath.isEmpty)
            let underlyingError = try XCTUnwrap(context.underlyingError as? String.Error)
            XCTAssertEqual(underlyingError, .sizeMismatch)
        }
    }

    // MARK: Int32

    func testInt32() throws {
        let value = Int32.random(in: .min ... .max)
        let container = BSONSingleValueDecodingContainer(contents: value.bsonBytes, codingPath: [])
        XCTAssertEqual(try container.decode(Int32.self), value)
    }

    func testInt32SizeMismatch() throws {
        do {
            let container = BSONSingleValueDecodingContainer(contents: [1, 2, 3], codingPath: [])
            let decodedValue = try container.decode(Int32.self)
            XCTFail("expected decoding to fail, but returned \(decodedValue)")
        } catch DecodingError.typeMismatch(let attemptedType, let context) {
            XCTAssert(attemptedType == Int32.self)
            XCTAssertTrue(context.codingPath.isEmpty)
            let underlyingError = try XCTUnwrap(context.underlyingError as? Int32.Error)
            XCTAssertEqual(underlyingError, .sizeMismatch)
        }
    }

    // MARK: UInt64

    func testUInt64() throws {
        let value = UInt64.random(in: .min ... .max)
        let container = BSONSingleValueDecodingContainer(contents: value.bsonBytes, codingPath: [])
        XCTAssertEqual(try container.decode(UInt64.self), value)
    }

    func testUInt64SizeMismatch() throws {
        do {
            let container = BSONSingleValueDecodingContainer(contents: [1, 2, 3], codingPath: [])
            let decodedValue = try container.decode(UInt64.self)
            XCTFail("expected decoding to fail, but returned \(decodedValue)")
        } catch DecodingError.typeMismatch(let attemptedType, let context) {
            XCTAssert(attemptedType == UInt64.self)
            XCTAssertTrue(context.codingPath.isEmpty)
            let underlyingError = try XCTUnwrap(context.underlyingError as? UInt64.Error)
            XCTAssertEqual(underlyingError, .sizeMismatch)
        }
    }

    // MARK: Int64

    func testInt64() throws {
        let value = Int64.random(in: .min ... .max)
        let container = BSONSingleValueDecodingContainer(contents: value.bsonBytes, codingPath: [])
        XCTAssertEqual(try container.decode(Int64.self), value)
    }

    func testInt64SizeMismatch() throws {
        do {
            let container = BSONSingleValueDecodingContainer(contents: [1, 2, 3], codingPath: [])
            let decodedValue = try container.decode(Int64.self)
            XCTFail("expected decoding to fail, but returned \(decodedValue)")
        } catch DecodingError.typeMismatch(let attemptedType, let context) {
            XCTAssert(attemptedType == Int64.self)
            XCTAssertTrue(context.codingPath.isEmpty)
            let underlyingError = try XCTUnwrap(context.underlyingError as? Int64.Error)
            XCTAssertEqual(underlyingError, .sizeMismatch)
        }
    }

    // MARK: Optional

    func testOptional() throws {
        let value: Int32? = .random(in: .min ... .max)
        let container = BSONSingleValueDecodingContainer(contents: value.bsonBytes, codingPath: [])
        XCTAssertEqual(try container.decode(Int32?.self), value)
    }
}