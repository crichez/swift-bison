//
//  DecodingContainerProvider.swift
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
import BisonDecode
import BisonWrite
import BisonRead
import XCTest

class DecodingContainerProviderTests: XCTestCase {
    private enum Key: CodingKey {
        case test
    }

    func testKeyedContainer() throws {
        let doc = WritableDoc {
            "test" => "passed?"
        }
        let decoder = DecodingContainerProvider(encodedValue: doc.bsonBytes)
        let container = try decoder.container(keyedBy: Key.self)
        XCTAssertEqual(try container.decode(String.self, forKey: .test), "passed?")
    }

    func testUnkeyedContainer() throws {
        let doc = WritableDoc {
            "0" => false
        }
        let decoder = DecodingContainerProvider(encodedValue: doc.bsonBytes)
        var container = try decoder.unkeyedContainer()
        XCTAssertEqual(try container.decode(Bool.self), false)
    }

    func testSingleValueContainer() throws {
        let encodedValue = Int32(109).bsonBytes
        let decoder = DecodingContainerProvider(encodedValue: encodedValue)
        let container = try decoder.singleValueContainer()
        XCTAssertEqual(try container.decode(Int32.self), 109)
    }
}