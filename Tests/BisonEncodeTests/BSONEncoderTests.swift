//
//  BSONEncoderTests.swift
//
//
//  Created by Christopher Richez on March 31 2022
//

import BisonEncode
import BisonWrite
import XCTest

class BSONEncoderTests: XCTestCase {
    struct TestType: Encodable {
        let name: String
        let value: Double
        let list: [Bool]
    }

    func testEncodesAsExpected() throws {
        let value = TestType(name: "test", value: 1.23, list: [true, false, true])
        let encodedValue = try BSONEncoder().encode(value)
        let expectedDoc = WritableDoc {
            "name" => "test"
            "value" => 1.23
            "list" => WritableArray {
                "0" => true
                "1" => false
                "2" => true
            }
        }
        let expectedBytes = Data(expectedDoc.bsonBytes)
        XCTAssertEqual(encodedValue, expectedBytes)
    }
}