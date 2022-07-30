//
//  BSONKeyedEncodingContainerTests.swift
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

extension WritableValue {
    var bsonBytes: [UInt8] {
        var buffer: [UInt8] = []
        append(to: &buffer)
        return buffer
    }
}

class BSONKeyedEncodingContainerTests: XCTestCase {
    enum Key: CodingKey {
        case test, `super`
    }

    func testEncodeNil() throws {
        let container = BSONKeyedEncodingContainer<Key>(codingPath: [])
        try container.encodeNil(forKey: .test)
        let expectedBytes = WritableDoc {
            "test" => Int32?.none
        }
        .bsonBytes
        XCTAssertEqual(container.bsonBytes, expectedBytes)
    }

    func testEncodeDouble() throws {
        let value = Double.random(in: .leastNonzeroMagnitude ... .greatestFiniteMagnitude)
        let container = BSONKeyedEncodingContainer<Key>(codingPath: [])
        try container.encode(value, forKey: .test)
        let expectedBytes = WritableDoc {
            "test" => value
        }
        .bsonBytes
        XCTAssertEqual(container.bsonBytes, expectedBytes)
    }

    func testEncodeString() throws {
        let value = "test"
        let container = BSONKeyedEncodingContainer<Key>(codingPath: [])
        try container.encode(value, forKey: .test)
        let expectedBytes = WritableDoc {
            "test" => value
        }
        .bsonBytes
        XCTAssertEqual(container.bsonBytes, expectedBytes)
    }

    func testEncodeBool() throws {
        let value = Bool.random()
        let container = BSONKeyedEncodingContainer<Key>(codingPath: [])
        try container.encode(value, forKey: .test)
        let expectedBytes = WritableDoc {
            "test" => value
        }
        .bsonBytes
        XCTAssertEqual(container.bsonBytes, expectedBytes)
    }

    func testEncodeInt32() throws {
        let value = Int32.random(in: .min ... .max)
        let container = BSONKeyedEncodingContainer<Key>(codingPath: [])
        try container.encode(value, forKey: .test)
        let expectedBytes = WritableDoc {
            "test" => value
        }
        .bsonBytes
        XCTAssertEqual(container.bsonBytes, expectedBytes)
    }

    func testEncodeInt64() throws {
        let value = Int64.random(in: .min ... .max)
        let container = BSONKeyedEncodingContainer<Key>(codingPath: [])
        try container.encode(value, forKey: .test)
        let expectedBytes = WritableDoc {
            "test" => value
        }
        .bsonBytes
        XCTAssertEqual(container.bsonBytes, expectedBytes)
    }

    func testEncodeUInt64() throws {
        let value = UInt64.random(in: .min ... .max)
        let container = BSONKeyedEncodingContainer<Key>(codingPath: [])
        try container.encode(value, forKey: .test)
        let expectedBytes = WritableDoc {
            "test" => value
        }
        .bsonBytes
        XCTAssertEqual(container.bsonBytes, expectedBytes)
    }

    func testEncodeOptional() throws {
        let value: UInt64? = UInt64.random(in: .min ... .max)
        let container = BSONKeyedEncodingContainer<Key>(codingPath: [])
        try container.encode(value, forKey: .test)
        let expectedBytes = WritableDoc {
            "test" => value
        }
        .bsonBytes
        XCTAssertEqual(container.bsonBytes, expectedBytes)
    }

    /// Asserts encoding a value that is both `Encodable` and conforms to `WritableValue` uses
    /// its BSON representation instead of its `Encodable` representation.
    /// 
    /// This test uses `Foundation.UUID`, which is usually encoded as its `uuidString`.
    func testEncodeBSONValue() throws {
        let value = UUID()
        let container = BSONKeyedEncodingContainer<Key>(codingPath: [])
        try container.encode(value, forKey: .test)
        let expectedDoc = WritableDoc {
            "test" => value
        }
        XCTAssertEqual(expectedDoc.bsonBytes, container.bsonBytes)
    }

    func testNestedKeyedContainer() throws {
        let value = UInt64.random(in: .min ... .max)
        let container = BSONKeyedEncodingContainer<Key>(codingPath: [])
        var nestedContainer = container.nestedContainer(keyedBy: Key.self, forKey: .test)
        try nestedContainer.encode(value, forKey: .test)
        let expectedBytes = WritableDoc {
            "test" => WritableDoc {
                "test" => value
            }
        }
        .bsonBytes
        XCTAssertEqual(container.bsonBytes, expectedBytes)
    }

    func testNestedUnkeyedContainer() throws {
        let value: UInt64? = UInt64.random(in: .min ... .max)
        let container = BSONKeyedEncodingContainer<Key>(codingPath: [])
        var nestedContainer = container.nestedUnkeyedContainer(forKey: .test)
        try nestedContainer.encode(value)
        let expectedBytes = WritableDoc {
            "test" => WritableArray {
                value
            }
        }
        .bsonBytes
        XCTAssertEqual(container.bsonBytes, expectedBytes)
    }

    func testSuperEncoderNoKey() throws {
        let value = UInt64.random(in: .min ... .max)
        let container = BSONKeyedEncodingContainer<Key>(codingPath: [])
        let superEncoder = container.superEncoder()
        try value.encode(to: superEncoder)
        let expectedBytes = WritableDoc {
            "super" => value
        }
        .bsonBytes
        XCTAssertEqual(container.bsonBytes, expectedBytes)
    }

    func testSuperEncoderForKey() throws {
        let value = UInt64.random(in: .min ... .max)
        let container = BSONKeyedEncodingContainer<Key>(codingPath: [])
        let superEncoder = container.superEncoder(forKey: .test)
        try value.encode(to: superEncoder)
        let expectedBytes = WritableDoc {
            "test" => value
        }
        .bsonBytes
        XCTAssertEqual(container.bsonBytes, expectedBytes)
    }
}  