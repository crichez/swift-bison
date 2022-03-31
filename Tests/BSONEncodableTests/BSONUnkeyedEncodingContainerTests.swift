//
//  BSONUnkeyedEncodingContainerTests.swift
//
//
//  Created by Christopher Richez on March 31 2022
//

@testable
import BSONEncodable
import BSONCompose
import XCTest

class BSONUnkeyedEncodingContainerTests: XCTestCase {
    enum Key: CodingKey {
        case test
    }

    func testEncodeDouble() throws {
        let value = Double.random(in: .leastNonzeroMagnitude ... .greatestFiniteMagnitude)
        let container = BSONUnkeyedEncodingContainer(codingPath: [])
        try container.encode(value)
        let expectedBytes = ComposedDocument {
            "0" => value
        }
        .bsonBytes
        XCTAssertEqual(container.bsonBytes, expectedBytes)
    }

    func testEncodeString() throws {
        let value = "test"
        let container = BSONUnkeyedEncodingContainer(codingPath: [])
        try container.encode(value)
        let expectedBytes = ComposedDocument {
            "0" => value
        }
        .bsonBytes
        XCTAssertEqual(container.bsonBytes, expectedBytes)
    }

    func testEncodeBool() throws {
        let value = Bool.random()
        let container = BSONUnkeyedEncodingContainer(codingPath: [])
        try container.encode(value)
        let expectedBytes = ComposedDocument {
            "0" => value
        }
        .bsonBytes
        XCTAssertEqual(container.bsonBytes, expectedBytes)
    }

    func testEncodeNil() throws {
        let value = Int32?.none
        let container = BSONUnkeyedEncodingContainer(codingPath: [])
        try container.encodeNil()
        let expectedBytes = ComposedDocument {
            "0" => value
        }
        .bsonBytes
        XCTAssertEqual(container.bsonBytes, expectedBytes)
    }

    func testEncodeInt32() throws {
        let value = Int32.random(in: .min ... .max)
        let container = BSONUnkeyedEncodingContainer(codingPath: [])
        try container.encode(value)
        let expectedBytes = ComposedDocument {
            "0" => value
        }
        .bsonBytes
        XCTAssertEqual(container.bsonBytes, expectedBytes)
    }

    func testEncodeUInt64() throws {
        let value = UInt64.random(in: .min ... .max)
        let container = BSONUnkeyedEncodingContainer(codingPath: [])
        try container.encode(value)
        let expectedBytes = ComposedDocument {
            "0" => value
        }
        .bsonBytes
        XCTAssertEqual(container.bsonBytes, expectedBytes)
    }

    func testEncodeInt64() throws {
        let value = Int64.random(in: .min ... .max)
        let container = BSONUnkeyedEncodingContainer(codingPath: [])
        try container.encode(value)
        let expectedBytes = ComposedDocument {
            "0" => value
        }
        .bsonBytes
        XCTAssertEqual(container.bsonBytes, expectedBytes)
    }

    func testEncodeOptional() throws {
        try XCTSkipIf(true, "not implemented")
        let value: Int64? = Int64.random(in: .min ... .max)
        let container = BSONUnkeyedEncodingContainer(codingPath: [])
        try container.encode(value)
        let expectedBytes = ComposedDocument {
            "0" => value
        }
        .bsonBytes
        XCTAssertEqual(container.bsonBytes, expectedBytes)
    }
    
    func testNestedKeyedContainer() throws {
        let value = "test"
        let container = BSONUnkeyedEncodingContainer(codingPath: [])
        var nestedContainer = container.nestedContainer(keyedBy: Key.self)
        try nestedContainer.encode(value, forKey: .test)
        let expectedBytes = ComposedDocument {
            "0" => ComposedDocument {
                "test" => value
            }
        }
        .bsonBytes
        XCTAssertEqual(container.bsonBytes, expectedBytes)
    }

    func testNestedUnkeyedContainer() throws {
        try XCTSkipIf(true, "no array documents in BSONCompose yet")
        let value = "test"
        let container = BSONUnkeyedEncodingContainer(codingPath: [])
        var nestedContainer = container.nestedUnkeyedContainer()
        try nestedContainer.encode(value)
        let expectedBytes = ComposedDocument {
            "0" => ComposedDocument {
                "0" => value
            }
        }
        .bsonBytes
        XCTAssertEqual(container.bsonBytes, expectedBytes)
    }

    func testSuperEncoder() throws {
        try XCTSkipIf(true, "not implemented")
        let value = false
        let container = BSONUnkeyedEncodingContainer(codingPath: [])
        let superEncoder = container.superEncoder()
        try value.encode(to: superEncoder)
        let expectedBytes = ComposedDocument {
            "0" => value
        }
        .bsonBytes
        XCTAssertEqual(container.bsonBytes, expectedBytes)
    }
}