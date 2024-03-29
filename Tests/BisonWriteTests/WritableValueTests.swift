//
//  WritableValueTests.swift
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

import BisonWrite
import XCTest

extension WritableValue {
    var bsonBytes: [UInt8] {
        var buffer: [UInt8] = []
        append(to: &buffer)
        return buffer
    }
}

/// A test suite for all `WritableValue` conforming types.
class WritableValueTests: XCTestCase {
    func testDouble() throws {
        let value = Double.random(in: .leastNonzeroMagnitude ... .greatestFiniteMagnitude)
        let expectedType: UInt8 = 1
        let expectedBytes = withUnsafeBytes(of: value.bitPattern) { Array($0) }
        XCTAssertEqual(value.bsonType, expectedType)
        XCTAssertEqual(value.bsonBytes, expectedBytes)
    }

    func testString() throws {
        let value = "this is a test! \u{10097}"
        let expectedType: UInt8 = 2
        let expectedBytes = Int32(value.utf8.count + 1).bsonBytes + Array(value.utf8) + [0]
        XCTAssertEqual(value.bsonType, expectedType)
        XCTAssertEqual(value.bsonBytes, expectedBytes)
    }

    func testBool() throws {
        let value = Bool.random()
        let expectedType: UInt8 = 8
        let expectedBytes: [UInt8] = value ? [1] : [0]
        XCTAssertEqual(value.bsonType, expectedType)
        XCTAssertEqual(value.bsonBytes, expectedBytes)
    }

    func testInt32() throws {
        let value = Int32.random(in: .min ... .max)
        let expectedType: UInt8 = 16
        let expectedBytes = withUnsafeBytes(of: value) { Array($0) }
        XCTAssertEqual(value.bsonType, expectedType)
        XCTAssertEqual(value.bsonBytes, expectedBytes)
    }

    func testUInt64() throws {
        let value = UInt64.random(in: .min ... .max)
        let expectedType: UInt8 = 17
        let expectedBytes = withUnsafeBytes(of: value) { Array($0) }
        XCTAssertEqual(value.bsonType, expectedType)
        XCTAssertEqual(value.bsonBytes, expectedBytes)
    }

    func testInt64() throws {
        let value = Int64.random(in: .min ... .max)
        let expectedType: UInt8 = 18
        let expectedBytes = withUnsafeBytes(of: value) { Array($0) }
        XCTAssertEqual(value.bsonType, expectedType)
        XCTAssertEqual(value.bsonBytes, expectedBytes)
    }

    /// This test asserts the content, size and terminator of the document are property encoded.
    func testComposedDoc() throws {
        let doc = WritableDoc {
            "test" => true
        }
        let encodedDoc = doc.bsonBytes
        
        // Assert the declared and actual size are the same.
        let declaredSizeData = UnsafeMutableRawBufferPointer.allocate(byteCount: 4, alignment: 4)
        declaredSizeData.copyBytes(from: encodedDoc.prefix(4))
        let declaredSize = Int(declaredSizeData.load(as: Int32.self))
        XCTAssertEqual(encodedDoc.count, declaredSize, "\(encodedDoc)")
        
        // Assert the document is properly null-terminated.
        XCTAssertEqual(encodedDoc.last, 0, "\(encodedDoc)")
    }
    
}
