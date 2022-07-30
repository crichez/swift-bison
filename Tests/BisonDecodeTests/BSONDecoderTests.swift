//
//  BSONDecoderTests.swift
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

import BisonDecode
import BisonEncode
import Foundation
import XCTest

class BSONDecoderTests: XCTestCase {
    private struct TestObject: Equatable, Codable {
        let name: String
        let number: Int
        let flag: Bool
    }

    func testDecoder() throws {
        let value = TestObject(name: "test", number: 12, flag: false)
        let encodedValue = try BSONEncoder<Data>().encode(value)
        let decodedValue = try BSONDecoder().decode(TestObject.self, from: encodedValue)
        XCTAssertEqual(value, decodedValue)
    }
}