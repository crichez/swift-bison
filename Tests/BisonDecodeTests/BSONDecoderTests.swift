//
//  BSONDecoderTests.swift
//
//
//  Created by Christopher Richez on April 11 2022
//

import BisonDecode
import BisonEncode
import XCTest

class BSONDecoderTests: XCTestCase {
    private struct TestObject: Equatable, Codable {
        let name: String
        let number: Int
        let flag: Bool
    }

    func testDecoder() throws {
        let value = TestObject(name: "test", number: 12, flag: false)
        let encodedValue = try BSONEncoder().encode(value)
        let decodedValue = try BSONDecoder().decode(TestObject.self, from: encodedValue)
        XCTAssertEqual(value, decodedValue)
    }
}