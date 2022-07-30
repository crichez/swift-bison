//
//  BSONSingleValueEncodingContainerTests.swift
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

class BSONSingleValueEncodingContainerTests: XCTestCase {
    func testEncodeDouble() throws {
        let value = Double.random(in: .leastNonzeroMagnitude ... .greatestFiniteMagnitude)
        let container = BSONSingleValueEncodingContainer(codingPath: [])
        try container.encode(value)
        let expectedBytes = value.bsonBytes
        XCTAssertEqual(container.bsonBytes, expectedBytes)
        let expectedType = value.bsonType
        XCTAssertEqual(container.bsonType, expectedType)
    }

    func testEncodeNil() throws {
        let container = BSONSingleValueEncodingContainer(codingPath: [])
        try container.encodeNil()
        let expectedBytes = Optional<Bool>.none.bsonBytes
        XCTAssertEqual(container.bsonBytes, expectedBytes)
        let expectedType = Optional<Bool>.none.bsonType
        XCTAssertEqual(container.bsonType, expectedType)
    }

    func testEncodeString() throws {
        let value = "test"
        let container = BSONSingleValueEncodingContainer(codingPath: [])
        try container.encode(value)
        let expectedBytes = value.bsonBytes
        XCTAssertEqual(container.bsonBytes, expectedBytes)
        let expectedType = value.bsonType
        XCTAssertEqual(container.bsonType, expectedType)
    }

    func testEncodeBool() throws {
        let value = Bool.random()
        let container = BSONSingleValueEncodingContainer(codingPath: [])
        try container.encode(value)
        let expectedBytes = value.bsonBytes
        XCTAssertEqual(container.bsonBytes, expectedBytes)
        let expectedType = value.bsonType
        XCTAssertEqual(container.bsonType, expectedType)
    }
    
    func testEncodeInt32() throws {
        let value = Int32.random(in: .min ... .max)
        let container = BSONSingleValueEncodingContainer(codingPath: [])
        try container.encode(value)
        let expectedBytes = value.bsonBytes
        XCTAssertEqual(container.bsonBytes, expectedBytes)
        let expectedType = value.bsonType
        XCTAssertEqual(container.bsonType, expectedType)
    }
    
    func testEncodeUInt64() throws {
        let value = UInt64.random(in: .min ... .max)
        let container = BSONSingleValueEncodingContainer(codingPath: [])
        try container.encode(value)
        let expectedBytes = value.bsonBytes
        XCTAssertEqual(container.bsonBytes, expectedBytes)
        let expectedType = value.bsonType
        XCTAssertEqual(container.bsonType, expectedType)
    }
    
    func testEncodeInt64() throws {
        let value = Int64.random(in: .min ... .max)
        let container = BSONSingleValueEncodingContainer(codingPath: [])
        try container.encode(value)
        let expectedBytes = value.bsonBytes
        XCTAssertEqual(container.bsonBytes, expectedBytes)
        let expectedType = value.bsonType
        XCTAssertEqual(container.bsonType, expectedType)
    }
    
    func testEncodeInt() throws {
        let value = Int.random(in: .min ... .max)
        let container = BSONSingleValueEncodingContainer(codingPath: [])
        try container.encode(value)
        let expectedBytes = value.bitWidth == 32 ? Int32(value).bsonBytes : Int64(value).bsonBytes
        XCTAssertEqual(container.bsonBytes, expectedBytes)
        let expectedType = value.bitWidth == 32 ? Int32(value).bsonType : Int64(value).bsonType
        XCTAssertEqual(container.bsonType, expectedType)
    }
    
    func testEncodeInt8() throws {
        let value = Int8.random(in: .min ... .max)
        let container = BSONSingleValueEncodingContainer(codingPath: [])
        try container.encode(value)
        let expectedBytes = Int32(value).bsonBytes
        XCTAssertEqual(container.bsonBytes, expectedBytes)
        let expectedType = Int32(value).bsonType
        XCTAssertEqual(container.bsonType, expectedType)
    }
    
    func testEncodeInt16() throws {
        let value = Int16.random(in: .min ... .max)
        let container = BSONSingleValueEncodingContainer(codingPath: [])
        try container.encode(value)
        let expectedBytes = Int32(value).bsonBytes
        XCTAssertEqual(container.bsonBytes, expectedBytes)
        let expectedType = Int32(value).bsonType
        XCTAssertEqual(container.bsonType, expectedType)
    }
    
    func testEncodeUInt8() throws {
        let value = UInt8.random(in: .min ... .max)
        let container = BSONSingleValueEncodingContainer(codingPath: [])
        try container.encode(value)
        let expectedBytes = UInt64(value).bsonBytes
        XCTAssertEqual(container.bsonBytes, expectedBytes)
        let expectedType = UInt64(value).bsonType
        XCTAssertEqual(container.bsonType, expectedType)
    }
    
    func testEncodeUInt16() throws {
        let value = UInt16.random(in: .min ... .max)
        let container = BSONSingleValueEncodingContainer(codingPath: [])
        try container.encode(value)
        let expectedBytes = UInt64(value).bsonBytes
        XCTAssertEqual(container.bsonBytes, expectedBytes)
        let expectedType = UInt64(value).bsonType
        XCTAssertEqual(container.bsonType, expectedType)
    }
    
    func testEncodeUInt32() throws {
        let value = UInt32.random(in: .min ... .max)
        let container = BSONSingleValueEncodingContainer(codingPath: [])
        try container.encode(value)
        let expectedBytes = UInt64(value).bsonBytes
        XCTAssertEqual(container.bsonBytes, expectedBytes)
        let expectedType = UInt64(value).bsonType
        XCTAssertEqual(container.bsonType, expectedType)
    }
    
    func testEncodeFloat() throws {
        let value = Float.random(in: .leastNonzeroMagnitude ... .greatestFiniteMagnitude)
        let container = BSONSingleValueEncodingContainer(codingPath: [])
        try container.encode(value)
        let expectedBytes = Double(value).bsonBytes
        XCTAssertEqual(container.bsonBytes, expectedBytes)
        let expectedType = Double(value).bsonType
        XCTAssertEqual(container.bsonType, expectedType)
    }

    func testEncodeOptional() throws {
        let value: String? = "test"
        let container = BSONSingleValueEncodingContainer(codingPath: [])
        try container.encode(value)
        let expectedBytes = value.bsonBytes
        XCTAssertEqual(container.bsonBytes, expectedBytes)
        let expectedType = value.bsonType
        XCTAssertEqual(container.bsonType, expectedType)
    }

    /// Asserts encoding a value that conforms to both `Encodable` and `WritableValue` uses its
    /// BSON representation.
    /// 
    /// This test uses `Foundation.Data`, which would normally be encoded as a nested array
    /// document of `UInt64` values.
    func testEncodeBSONValue() throws {
        let value = Data([1, 2, 3, 4])
        let container = BSONSingleValueEncodingContainer(codingPath: [])
        try container.encode(value)
        XCTAssertEqual(container.bsonBytes, value.bsonBytes)
        XCTAssertEqual(container.bsonType, value.bsonType)
    }
}