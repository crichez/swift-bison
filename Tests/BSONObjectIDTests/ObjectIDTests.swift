//
//  ObjectIDTests.swift
//
//
//  Created by Christopher Richez on April 14 2022
//

import BSONObjectID
import BSONCompose
import BSONParse
import XCTest
import Foundation

class ObjectIDTests: XCTestCase {
    /// Asserts converting an ObjectID to and from its hexadecimal string representation
    /// results in the same binary representation.
    func testHexStringConversion() {
        let originalID = ObjectID()
        let hexID = originalID.description
        let decodedID = ObjectID(hexID)
        XCTAssertEqual(originalID.bsonBytes, decodedID.bsonBytes)
    }

    /// Asserts `ObjectID.bsonBytes` returns the expected bytes for a known id.
    func testBSONBytes() {
        let id = ObjectID()
        let encodedID = id.bsonBytes
        withUnsafeBytes(of: id) { idBytes in 
            XCTAssertEqual(encodedID, Array(idBytes))
        }
    }

    /// Asserts `ObjectID.init(bsonBytes:)` initializes the expected id for known data.
    func testInitFromBSONBytes() throws {
        let id = ObjectID()
        let decodedID = try ObjectID(bsonBytes: id.bsonBytes)
        XCTAssertEqual(id.bsonBytes, decodedID.bsonBytes)
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
}