//
//  DecodingContainerProvider.swift
//
//
//  Created by Christopher Richez on April 11 2022
//

@testable
import BSONDecodable
import BisonWrite
import BSONParse
import XCTest

class DecodingContainerProviderTests: XCTestCase {
    private enum Key: CodingKey {
        case test
    }

    func testKeyedContainer() throws {
        let doc = ComposedDocument {
            "test" => "passed?"
        }
        let decoder = DecodingContainerProvider(encodedValue: doc.bsonBytes)
        let container = try decoder.container(keyedBy: Key.self)
        XCTAssertEqual(try container.decode(String.self, forKey: .test), "passed?")
    }

    func testUnkeyedContainer() throws {
        let doc = ComposedDocument {
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