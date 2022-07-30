//
//  DocComponentTests.swift
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
import BisonWrite
import XCTest

extension DocComponent {
    var bsonBytes: [UInt8] {
        var buffer: [UInt8] = []
        append(to: &buffer)
        return buffer
    }
}

/// A test suite for `DocComponent` conforming types.
class DocComponentTests: XCTestCase {
    func testPair() {
        let pair = "\0" => true
        let expectedPair: [UInt8] = [8, 0, 0, 1]
        XCTAssertEqual(pair.bsonBytes, expectedPair)
    }

    /// This test asserts content from a loop is encoded as expected.
    func testForEach() throws {
        let doc = WritableDoc {
            ForEach([Int64]([0, 1, 2, 3, 4, 5, 6, 7, 8, 9])) { number in
                String(describing: number) => number
            }
        }
        let expectedDoc = WritableDoc {
            "0" => Int64(0)
            "1" => Int64(1)
            "2" => Int64(2)
            "3" => Int64(3)
            "4" => Int64(4)
            "5" => Int64(5)
            "6" => Int64(6)
            "7" => Int64(7)
            "8" => Int64(8)
            "9" => Int64(9)
        }
        XCTAssertEqual(doc.bsonBytes, expectedDoc.bsonBytes)
    }

    func testGroup() throws {
        let doc = WritableDoc {
            Group {
                "0" => Int64(0)
                "1" => Int64(1)
                "2" => Int64(2)
                "3" => Int64(3)
                "4" => Int64(4)
                "5" => Int64(5)
                "6" => Int64(6)
                "7" => Int64(7)
                "8" => Int64(8)
                "9" => Int64(9)
            }
            Group {
                "10" => Int64(10)
                "11" => Int64(11)
                "12" => Int64(12)
            }
        }
        let expectedDoc = WritableDoc {
            ForEach(Int64(0)...12) { number in
                String(describing: number) => number
            }
        }
        XCTAssertEqual(doc.bsonBytes, expectedDoc.bsonBytes)
    }

    func testOptionalComponent() throws {
        let some = OptionalComponent.some("test" => true)
        let expectedSome = "test" => true
        XCTAssertEqual(some.bsonBytes, expectedSome.bsonBytes)

        let none = OptionalComponent<Pair<Bool>>.none
        XCTAssertEqual(none.bsonBytes, [])
    }
}