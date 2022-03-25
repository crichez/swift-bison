//
//  DocComponentTests.swift
//  DocComponentTests
//
//  Created by Christopher Richez on March 17 2022
//

@testable
import BSONCompose
import XCTest

/// A test suite for `DocComponent` conforming types.
class DocComponentTests: XCTestCase {
    func testPair() {
        let pair = "\0" => true
        let expectedPair: [UInt8] = [8, 0, 0, 1]
        XCTAssertEqual(pair.bsonBytes, expectedPair)
    }

    /// This test asserts content from a loop is encoded as expected.
    func testForEach() throws {
        let doc = ComposedDocument {
            ForEach([Int64]([0, 1, 2, 3, 4, 5, 6, 7, 8, 9])) { number in
                String(describing: number) => number
            }
        }
        let expectedDoc = ComposedDocument {
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
        let doc = ComposedDocument {
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
        let expectedDoc = ComposedDocument {
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