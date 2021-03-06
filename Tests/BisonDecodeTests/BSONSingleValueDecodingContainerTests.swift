//
//  BSONSingleValueDecodingContainerTests.swift
//
//
//  Created by Christopher Richez on April 3 2022
//

@testable
import BisonDecode
import BisonWrite
import BisonRead
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
        let container = BSONSingleValueDecodingContainer(contents: [1, 2, 3], codingPath: [])
        do {
            let decodedValue = try container.decode(Bool.self)
            XCTFail("expected decoding to fail, but returned \(decodedValue)")
        } catch DecodingError.typeMismatch(let attemptedType, let context) {
            XCTAssert(attemptedType == Bool.self)
            XCTAssertTrue(context.codingPath.isEmpty)
            let underlyingError = try XCTUnwrap(context.underlyingError as? BisonError)
            XCTAssertEqual(
                underlyingError, 
                .sizeMismatch(MemoryLayout<Bool>.size, container.contents.count))
        }
    }

    // MARK: Double

    func testDouble() throws {
        let value = Double.random(in: .leastNonzeroMagnitude ... .greatestFiniteMagnitude)
        let container = BSONSingleValueDecodingContainer(contents: value.bsonBytes, codingPath: [])
        XCTAssertEqual(try container.decode(Double.self), value)
    }

    func testDoubleSizeMismatch() throws {
        let container = BSONSingleValueDecodingContainer(contents: [1, 2, 3], codingPath: [])
        do {
            let decodedValue = try container.decode(Double.self)
            XCTFail("expected decoding to fail, but returned \(decodedValue)")
        } catch DecodingError.typeMismatch(let attemptedType, let context) {
            XCTAssert(attemptedType == Double.self)
            XCTAssertTrue(context.codingPath.isEmpty)
            let underlyingError = try XCTUnwrap(context.underlyingError as? BisonError)
            XCTAssertEqual(
                underlyingError, 
                .sizeMismatch(MemoryLayout<Double>.size, container.contents.count))
        }
    }

    // MARK: String

    func testString() throws {
        let value = "test"
        let container = BSONSingleValueDecodingContainer(contents: value.bsonBytes, codingPath: [])
        XCTAssertEqual(try container.decode(String.self), value)
    }

    func testStringDataTooShort() throws {
        let container = BSONSingleValueDecodingContainer(contents: [1, 2, 3], codingPath: [])
        do {
            let decodedValue = try container.decode(String.self)
            XCTFail("expected decoding to fail, but returned \(decodedValue)")
        } catch DecodingError.typeMismatch(let attemptedType, let context) {
            XCTAssert(attemptedType == String.self)
            XCTAssertTrue(context.codingPath.isEmpty)
            let underlyingError = try XCTUnwrap(context.underlyingError as? BisonError)
            XCTAssertEqual(
                underlyingError, 
                .dataTooShort(5, container.contents.count))
        }
    }

    func testStringSizeMismatch() throws {
        let container = BSONSingleValueDecodingContainer(
            contents: [9, 0, 0, 0, 0], 
            codingPath: [])
        do {
            let decodedValue = try container.decode(String.self)
            XCTFail("expected decoding to fail, but returned \(decodedValue)")
        } catch DecodingError.typeMismatch(let attemptedType, let context) {
            XCTAssert(attemptedType == String.self)
            XCTAssertTrue(context.codingPath.isEmpty)
            let underlyingError = try XCTUnwrap(context.underlyingError as? BisonError)
            XCTAssertEqual(
                underlyingError, 
                .sizeMismatch(13, container.contents.count))
        }
    }

    // MARK: Int32

    func testInt32() throws {
        let value = Int32.random(in: .min ... .max)
        let container = BSONSingleValueDecodingContainer(contents: value.bsonBytes, codingPath: [])
        XCTAssertEqual(try container.decode(Int32.self), value)
    }

    func testInt32SizeMismatch() throws {
        let container = BSONSingleValueDecodingContainer(contents: [1, 2, 3], codingPath: [])
        do {
            let decodedValue = try container.decode(Int32.self)
            XCTFail("expected decoding to fail, but returned \(decodedValue)")
        } catch DecodingError.typeMismatch(let attemptedType, let context) {
            XCTAssert(attemptedType == Int32.self)
            XCTAssertTrue(context.codingPath.isEmpty)
            let underlyingError = try XCTUnwrap(context.underlyingError as? BisonError)
            XCTAssertEqual(
                underlyingError, 
                .sizeMismatch(MemoryLayout<Int32>.size, container.contents.count))
        }
    }

    // MARK: UInt64

    func testUInt64() throws {
        let value = UInt64.random(in: .min ... .max)
        let container = BSONSingleValueDecodingContainer(contents: value.bsonBytes, codingPath: [])
        XCTAssertEqual(try container.decode(UInt64.self), value)
    }

    func testUInt64SizeMismatch() throws {
        let container = BSONSingleValueDecodingContainer(contents: [1, 2, 3], codingPath: [])
        do {
            let decodedValue = try container.decode(UInt64.self)
            XCTFail("expected decoding to fail, but returned \(decodedValue)")
        } catch DecodingError.typeMismatch(let attemptedType, let context) {
            XCTAssert(attemptedType == UInt64.self)
            XCTAssertTrue(context.codingPath.isEmpty)
            let underlyingError = try XCTUnwrap(context.underlyingError as? BisonError)
            XCTAssertEqual(
                underlyingError, 
                .sizeMismatch(MemoryLayout<UInt64>.size, container.contents.count))
        }
    }

    // MARK: Int64

    func testInt64() throws {
        let value = Int64.random(in: .min ... .max)
        let container = BSONSingleValueDecodingContainer(contents: value.bsonBytes, codingPath: [])
        XCTAssertEqual(try container.decode(Int64.self), value)
    }

    func testInt64SizeMismatch() throws {
        let container = BSONSingleValueDecodingContainer(contents: [1, 2, 3], codingPath: [])
        do {
            let decodedValue = try container.decode(Int64.self)
            XCTFail("expected decoding to fail, but returned \(decodedValue)")
        } catch DecodingError.typeMismatch(let attemptedType, let context) {
            XCTAssert(attemptedType == Int64.self)
            XCTAssertTrue(context.codingPath.isEmpty)
            let underlyingError = try XCTUnwrap(context.underlyingError as? BisonError)
            XCTAssertEqual(
                underlyingError, 
                .sizeMismatch(MemoryLayout<Int64>.size, container.contents.count))
        }
    }

    // MARK: Generic

    func testOptional() throws {
        let value: Int32? = .random(in: .min ... .max)
        let container = BSONSingleValueDecodingContainer(contents: value.bsonBytes, codingPath: [])
        XCTAssertEqual(try container.decode(Int32?.self), value)
    }

    /// Asserts decoding a value that conforms to both `Decodable` and `ReadableValue` returns
    /// the expected value even when it is encoded using its BSON representation.
    /// 
    /// This test uses `Foundation.Data`, which would normally be decoded as a nested
    /// array document of `UInt64` values.
    func testDecodeBSONValue() throws {
        let value = Data([1, 2, 3, 4])
        let container = BSONSingleValueDecodingContainer<[UInt8]>(
            contents: value.bsonBytes, 
            codingPath: [])
        XCTAssertEqual(try container.decode(Data.self), value)
    }
}