//
//  BSONUnkeyedEncodingContainerTests.swift
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
import BisonEncode
import BisonWrite
import XCTest
import Foundation

class BSONUnkeyedEncodingContainerTests: XCTestCase {
    enum Key: CodingKey {
        case test
    }

    func testEncodeDouble() throws {
        let value = Double.random(in: .leastNonzeroMagnitude ... .greatestFiniteMagnitude)
        let container = BSONUnkeyedEncodingContainer(codingPath: [])
        try container.encode(value)
        let expectedBytes = WritableDoc {
            "0" => value
        }
        .bsonBytes
        XCTAssertEqual(container.bsonBytes, expectedBytes)
    }

    func testEncodeString() throws {
        let value = "test"
        let container = BSONUnkeyedEncodingContainer(codingPath: [])
        try container.encode(value)
        let expectedBytes = WritableDoc {
            "0" => value
        }
        .bsonBytes
        XCTAssertEqual(container.bsonBytes, expectedBytes)
    }

    func testEncodeBool() throws {
        let value = Bool.random()
        let container = BSONUnkeyedEncodingContainer(codingPath: [])
        try container.encode(value)
        let expectedBytes = WritableDoc {
            "0" => value
        }
        .bsonBytes
        XCTAssertEqual(container.bsonBytes, expectedBytes)
    }

    func testEncodeNil() throws {
        let value = Int32?.none
        let container = BSONUnkeyedEncodingContainer(codingPath: [])
        try container.encodeNil()
        let expectedBytes = WritableDoc {
            "0" => value
        }
        .bsonBytes
        XCTAssertEqual(container.bsonBytes, expectedBytes)
    }

    func testEncodeInt32() throws {
        let value = Int32.random(in: .min ... .max)
        let container = BSONUnkeyedEncodingContainer(codingPath: [])
        try container.encode(value)
        let expectedBytes = WritableDoc {
            "0" => value
        }
        .bsonBytes
        XCTAssertEqual(container.bsonBytes, expectedBytes)
    }

    func testEncodeUInt64() throws {
        let value = UInt64.random(in: .min ... .max)
        let container = BSONUnkeyedEncodingContainer(codingPath: [])
        try container.encode(value)
        let expectedBytes = WritableDoc {
            "0" => value
        }
        .bsonBytes
        XCTAssertEqual(container.bsonBytes, expectedBytes)
    }

    func testEncodeInt64() throws {
        let value = Int64.random(in: .min ... .max)
        let container = BSONUnkeyedEncodingContainer(codingPath: [])
        try container.encode(value)
        let expectedBytes = WritableDoc {
            "0" => value
        }
        .bsonBytes
        XCTAssertEqual(container.bsonBytes, expectedBytes)
    }

    func testEncodeOptional() throws {
        let value: Int64? = Int64.random(in: .min ... .max)
        let container = BSONUnkeyedEncodingContainer(codingPath: [])
        try container.encode(value)
        let expectedBytes = WritableDoc {
            "0" => value
        }
        .bsonBytes
        XCTAssertEqual(container.bsonBytes, expectedBytes)
    }

    /// Asserts encoding a value that conforms to both `Encodable` and `WritableValue` uses its 
    /// BSON representation.
    /// 
    /// This test uses `Foundation.UUID` which is usually encoded as its `uuidString`.
    func testEncodeBSONValue() throws {
        let value = UUID()
        let container = BSONUnkeyedEncodingContainer(codingPath: [])
        try container.encode(value)
        let expectedDoc = WritableDoc {
            "0" => value
        }
        XCTAssertEqual(expectedDoc.bsonBytes, container.bsonBytes)
    }
    
    func testNestedKeyedContainer() throws {
        let value = "test"
        let container = BSONUnkeyedEncodingContainer(codingPath: [])
        var nestedContainer = container.nestedContainer(keyedBy: Key.self)
        try nestedContainer.encode(value, forKey: .test)
        let expectedBytes = WritableDoc {
            "0" => WritableDoc {
                "test" => value
            }
        }
        .bsonBytes
        XCTAssertEqual(container.bsonBytes, expectedBytes)
    }

    func testNestedUnkeyedContainer() throws {
        let value = "test"
        let container = BSONUnkeyedEncodingContainer(codingPath: [])
        var nestedContainer = container.nestedUnkeyedContainer()
        try nestedContainer.encode(value)
        let expectedBytes = WritableDoc {
            "0" => WritableArray {
                "0" => value
            }
        }
        .bsonBytes
        XCTAssertEqual(container.bsonBytes, expectedBytes)
    }

    func testSuperEncoder() throws {
        let value = false
        let container = BSONUnkeyedEncodingContainer(codingPath: [])
        let superEncoder = container.superEncoder()
        try value.encode(to: superEncoder)
        let expectedBytes = WritableDoc {
            "0" => value
        }
        .bsonBytes
        XCTAssertEqual(container.bsonBytes, expectedBytes)
    }
}