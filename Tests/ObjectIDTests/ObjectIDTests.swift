//
//  ObjectIDTests.swift
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