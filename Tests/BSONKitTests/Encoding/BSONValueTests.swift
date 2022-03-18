//
//  BSONValueTests.swift
//  BSONValueTests
//
//  Created by Christopher Richez on 3/16/22.
//

import BSONKit
import XCTest

/// A test suite for all `ValueProtocol` conforming types.
class BSONValueEncodingTests: XCTestCase {
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
        let doc = ComposedDocument {
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
