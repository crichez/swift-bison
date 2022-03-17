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
}
