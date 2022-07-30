//
//  BSONEncoderTests.swift
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