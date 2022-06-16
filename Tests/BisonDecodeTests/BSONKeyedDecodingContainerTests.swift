//
//  BSONKeyedDecodingContainerTests.swift
//
//
//  Created by Christopher Richez on April 4 2022
//

@testable
import BisonDecode
import BisonWrite
import BisonRead
import XCTest

class BSONKeyedDecodingContainerTests: XCTestCase {
    enum Key: CodingKey, Equatable {
        case test
    }

    func testKeyNotFound() throws {
        let doc = WritableDoc {
            "hello" => "world!"
        }
        let parsedDoc = try ReadableDoc(bsonBytes: doc.bsonBytes)
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
        let doc = WritableDoc { 
            "test" => value 
        }
        let parsedDoc = try ReadableDoc(bsonBytes: doc.bsonBytes)
        let container = BSONKeyedDecodingContainer<[UInt8], Key>(doc: parsedDoc)
        XCTAssertTrue(try container.decodeNil(forKey: .test))
    }

    func testDecodeNilFalse() throws {
        let value: Double? = .random(in: .leastNonzeroMagnitude ... .greatestFiniteMagnitude)
        let doc = WritableDoc {
            "test" => value
        }
        let parsedDoc = try ReadableDoc(bsonBytes: doc.bsonBytes)
        let container = BSONKeyedDecodingContainer<[UInt8], Key>(doc: parsedDoc)
        XCTAssertFalse(try container.decodeNil(forKey: .test))
    }

    func testDouble() throws {
        let value = Double.random(in: .leastNonzeroMagnitude ... .greatestFiniteMagnitude)
        let doc = WritableDoc {
            "test" => value
        }
        let parsedDoc = try ReadableDoc(bsonBytes: doc.bsonBytes)
        let container = BSONKeyedDecodingContainer<[UInt8], Key>(doc: parsedDoc)
        XCTAssertEqual(try container.decode(Double.self, forKey: .test), value)
    }

    func testDoubleSizeMismatch() throws {
        let doc = WritableDoc {
            "test" => Int32(0)
        }
        let parsedDoc = try ReadableDoc(bsonBytes: doc.bsonBytes)
        let container = BSONKeyedDecodingContainer<[UInt8], Key>(doc: parsedDoc)
        do {
            let decodedValue = try container.decode(Double.self, forKey: .test)
            XCTFail("expected decoding to fail, but returned \(decodedValue)")
        } catch DecodingError.typeMismatch(let attemptedType, let context) {
            XCTAssert(attemptedType == Double.self)
            XCTAssertTrue(context.codingPath.isEmpty)
            let underlyingError = try XCTUnwrap(context.underlyingError as? BisonError)
            XCTAssertEqual(
                underlyingError, 
                BisonError.sizeMismatch(MemoryLayout<Double>.size, MemoryLayout<Int32>.size))
        }
    }

    func testString() throws {
        let doc = WritableDoc {
            "test" => "passed?"
        }
        let parsedDoc = try ReadableDoc(bsonBytes: doc.bsonBytes)
        let container = BSONKeyedDecodingContainer<[UInt8], Key>(doc: parsedDoc)
        XCTAssertEqual(try container.decode(String.self, forKey: .test), "passed?")
    }

    func testStringDataTooShort() throws {
        let doc = WritableDoc {
            "test" => Int32(0)
        }
        let parsedDoc = try ReadableDoc(bsonBytes: doc.bsonBytes)
        let container = BSONKeyedDecodingContainer<[UInt8], Key>(doc: parsedDoc)
        do {
            let decodedValue = try container.decode(String.self, forKey: .test)
            XCTFail("expected decoding to fail, but returned \(decodedValue)")
        } catch DecodingError.typeMismatch(let attempted, let context) {
            XCTAssert(attempted == String.self)
            XCTAssertTrue(context.codingPath.isEmpty)
            let underlyingError = try XCTUnwrap(context.underlyingError as? BisonError)
            XCTAssertEqual(underlyingError, .dataTooShort(5, MemoryLayout<Int32>.size))
        }
    }

    func testStringSizeMismatch() throws {
        let doc = WritableDoc {
            "test" => Int64(2)
        }
        let parsedDoc = try ReadableDoc(bsonBytes: doc.bsonBytes)
        let container = BSONKeyedDecodingContainer<[UInt8], Key>(doc: parsedDoc)
        do {
            let decodedValue = try container.decode(String.self, forKey: .test)
            XCTFail("expected decoding to fail, but returned \(decodedValue)")
        } catch DecodingError.typeMismatch(let attempted, let context) {
            XCTAssert(attempted == String.self)
            XCTAssertTrue(context.codingPath.isEmpty)
            let underlyingError = try XCTUnwrap(context.underlyingError as? BisonError)
            XCTAssertEqual(underlyingError, .sizeMismatch(6, 8))
        }
    }

    func testBool() throws {
        let doc = WritableDoc {
            "test" => false
        }
        let parsedDoc = try ReadableDoc(bsonBytes: doc.bsonBytes)
        let container = BSONKeyedDecodingContainer<[UInt8], Key>(doc: parsedDoc)
        XCTAssertFalse(try container.decode(Bool.self, forKey: .test))
    }

    func testBoolSizeMismatch() throws {
        let doc = WritableDoc {
            "test" => UInt64(0)
        }
        let parsedDoc = try ReadableDoc(bsonBytes: doc.bsonBytes)
        let container = BSONKeyedDecodingContainer<[UInt8], Key>(doc: parsedDoc)
        do {
            let decodedValue = try container.decode(Bool.self, forKey: .test)
            XCTFail("expected decoding to fail, but returned \(decodedValue)")
        } catch DecodingError.typeMismatch(let attempted, let context) {
            XCTAssert(attempted == Bool.self)
            XCTAssertTrue(context.codingPath.isEmpty)
            let underlyingError = try XCTUnwrap(context.underlyingError as? BisonError)
            XCTAssertEqual(
                underlyingError, 
                .sizeMismatch(MemoryLayout<Bool>.size, MemoryLayout<UInt64>.size))
        }
    }

    func testInt32() throws {
        let value = Int32.random(in: .min ... .max)
        let doc = WritableDoc {
            "test" => value
        }
        let parsedDoc = try ReadableDoc(bsonBytes: doc.bsonBytes)
        let container = BSONKeyedDecodingContainer<[UInt8], Key>(doc: parsedDoc)
        XCTAssertEqual(try container.decode(Int32.self, forKey: .test), value)
    }

    func testInt32SizeMismatch() throws {
        let doc = WritableDoc {
            "test" => UInt64(0)
        }
        let parsedDoc = try ReadableDoc(bsonBytes: doc.bsonBytes)
        let container = BSONKeyedDecodingContainer<[UInt8], Key>(doc: parsedDoc)
        do {
            let decodedValue = try container.decode(Int32.self, forKey: .test)
            XCTFail("expected decoding to fail, but returned \(decodedValue)")
        } catch DecodingError.typeMismatch(let attempted, let context) {
            XCTAssert(attempted == Int32.self)
            XCTAssertTrue(context.codingPath.isEmpty)
            let underlyingError = try XCTUnwrap(context.underlyingError as? BisonError)
            XCTAssertEqual(
                underlyingError, 
                .sizeMismatch(MemoryLayout<Int32>.size, MemoryLayout<UInt64>.size))
        }
    }

    func testInt64() throws {
        let value = Int64.random(in: .min ... .max)
        let doc = WritableDoc {
            "test" => value
        }
        let parsedDoc = try ReadableDoc(bsonBytes: doc.bsonBytes)
        let container = BSONKeyedDecodingContainer<[UInt8], Key>(doc: parsedDoc)
        XCTAssertEqual(try container.decode(Int64.self, forKey: .test), value)
    }

    func testInt64SizeMismatch() throws {
        let doc = WritableDoc {
            "test" => Int32(0)
        }
        let parsedDoc = try ReadableDoc(bsonBytes: doc.bsonBytes)
        let container = BSONKeyedDecodingContainer<[UInt8], Key>(doc: parsedDoc)
        do {
            let decodedValue = try container.decode(Int64.self, forKey: .test)
            XCTFail("expected decoding to fail, but returned \(decodedValue)")
        } catch DecodingError.typeMismatch(let attempted, let context) {
            XCTAssert(attempted == Int64.self)
            XCTAssertTrue(context.codingPath.isEmpty)
            let underlyingError = try XCTUnwrap(context.underlyingError as? BisonError)
            XCTAssertEqual(
                underlyingError, 
                .sizeMismatch(MemoryLayout<Int64>.size, MemoryLayout<Int32>.size))
        }
    }

    func testUInt64() throws {
        let value = UInt64.random(in: .min ... .max)
        let doc = WritableDoc {
            "test" => value
        }
        let parsedDoc = try ReadableDoc(bsonBytes: doc.bsonBytes)
        let container = BSONKeyedDecodingContainer<[UInt8], Key>(doc: parsedDoc)
        XCTAssertEqual(try container.decode(UInt64.self, forKey: .test), value)
    }

    func testUInt64SizeMismatch() throws {
        let doc = WritableDoc {
            "test" => Int32(0)
        }
        let parsedDoc = try ReadableDoc(bsonBytes: doc.bsonBytes)
        let container = BSONKeyedDecodingContainer<[UInt8], Key>(doc: parsedDoc)
        do {
            let decodedValue = try container.decode(UInt64.self, forKey: .test)
            XCTFail("expected decoding to fail, but returned \(decodedValue)")
        } catch DecodingError.typeMismatch(let attempted, let context) {
            XCTAssert(attempted == UInt64.self)
            XCTAssertTrue(context.codingPath.isEmpty)
            let underlyingError = try XCTUnwrap(context.underlyingError as? BisonError)
            XCTAssertEqual(
                underlyingError, 
                .sizeMismatch(MemoryLayout<UInt64>.size, MemoryLayout<Int32>.size))
        }
    }

    func testOptional() throws {
        let value: Int64? = .random(in: .min ... .max)
        let doc = WritableDoc {
            "test" => value
        }
        let parsedDoc = try ReadableDoc(bsonBytes: doc.bsonBytes)
        let container = BSONKeyedDecodingContainer<[UInt8], Key>(doc: parsedDoc)
        XCTAssertEqual(try container.decode(Int64?.self, forKey: .test), value)
    }

    /// Asserts decoding a value that conforms to both `Decodable` and `ReadableValue` returns
    /// the expected value even when it is encoded using its BSON representation.
    /// 
    /// This test uses `Foundation.Data`, which would normally be decoded as a nested
    /// array document of `UInt64` values.
    func testDecodeBSONValue() throws {
        let value = Data([1, 2, 3, 4])
        let doc = WritableDoc {
            "test" => value
        }
        let parsedDoc = try ReadableDoc(bsonBytes: doc.bsonBytes)
        let container = BSONKeyedDecodingContainer<[UInt8], Key>(doc: parsedDoc)
        XCTAssertEqual(try container.decode(Data.self, forKey: .test), value)
    }

    func testNestedContainer() throws {
        let value = "passed?"
        let doc = WritableDoc {
            "test" => WritableDoc {
                "test" => value
            }
        }
        let parsedDoc = try ReadableDoc(bsonBytes: doc.bsonBytes)
        let container = BSONKeyedDecodingContainer<[UInt8], Key>(doc: parsedDoc)
        let nestedContainer = try container.nestedContainer(keyedBy: Key.self, forKey: .test)
        XCTAssertEqual(try nestedContainer.decode(String.self, forKey: .test), value)
    }

    func testNestedContainerDataTooShort() throws {
        let doc = WritableDoc {
            "test" => Int32.random(in: .min ... .max)
        }
        let parsedDoc = try ReadableDoc(bsonBytes: doc.bsonBytes)
        let container = BSONKeyedDecodingContainer<[UInt8], Key>(doc: parsedDoc)
        do {
            let decodedValue = try container.nestedContainer(keyedBy: Key.self, forKey: .test)
            XCTFail("expected decoding to fail, but returned \(decodedValue)")
        } catch DecodingError.typeMismatch(let attempted, let context) {
            XCTAssert(attempted == KeyedDecodingContainer<Key>.self)
            XCTAssertTrue(context.codingPath.isEmpty)
            let underlyingError = context.underlyingError 
                as? ReadableDoc<Array<UInt8>.SubSequence>.Error
            let unwrappedError = try XCTUnwrap(underlyingError)
            XCTAssertEqual(unwrappedError, .docTooShort)
        }
    }

    func testNestedUnkeyedContainer() throws {
        let value = "passed?"
        let doc = WritableDoc {
            "test" => WritableArray {
                "0" => value
            }
        }
        let parsedDoc = try ReadableDoc(bsonBytes: doc.bsonBytes)
        let container = BSONKeyedDecodingContainer<[UInt8], Key>(doc: parsedDoc)
        var nestedContainer = try container.nestedUnkeyedContainer(forKey: .test)
        XCTAssertEqual(try nestedContainer.decode(String.self), value)
    }

    func testSuperDecoderNoKey() throws {
        let value = Bool.random()
        let doc = WritableDoc {
            "super" => value
        }
        let parsedDoc = try ReadableDoc(bsonBytes: doc.bsonBytes)
        let container = BSONKeyedDecodingContainer<[UInt8], Key>(doc: parsedDoc)
        let superDecoder = try container.superDecoder()
        XCTAssertEqual(try Bool(from: superDecoder), value)
    }

    func testSuperDecoderWithKey() throws {
        let value = Bool.random()
        let doc = WritableDoc {
            "test" => value
        }
        let parsedDoc = try ReadableDoc(bsonBytes: doc.bsonBytes)
        let container = BSONKeyedDecodingContainer<[UInt8], Key>(doc: parsedDoc)
        let superDecoder = try container.superDecoder(forKey: .test)
        XCTAssertEqual(try Bool(from: superDecoder), value)
    }
}
