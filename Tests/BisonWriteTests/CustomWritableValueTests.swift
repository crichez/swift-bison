//
//  CustomWritableValueTests.swift
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

import BisonWrite
import XCTest
import Foundation

class CustomWritableValueTests: XCTestCase {
    func testUUID() {
        let id = UUID()
        let doc = WritableDoc {
            "" => id
        }
        var expectedDoc: [UInt8] = [
            /* size: */ 28, 0, 0, 0,
            /* key: */ 5, 0,
            /* value size: */ 16, 0, 0, 0,
            /* subtype: */ 4, 
        ]
        expectedDoc.append(contentsOf: withUnsafeBytes(of: id) { Array($0) })
        expectedDoc.append(0)
        XCTAssertEqual(doc.bsonBytes, expectedDoc)
    }

    func testData() {
        let data = Data([0, 1, 2, 3])
        let doc = WritableDoc {
            "" => data
        }
        let expectedDoc: [UInt8] = [
            /* size: */ 16, 0, 0, 0,
            /* key: */ 5, 0,
            /* value size: */ 4, 0, 0, 0,
            /* subtype: */ 0, 
            /* value data: */ 0, 1, 2, 3,
            /* doc terminator: */ 0,
        ]
        XCTAssertEqual(doc.bsonBytes, expectedDoc)
    }

    func testDate() {
        let value = Date(timeIntervalSince1970: 3600.0).bsonBytes
        let expectedValue = Int64(3_600_000).bsonBytes
        XCTAssertEqual(value, expectedValue)
    }
}