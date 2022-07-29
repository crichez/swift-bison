//
//  BSONEncoderTests.swift
//
//
//  Created by Christopher Richez on March 31 2022
//

import BisonEncode
import BisonWrite
import Foundation
import XCTest

class BSONEncoderTests: XCTestCase {
    struct TestType: Encodable {
        let name: String
        let value: Double
        let list: [Bool]
    }

    func testEncodesAsExpected() throws {
        let value = TestType(name: "test", value: 1.23, list: [true, false, true])
        let encodedValue = try BSONEncoder<Data>().encode(value)
        let expectedDoc = WritableDoc {
            "name" => "test"
            "value" => 1.23
            "list" => WritableArray {
                true
                false
                true
            }
        }
        let expectedBytes = Data(expectedDoc.bsonBytes)
        XCTAssertEqual(encodedValue, expectedBytes)
    }
}