//
//  DocComponentTests.swift
//  DocComponentTests
//
//  Created by Christopher Richez on March 17 2022
//

import BSONKit
import XCTest

/// A test suite for `DocComponent` conforming types.
class DocComponentTests: XCTestCase {
    func testPair() {
        let pair = "\0" => true
        let expectedPair: [UInt8] = [8, 0, 0, 1]
        XCTAssertEqual(pair.bsonBytes, expectedPair)
    }
}