//
//  BSONEncoderTests.swift
//
//
//  Created by Christopher Richez on March 31 2022
//

import BSONEncodable
import BSONCompose
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
        let expectedDoc = ComposedDocument {
            "name" => "test"
            "value" => 1.23
            "list" => ComposedArrayDocument {
                "0" => true
                "1" => false
                "2" => true
            }
        }
        let expectedBytes = Data(expectedDoc.bsonBytes)
        XCTAssertEqual(encodedValue, expectedBytes)
    }
}