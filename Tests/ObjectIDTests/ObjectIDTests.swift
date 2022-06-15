//
//  ObjectIDTests.swift
//
//
//  Created by Christopher Richez on April 14 2022
//

import ObjectID
import XCTest
import Foundation

class ObjectIDTests: XCTestCase {
    /// Asserts converting an ObjectID to and from its hexadecimal string representation
    /// results in the same binary representation.
    func testHexStringConversion() {
        let originalID = ObjectID()
        let hexID = originalID.description
        let decodedID = ObjectID(hexID)
        XCTAssertEqual(originalID, decodedID)
    }

    /// Asserts the creation timestamp of the ID is roughly that of the current date,
    /// with a 1 second margin considering execution timing.
    func testTimestampAccurate() throws {
        let id = ObjectID()
        let nowish = Date()
        XCTAssertTrue(DateInterval(start: id.timestamp, end: nowish).duration < 1)
    }

    /// Asserts converting an id to and from its description results in the same timestamp.
    func testTimestampConsistent() throws {
        let id = ObjectID()
        let hexID = id.description
        let idFromHex = ObjectID(hexID)!
        XCTAssertEqual(id.timestamp, idFromHex.timestamp)
    }

    /// Asserts converting an id to and from its description results in the same timestamp.
    func testIncrementConsistent() throws {
        let id = ObjectID()
        let hexID = id.description
        let idFromHex = ObjectID(hexID)!
        XCTAssertEqual(id.increment, idFromHex.increment)
    }

    /// Asserts `incrementByOne()` actually increments the ID by one.
    func testIncrementByOne() {
        var id = ObjectID()
        let originalIncrement = id.increment
        guard originalIncrement < .max else {
            testIncrementByOne()
            return
        }
        id.incrementByOne()
        XCTAssertEqual(originalIncrement + 1, id.increment)
    }

    /// Asserts encoding an `ObjectID` using a non-BSON `Encoder` 
    /// encodes the appropriate hex string, and decoding it results in the same ID.
    func testNonBSONEncoding() throws {
        let id = ObjectID()
        let encoder = JSONEncoder()
        let encodedID = try encoder.encode(id)
        let decoder = JSONDecoder()
        let decodedID = try decoder.decode(ObjectID.self, from: encodedID)
        XCTAssertEqual(id, decodedID)
    }
}