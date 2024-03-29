//
//  BSONUnkeyedDecodingContainerTests.swift
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

@testable
import BisonDecode
import BisonWrite
import BisonRead
import XCTest

class BSONUnkeyedDecodingContainerTests: XCTestCase {
    func testDecodeNil() throws {
        let value = Int64?.none
        let doc = WritableDoc {
            "0" => value
        }
        let parsedDoc = try ReadableDoc(bsonBytes: doc.bsonBytes)
        var container = BSONUnkeyedDecodingContainer(doc: parsedDoc)
        XCTAssertTrue(try container.decodeNil())
    }

    func testDecodeNilFalse() throws {
        let value: Int64? = .random(in: .min ... .max)
        let doc = WritableDoc {
            "0" => value
        }
        let parsedDoc = try ReadableDoc(bsonBytes: doc.bsonBytes)
        var container = BSONUnkeyedDecodingContainer(doc: parsedDoc)
        XCTAssertFalse(try container.decodeNil())
    }

    func testDouble() throws {
        let value = Double.random(in: .leastNonzeroMagnitude ... .greatestFiniteMagnitude)
        let doc = WritableDoc {
            "0" => value
        }
        let parsedDoc = try ReadableDoc(bsonBytes: doc.bsonBytes)
        var container = BSONUnkeyedDecodingContainer(doc: parsedDoc)
        XCTAssertEqual(try container.decode(Double.self), value)
    }

    func testDoubleSizeMismatch() throws {
        let value = Bool.random()
        let doc = WritableDoc { "0" => value }
        let parsedDoc = try ReadableDoc(bsonBytes: doc.bsonBytes)
        var container = BSONUnkeyedDecodingContainer(doc: parsedDoc)
        do {
            let decodedValue = try container.decode(Double.self)
            XCTFail("expected decoding to fail, but returned \(decodedValue)")
        } catch DecodingError.typeMismatch(let attempted, let context) {
            XCTAssert(attempted == Double.self)
            XCTAssertTrue(context.codingPath.isEmpty)
            let underlyingError = try XCTUnwrap(
                context.underlyingError as? ValueError)
            XCTAssertEqual(
                underlyingError, 
                .sizeMismatch(expected: MemoryLayout<Double>.size, have: MemoryLayout<Bool>.size))
        }
    }

    func testString() throws {
        let value = "test"
        let doc = WritableDoc { "0" => value }
        let parsedDoc = try ReadableDoc(bsonBytes: doc.bsonBytes)
        var container = BSONUnkeyedDecodingContainer(doc: parsedDoc)
        XCTAssertEqual(try container.decode(String.self), value)
    }

    func testStringDataTooShort() throws {
        let value = Bool.random()
        let doc = WritableDoc { "0" => value }
        let parsedDoc = try ReadableDoc(bsonBytes: doc.bsonBytes)
        var container = BSONUnkeyedDecodingContainer(doc: parsedDoc)
        do {
            let decodedValue = try container.decode(String.self)
            XCTFail("expected decoding to fail, but returned \(decodedValue)")
        } catch DecodingError.typeMismatch(let attempted, let context) {
            XCTAssert(attempted == String.self)
            XCTAssertTrue(context.codingPath.isEmpty)
            let underlyingError = try XCTUnwrap(
                context.underlyingError as? ValueError)
            XCTAssertEqual(underlyingError, .dataTooShort(
                needAtLeast: 5, 
                found: MemoryLayout<Bool>.size))
        }
    }

    func testStringSizeMismatch() throws {
        let value = Int64(9)
        let doc = WritableDoc { "0" => value }
        let parsedDoc = try ReadableDoc(bsonBytes: doc.bsonBytes)
        var container = BSONUnkeyedDecodingContainer(doc: parsedDoc)
        do {
            let decodedValue = try container.decode(String.self)
            XCTFail("expected decoding to fail, but returned \(decodedValue)")
        } catch DecodingError.typeMismatch(let attempted, let context) {
            XCTAssert(attempted == String.self)
            XCTAssertTrue(context.codingPath.isEmpty)
            let underlyingError = try XCTUnwrap(
                context.underlyingError as? ValueError)
            XCTAssertEqual(underlyingError, .sizeMismatch(
                expected: 13, 
                have: MemoryLayout<Int64>.size))
        }
    }

    func testBool() throws {
        let value = Bool.random()
        let doc = WritableDoc { "0" => value }
        let parsedDoc = try ReadableDoc(bsonBytes: doc.bsonBytes)
        var container = BSONUnkeyedDecodingContainer(doc: parsedDoc)
        XCTAssertEqual(try container.decode(Bool.self), value)
    }

    func testBoolSizeMismatch() throws {
        let value = Double.random(in: .leastNonzeroMagnitude ... .greatestFiniteMagnitude)
        let doc = WritableDoc { "0" => value }
        let parsedDoc = try ReadableDoc(bsonBytes: doc.bsonBytes)
        var container = BSONUnkeyedDecodingContainer(doc: parsedDoc)
        do {
            let decodedValue = try container.decode(Bool.self)
            XCTFail("expected decoding to fail, but returned \(decodedValue)")
        } catch DecodingError.typeMismatch(let attempted, let context) {
            XCTAssert(attempted == Bool.self)
            XCTAssertTrue(context.codingPath.isEmpty)
            let underlyingError = try XCTUnwrap(
                context.underlyingError as? ValueError)
            XCTAssertEqual(
                underlyingError, 
                .sizeMismatch(expected: MemoryLayout<Bool>.size, have: MemoryLayout<Double>.size))
        }
    }

    func testInt32() throws {
        let value = Int32.random(in: .min ... .max)
        let doc = WritableDoc { "0" => value }
        let parsedDoc = try ReadableDoc(bsonBytes: doc.bsonBytes)
        var container = BSONUnkeyedDecodingContainer(doc: parsedDoc)
        XCTAssertEqual(try container.decode(Int32.self), value)
    }

    func testInt32SizeMismatch() throws {
        let value = Double.random(in: .leastNonzeroMagnitude ... .greatestFiniteMagnitude)
        let doc = WritableDoc { "0" => value }
        let parsedDoc = try ReadableDoc(bsonBytes: doc.bsonBytes)
        var container = BSONUnkeyedDecodingContainer(doc: parsedDoc)
        do {
            let decodedValue = try container.decode(Int32.self)
            XCTFail("expected decoding to fail, but returned \(decodedValue)")
        } catch DecodingError.typeMismatch(let attempted, let context) {
            XCTAssert(attempted == Int32.self)
            XCTAssertTrue(context.codingPath.isEmpty)
            let underlyingError = try XCTUnwrap(
                context.underlyingError as? ValueError)
            XCTAssertEqual(
                underlyingError, 
                .sizeMismatch(expected: MemoryLayout<Int32>.size, have: MemoryLayout<Double>.size))
        }
    }

    func testInt64() throws {
        let value = Int64.random(in: .min ... .max)
        let doc = WritableDoc { "0" => value }
        let parsedDoc = try ReadableDoc(bsonBytes: doc.bsonBytes)
        var container = BSONUnkeyedDecodingContainer(doc: parsedDoc)
        XCTAssertEqual(try container.decode(Int64.self), value)
    }

    func testInt64SizeMismatch() throws {
        let value = Int32.random(in: .min ... .max)
        let doc = WritableDoc { "0" => value }
        let parsedDoc = try ReadableDoc(bsonBytes: doc.bsonBytes)
        var container = BSONUnkeyedDecodingContainer(doc: parsedDoc)
        do {
            let decodedValue = try container.decode(Int64.self)
            XCTFail("expected decoding to fail, but returned \(decodedValue)")
        } catch DecodingError.typeMismatch(let attempted, let context) {
            XCTAssert(attempted == Int64.self)
            XCTAssertTrue(context.codingPath.isEmpty)
            let underlyingError = try XCTUnwrap(
                context.underlyingError as? ValueError)
            XCTAssertEqual(
                underlyingError, 
                .sizeMismatch(expected: MemoryLayout<Int64>.size, have: MemoryLayout<Int32>.size))
        }
    }

    func testUInt64() throws {
        let value = UInt64.random(in: .min ... .max)
        let doc = WritableDoc { "0" => value }
        let parsedDoc = try ReadableDoc(bsonBytes: doc.bsonBytes)
        var container = BSONUnkeyedDecodingContainer(doc: parsedDoc)
        XCTAssertEqual(try container.decode(UInt64.self), value)
    }

    func testUInt64SizeMismatch() throws {
        let value = Int32.random(in: .min ... .max)
        let doc = WritableDoc { "0" => value }
        let parsedDoc = try ReadableDoc(bsonBytes: doc.bsonBytes)
        var container = BSONUnkeyedDecodingContainer(doc: parsedDoc)
        do {
            let decodedValue = try container.decode(UInt64.self)
            XCTFail("expected decoding to fail, but returned \(decodedValue)")
        } catch DecodingError.typeMismatch(let attempted, let context) {
            XCTAssert(attempted == UInt64.self)
            XCTAssertTrue(context.codingPath.isEmpty)
            let underlyingError = try XCTUnwrap(
                context.underlyingError as? ValueError)
            XCTAssertEqual(
                underlyingError, 
                .sizeMismatch(expected: MemoryLayout<UInt64>.size, have: MemoryLayout<Int32>.size))
        }
    }

    func testOptional() throws {
        let value: String? = "test"
        let doc = WritableDoc { "0" => value }
        let parsedDoc = try ReadableDoc(bsonBytes: doc.bsonBytes)
        var container = BSONUnkeyedDecodingContainer(doc: parsedDoc)
        XCTAssertEqual(try container.decode(String?.self), value)
    }

    /// Asserts decoding a value that conforms to both `Decodable` and `ReadableValue` returns
    /// the expected value even when it is encoded using its BSON representation.
    /// 
    /// This test uses `Foundation.UUID`, which would normally be decoded as its `uuidString`.
    func testDecodeBSONValue() throws {
        let value = UUID()
        let doc = WritableDoc {
            "0" => value
        }
        let parsedDoc = try ReadableDoc(bsonBytes: doc.bsonBytes)
        var container = BSONUnkeyedDecodingContainer<[UInt8]>(doc: parsedDoc)
        XCTAssertEqual(try container.decode(UUID.self), value)
    }

    enum Key: CodingKey {
        case test
    }

    func testNestedContainer() throws {
        let value = Bool.random()
        let doc = WritableDoc { 
            "0" => WritableDoc {
                "test" => value
            }
        }
        let parsedDoc = try ReadableDoc(bsonBytes: doc.bsonBytes)
        var container = BSONUnkeyedDecodingContainer(doc: parsedDoc)
        let nestedContainer = try container.nestedContainer(keyedBy: Key.self)
        XCTAssertEqual(try nestedContainer.decode(Bool.self, forKey: .test), value)
    }

    func testNestedUnkeyedContainer() throws {
        let value = Bool.random()
        let doc = WritableDoc { 
            "0" => WritableArray {
                value
            }
        }
        let parsedDoc = try ReadableDoc(bsonBytes: doc.bsonBytes)
        var container = BSONUnkeyedDecodingContainer(doc: parsedDoc)
        var nestedContainer = try container.nestedUnkeyedContainer()
        XCTAssertEqual(try nestedContainer.decode(Bool.self), value)
    }

    func testSuperDecoder() throws {
        let value = Bool.random()
        let doc = WritableDoc { 
            "0" => value
        }
        let parsedDoc = try ReadableDoc(bsonBytes: doc.bsonBytes)
        var container = BSONUnkeyedDecodingContainer(doc: parsedDoc)
        let superDecoder = try container.superDecoder()
        XCTAssertEqual(try Bool(from: superDecoder), value)
    }
}