//
//  BinaryParsableValueTests.swift
//  
//
//  Created by Christopher Richez on 4/28/22.
//

import Foundation
import XCTest
import BSONParse
import BisonWrite

class BinaryParsableValueTests: XCTestCase {
    func testUUID() throws {
        let value = UUID()
        let encodedValue = value.bsonBytes
        let decodedValue = try UUID(bsonBytes: encodedValue)
        XCTAssertEqual(value, decodedValue)
    }
    
    func testData() throws {
        let value = Data([1, 2, 3, 4])
        let encodedValue = value.bsonBytes
        let decodedValue = try Data(bsonBytes: encodedValue)
        XCTAssertEqual(value, decodedValue)
    }
}
