//
//  ParsedDocumentTests.swift
//  ParsedDocumentTests
//
//  Created by Christopher Richez on March 5 2022
//

import XCTest
import BSONKit

class ParsedDocumentTests: XCTestCase {
    func testSingleValueDoc() throws {
        let doc = ComposedDocument {
            "test" => true
        }
        let encodedDoc = Array(doc.bsonBytes)
        let decodedDoc = try ParsedDocument(bsonData: encodedDoc)
        let encodedValue = try XCTUnwrap(decodedDoc["test"])
        let decodedValue = try Bool(bsonData: encodedValue)
        XCTAssertTrue(decodedValue)
    }

    func testMultiValueDoc() throws {
        let doc = ComposedDocument {
            "one" => Int64(1)
            "two" => Int32(2)
            "three" => UInt64(3)
            "four" => Double(4)
            "five" => "5"
        }
        let encodedDoc = Array(doc.bsonBytes)
        let decodedDoc = try ParsedDocument(bsonData: encodedDoc)

        let encodedOne = try XCTUnwrap(decodedDoc["one"])
        let encodedTwo = try XCTUnwrap(decodedDoc["two"])
        let encodedThree = try XCTUnwrap(decodedDoc["three"])
        let encodedFour = try XCTUnwrap(decodedDoc["four"])
        let encodedFive = try XCTUnwrap(decodedDoc["five"])

        let decodedOne = try Int64(bsonData: encodedOne)
        let decodedTwo = try Int32(bsonData: encodedTwo)
        let decodedThree = try UInt64(bsonData: encodedThree)
        let decodedFour = try Double(bsonData: encodedFour)
        let decodedFive = try String(bsonData: encodedFive)

        XCTAssertEqual(decodedOne, 1)
        XCTAssertEqual(decodedTwo, 2)
        XCTAssertEqual(decodedThree, 3)
        XCTAssertEqual(decodedFour, 4)
        XCTAssertEqual(Array(decodedFive.utf8), Array("5".utf8))
    }
}
