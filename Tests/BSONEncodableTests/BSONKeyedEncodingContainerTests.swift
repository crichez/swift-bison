//
// BSONKeyedEncodingContainerTests.swift
//
//
//  Created by Christopher Richez on March 31 2022
//

@testable
import BSONEncodable
import BSONCompose
import XCTest

class BSONKeyedEncodingContainerTests: XCTestCase {
    enum Key: CodingKey {
        case test, `super`
    }

    func testEncodeNil() throws {
        let container = BSONKeyedEncodingContainer<Key>(codingPath: [])
        try container.encodeNil(forKey: .test)
        let expectedBytes = ComposedDocument {
            "test" => Int32?.none
        }
        .bsonBytes
        XCTAssertEqual(container.bsonBytes, expectedBytes)
    }

    func testEncodeDouble() throws {
        let value = Double.random(in: .leastNonzeroMagnitude ... .greatestFiniteMagnitude)
        let container = BSONKeyedEncodingContainer<Key>(codingPath: [])
        try container.encode(value, forKey: .test)
        let expectedBytes = ComposedDocument {
            "test" => value
        }
        .bsonBytes
        XCTAssertEqual(container.bsonBytes, expectedBytes)
    }

    func testEncodeString() throws {
        let value = "test"
        let container = BSONKeyedEncodingContainer<Key>(codingPath: [])
        try container.encode(value, forKey: .test)
        let expectedBytes = ComposedDocument {
            "test" => value
        }
        .bsonBytes
        XCTAssertEqual(container.bsonBytes, expectedBytes)
    }

    func testEncodeBool() throws {
        let value = Bool.random()
        let container = BSONKeyedEncodingContainer<Key>(codingPath: [])
        try container.encode(value, forKey: .test)
        let expectedBytes = ComposedDocument {
            "test" => value
        }
        .bsonBytes
        XCTAssertEqual(container.bsonBytes, expectedBytes)
    }

    func testEncodeInt32() throws {
        let value = Int32.random(in: .min ... .max)
        let container = BSONKeyedEncodingContainer<Key>(codingPath: [])
        try container.encode(value, forKey: .test)
        let expectedBytes = ComposedDocument {
            "test" => value
        }
        .bsonBytes
        XCTAssertEqual(container.bsonBytes, expectedBytes)
    }

    func testEncodeInt64() throws {
        let value = Int64.random(in: .min ... .max)
        let container = BSONKeyedEncodingContainer<Key>(codingPath: [])
        try container.encode(value, forKey: .test)
        let expectedBytes = ComposedDocument {
            "test" => value
        }
        .bsonBytes
        XCTAssertEqual(container.bsonBytes, expectedBytes)
    }

    func testEncodeUInt64() throws {
        let value = UInt64.random(in: .min ... .max)
        let container = BSONKeyedEncodingContainer<Key>(codingPath: [])
        try container.encode(value, forKey: .test)
        let expectedBytes = ComposedDocument {
            "test" => value
        }
        .bsonBytes
        XCTAssertEqual(container.bsonBytes, expectedBytes)
    }

    func testEncodeOptional() throws {
        try XCTSkipIf(true, "not implemented")
        let value: UInt64? = UInt64.random(in: .min ... .max)
        let container = BSONKeyedEncodingContainer<Key>(codingPath: [])
        try container.encode(value, forKey: .test)
        let expectedBytes = ComposedDocument {
            "test" => value
        }
        .bsonBytes
        XCTAssertEqual(container.bsonBytes, expectedBytes)
    }

    func testNestedKeyedContainer() throws {
        let value = UInt64.random(in: .min ... .max)
        let container = BSONKeyedEncodingContainer<Key>(codingPath: [])
        var nestedContainer = container.nestedContainer(keyedBy: Key.self, forKey: .test)
        try nestedContainer.encode(value, forKey: .test)
        let expectedBytes = ComposedDocument {
            "test" => ComposedDocument {
                "test" => value
            }
        }
        .bsonBytes
        XCTAssertEqual(container.bsonBytes, expectedBytes)
    }

    func testNestedUnkeyedContainer() throws {
        try XCTSkipIf(true, "we don't have a way to encode an array document in BSONCompose yet")
        let value: UInt64? = UInt64.random(in: .min ... .max)
        let container = BSONKeyedEncodingContainer<Key>(codingPath: [])
        var nestedContainer = container.nestedUnkeyedContainer(forKey: .test)
        try nestedContainer.encode(value)
        let expectedBytes = ComposedDocument {
            "test" => ComposedDocument {
                "0" => value
            }
        }
        .bsonBytes
        XCTAssertEqual(container.bsonBytes, expectedBytes)
    }

    func testSuperEncoderNoKey() throws {
        try XCTSkipIf(true, "reference semantics not yet implemented on this container")
        let value = UInt64.random(in: .min ... .max)
        let container = BSONKeyedEncodingContainer<Key>(codingPath: [])
        let superEncoder = container.superEncoder()
        try value.encode(to: superEncoder)
        let expectedBytes = ComposedDocument {
            "super" => value
        }
        .bsonBytes
        XCTAssertEqual(container.bsonBytes, expectedBytes)
    }

    func testSuperEncoderForKey() throws {
        try XCTSkipIf(true, "reference semantics not yet implemented on this container")
        let value = UInt64.random(in: .min ... .max)
        let container = BSONKeyedEncodingContainer<Key>(codingPath: [])
        let superEncoder = container.superEncoder(forKey: .test)
        try value.encode(to: superEncoder)
        let expectedBytes = ComposedDocument {
            "test" => value
        }
        .bsonBytes
        XCTAssertEqual(container.bsonBytes, expectedBytes)
    }
}  