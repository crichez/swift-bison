//
//  BSONKeyedDecodingContainerTests.swift
//
//
//  Created by Christopher Richez on April 4 2022
//

@testable
import BSONDecodable
import BSONCompose
import BSONParse
import XCTest

class BSONKeyedDecodingContainerTests: XCTestCase {
    enum Key: CodingKey, Equatable {
        case test
    }

    func testKeyNotFound() throws {
        let doc = ComposedDocument {
            "hello" => "world!"
        }
        let parsedDoc = try ParsedDocument(bsonBytes: doc.bsonBytes)
        let container = BSONKeyedDecodingContainer<[UInt8], Key>(doc: parsedDoc)
        do {
            let decodedValue = try container.decode(String.self, forKey: .test)
            XCTFail("expected decoding to fail, but returned \(decodedValue)")
        } catch DecodingError.keyNotFound(let key, let context) {
            let key = try XCTUnwrap(key as? Key)
            XCTAssertEqual(key, .test)
            XCTAssertTrue(context.codingPath.isEmpty)
            XCTAssertNil(context.underlyingError)
        }
    }

    func testDecodeNil() throws {
        let value = Double?.none
        let doc = ComposedDocument { 
            "test" => value 
        }
        let parsedDoc = try ParsedDocument(bsonBytes: doc.bsonBytes)
        let container = BSONKeyedDecodingContainer<[UInt8], Key>(doc: parsedDoc)
        XCTAssertTrue(try container.decodeNil(forKey: .test))
    }

    func testDecodeNilFalse() throws {
        let value: Double? = .random(in: .leastNonzeroMagnitude ... .greatestFiniteMagnitude)
        let doc = ComposedDocument {
            "test" => value
        }
        let parsedDoc = try ParsedDocument(bsonBytes: doc.bsonBytes)
        let container = BSONKeyedDecodingContainer<[UInt8], Key>(doc: parsedDoc)
        XCTAssertFalse(try container.decodeNil(forKey: .test))
    }

    func testDouble() throws {
        let value = Double.random(in: .leastNonzeroMagnitude ... .greatestFiniteMagnitude)
        let doc = ComposedDocument {
            "test" => value
        }
        let parsedDoc = try ParsedDocument(bsonBytes: doc.bsonBytes)
        let container = BSONKeyedDecodingContainer<[UInt8], Key>(doc: parsedDoc)
        XCTAssertEqual(try container.decode(Double.self, forKey: .test), value)
    }

    func testDoubleSizeMismatch() throws {
        let doc = ComposedDocument {
            "test" => Int32(0)
        }
        let parsedDoc = try ParsedDocument(bsonBytes: doc.bsonBytes)
        let container = BSONKeyedDecodingContainer<[UInt8], Key>(doc: parsedDoc)
        do {
            let decodedValue = try container.decode(Double.self, forKey: .test)
            XCTFail("expected decoding to fail, but returned \(decodedValue)")
        } catch DecodingError.typeMismatch(let attemptedType, let context) {
            XCTAssert(attemptedType == Double.self)
            XCTAssertTrue(context.codingPath.isEmpty)
            let underlyingError = try XCTUnwrap(context.underlyingError as? Double.Error)
            XCTAssertEqual(underlyingError, Double.Error.sizeMismatch)
        }
    }

    func testString() throws {
        let doc = ComposedDocument {
            "test" => "passed?"
        }
        let parsedDoc = try ParsedDocument(bsonBytes: doc.bsonBytes)
        let container = BSONKeyedDecodingContainer<[UInt8], Key>(doc: parsedDoc)
        XCTAssertEqual(try container.decode(String.self, forKey: .test), "passed?")
    }

    func testStringDataTooShort() throws {
        let doc = ComposedDocument {
            "test" => Int32(0)
        }
        let parsedDoc = try ParsedDocument(bsonBytes: doc.bsonBytes)
        let container = BSONKeyedDecodingContainer<[UInt8], Key>(doc: parsedDoc)
        do {
            let decodedValue = try container.decode(String.self, forKey: .test)
            XCTFail("expected decoding to fail, but returned \(decodedValue)")
        } catch DecodingError.typeMismatch(let attempted, let context) {
            XCTAssert(attempted == String.self)
            XCTAssertTrue(context.codingPath.isEmpty)
            let underlyingError = try XCTUnwrap(context.underlyingError as? String.Error)
            XCTAssertEqual(underlyingError, .dataTooShort)
        }
    }

    func testStringSizeMismatch() throws {
        let doc = ComposedDocument {
            "test" => Int64(2)
        }
        let parsedDoc = try ParsedDocument(bsonBytes: doc.bsonBytes)
        let container = BSONKeyedDecodingContainer<[UInt8], Key>(doc: parsedDoc)
        do {
            let decodedValue = try container.decode(String.self, forKey: .test)
            XCTFail("expected decoding to fail, but returned \(decodedValue)")
        } catch DecodingError.typeMismatch(let attempted, let context) {
            XCTAssert(attempted == String.self)
            XCTAssertTrue(context.codingPath.isEmpty)
            let underlyingError = try XCTUnwrap(context.underlyingError as? String.Error)
            XCTAssertEqual(underlyingError, .sizeMismatch)
        }
    }

    func testBool() throws {
        let doc = ComposedDocument {
            "test" => false
        }
        let parsedDoc = try ParsedDocument(bsonBytes: doc.bsonBytes)
        let container = BSONKeyedDecodingContainer<[UInt8], Key>(doc: parsedDoc)
        XCTAssertFalse(try container.decode(Bool.self, forKey: .test))
    }

    func testBoolSizeMismatch() throws {
        let doc = ComposedDocument {
            "test" => UInt64(0)
        }
        let parsedDoc = try ParsedDocument(bsonBytes: doc.bsonBytes)
        let container = BSONKeyedDecodingContainer<[UInt8], Key>(doc: parsedDoc)
        do {
            let decodedValue = try container.decode(Bool.self, forKey: .test)
            XCTFail("expected decoding to fail, but returned \(decodedValue)")
        } catch DecodingError.typeMismatch(let attempted, let context) {
            XCTAssert(attempted == Bool.self)
            XCTAssertTrue(context.codingPath.isEmpty)
            let underlyingError = try XCTUnwrap(context.underlyingError as? Bool.Error)
            XCTAssertEqual(underlyingError, .sizeMismatch)
        }
    }

    func testInt32() throws {
        let value = Int32.random(in: .min ... .max)
        let doc = ComposedDocument {
            "test" => value
        }
        let parsedDoc = try ParsedDocument(bsonBytes: doc.bsonBytes)
        let container = BSONKeyedDecodingContainer<[UInt8], Key>(doc: parsedDoc)
        XCTAssertEqual(try container.decode(Int32.self, forKey: .test), value)
    }

    func testInt32SizeMismatch() throws {
        let doc = ComposedDocument {
            "test" => UInt64(0)
        }
        let parsedDoc = try ParsedDocument(bsonBytes: doc.bsonBytes)
        let container = BSONKeyedDecodingContainer<[UInt8], Key>(doc: parsedDoc)
        do {
            let decodedValue = try container.decode(Int32.self, forKey: .test)
            XCTFail("expected decoding to fail, but returned \(decodedValue)")
        } catch DecodingError.typeMismatch(let attempted, let context) {
            XCTAssert(attempted == Int32.self)
            XCTAssertTrue(context.codingPath.isEmpty)
            let underlyingError = try XCTUnwrap(context.underlyingError as? Int32.Error)
            XCTAssertEqual(underlyingError, .sizeMismatch)
        }
    }

    func testInt64() throws {
        let value = Int64.random(in: .min ... .max)
        let doc = ComposedDocument {
            "test" => value
        }
        let parsedDoc = try ParsedDocument(bsonBytes: doc.bsonBytes)
        let container = BSONKeyedDecodingContainer<[UInt8], Key>(doc: parsedDoc)
        XCTAssertEqual(try container.decode(Int64.self, forKey: .test), value)
    }

    func testInt64SizeMismatch() throws {
        let doc = ComposedDocument {
            "test" => Int32(0)
        }
        let parsedDoc = try ParsedDocument(bsonBytes: doc.bsonBytes)
        let container = BSONKeyedDecodingContainer<[UInt8], Key>(doc: parsedDoc)
        do {
            let decodedValue = try container.decode(Int64.self, forKey: .test)
            XCTFail("expected decoding to fail, but returned \(decodedValue)")
        } catch DecodingError.typeMismatch(let attempted, let context) {
            XCTAssert(attempted == Int64.self)
            XCTAssertTrue(context.codingPath.isEmpty)
            let underlyingError = try XCTUnwrap(context.underlyingError as? Int64.Error)
            XCTAssertEqual(underlyingError, .sizeMismatch)
        }
    }

    func testUInt64() throws {
        let value = UInt64.random(in: .min ... .max)
        let doc = ComposedDocument {
            "test" => value
        }
        let parsedDoc = try ParsedDocument(bsonBytes: doc.bsonBytes)
        let container = BSONKeyedDecodingContainer<[UInt8], Key>(doc: parsedDoc)
        XCTAssertEqual(try container.decode(UInt64.self, forKey: .test), value)
    }

    func testUInt64SizeMismatch() throws {
        let doc = ComposedDocument {
            "test" => Int32(0)
        }
        let parsedDoc = try ParsedDocument(bsonBytes: doc.bsonBytes)
        let container = BSONKeyedDecodingContainer<[UInt8], Key>(doc: parsedDoc)
        do {
            let decodedValue = try container.decode(UInt64.self, forKey: .test)
            XCTFail("expected decoding to fail, but returned \(decodedValue)")
        } catch DecodingError.typeMismatch(let attempted, let context) {
            XCTAssert(attempted == UInt64.self)
            XCTAssertTrue(context.codingPath.isEmpty)
            let underlyingError = try XCTUnwrap(context.underlyingError as? UInt64.Error)
            XCTAssertEqual(underlyingError, .sizeMismatch)
        }
    }

    func testOptional() throws {
        try XCTSkipIf(true, "not implemented")
        let value: Int64? = .random(in: .min ... .max)
        let doc = ComposedDocument {
            "test" => value
        }
        let parsedDoc = try ParsedDocument(bsonBytes: doc.bsonBytes)
        let container = BSONKeyedDecodingContainer<[UInt8], Key>(doc: parsedDoc)
        XCTAssertEqual(try container.decode(Int64?.self, forKey: .test), value)
    }

    func testNestedContainer() throws {
        let value = "passed?"
        let doc = ComposedDocument {
            "test" => ComposedDocument {
                "test" => value
            }
        }
        let parsedDoc = try ParsedDocument(bsonBytes: doc.bsonBytes)
        let container = BSONKeyedDecodingContainer<[UInt8], Key>(doc: parsedDoc)
        let nestedContainer = try container.nestedContainer(keyedBy: Key.self, forKey: .test)
        XCTAssertEqual(try nestedContainer.decode(String.self, forKey: .test), value)
    }

    func testNestedContainerDataTooShort() throws {
        let doc = ComposedDocument {
            "test" => Int32.random(in: .min ... .max)
        }
        let parsedDoc = try ParsedDocument(bsonBytes: doc.bsonBytes)
        let container = BSONKeyedDecodingContainer<[UInt8], Key>(doc: parsedDoc)
        do {
            let decodedValue = try container.nestedContainer(keyedBy: Key.self, forKey: .test)
            XCTFail("expected decoding to fail, but returned \(decodedValue)")
        } catch DecodingError.typeMismatch(let attempted, let context) {
            XCTAssert(attempted == KeyedDecodingContainer<Key>.self)
            XCTAssertTrue(context.codingPath.isEmpty)
            let underlyingError = context.underlyingError 
                as? ParsedDocument<Array<UInt8>.SubSequence>.Error
            let unwrappedError = try XCTUnwrap(underlyingError)
            XCTAssertEqual(unwrappedError, .docTooShort)
        }
    }

    func testNestedUnkeyedContainer() throws {
        let value = "passed?"
        let doc = ComposedDocument {
            "test" => ComposedArrayDocument {
                "0" => value
            }
        }
        let parsedDoc = try ParsedDocument(bsonBytes: doc.bsonBytes)
        let container = BSONKeyedDecodingContainer<[UInt8], Key>(doc: parsedDoc)
        var nestedContainer = try container.nestedUnkeyedContainer(forKey: .test)
        XCTAssertEqual(try nestedContainer.decode(String.self), value)
    }

    func testSuperDecoderNoKey() throws {
        try XCTSkipIf(true, "not implemented")
        let value = Bool.random()
        let doc = ComposedDocument {
            "super" => value
        }
        let parsedDoc = try ParsedDocument(bsonBytes: doc.bsonBytes)
        let container = BSONKeyedDecodingContainer<[UInt8], Key>(doc: parsedDoc)
        let superDecoder = try container.superDecoder()
        XCTAssertEqual(try Bool(from: superDecoder), value)
    }

    func testSuperDecoderWithKey() throws {
        try XCTSkipIf(true, "not implemented")
        let value = Bool.random()
        let doc = ComposedDocument {
            "test" => value
        }
        let parsedDoc = try ParsedDocument(bsonBytes: doc.bsonBytes)
        let container = BSONKeyedDecodingContainer<[UInt8], Key>(doc: parsedDoc)
        let superDecoder = try container.superDecoder(forKey: .test)
        XCTAssertEqual(try Bool(from: superDecoder), value)
    }
}
