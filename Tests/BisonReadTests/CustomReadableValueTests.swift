//
//  CustomReadableValueTests.swift
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

import Foundation
import XCTest
import BisonRead
import BisonWrite

class CustomReadableValueTests: XCTestCase {
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
