//
//  ParsableValueTests.swift
//  ParsableValueTests
//
//  Created by Christopher Richez on March 20 2022
//

import BSONKit
import XCTest

/// A test suite for the `ParsableValue.init(bsonBytes:)` initializer's code branches.
class ParsableValueTests: XCTestCase {
    // MARK: Double

    /// Asserts encoding and decoding a valid `Double` returns the same value.
    func testDoubleParsed() throws {
        let value = Double.random(in: .leastNonzeroMagnitude ... .greatestFiniteMagnitude)
        let decodedValue = try Double(bsonBytes: value.bsonBytes)
        XCTAssertEqual(value, decodedValue)
    }

    /// Asserts attempting to decode a `Double` from other than 8 bytes throws
    /// `Double.Error.sizeMismatch`.
    func testDoubleSizeMismatch() throws {
        do {
            let faultyBytes: [UInt8] = [0, 1, 2, 3]
            let decodedValue = try Double(bsonBytes: faultyBytes)
            XCTFail("expected decoding to fail, but returned \(decodedValue)")
        } catch Double.Error.sizeMismatch {
            return
        }
    }

    // MARK: String

    /// Asserts encoding and decoding a valid `String` returns the same value.
    func testStringParsed() throws {
        let value = "this is a test! \u{10097}"
        let decodedValue = try String(bsonBytes: value.bsonBytes)
        XCTAssertEqual(value, decodedValue)
    }

    /// Asserts attempting to decode a `String` from less than 5 bytes throws
    /// `String.Error.dataTooShort`.
    func testStringDataTooShort() throws {
        do {
            let faultyBytes: [UInt8] = [0, 1, 2]
            let decodedValue = try String(bsonBytes: faultyBytes)
            XCTFail("expected decoding to fail, but returned \(decodedValue)")
        } catch String.Error.dataTooShort {
            return
        }
    }

    /// Asserts attempting to decode a `String` with a declared size different from its
    /// actual size throws `String.Error.sizeMismatch`.
    func testStringSizeMismatch() throws {
        do {
            let value = "this is a test! \u{10097}"
            var encodedValue = value.bsonBytes
            encodedValue.replaceSubrange(0..<4, with: Int32(5).bsonBytes)
            let decodedValue = try String(bsonBytes: encodedValue)
            XCTFail("expected decoding to fail, but returned \(decodedValue)")
        } catch String.Error.sizeMismatch {
            return
        }
    }

    // MARK: ParsedDocument

    /// Asserts encoding and decoding a valid document returns the same value.
    func testDocParsed() throws {
        let doc = ComposedDocument {
            "test" => true
        }
        let decodedDoc = try ParsedDocument(bsonBytes: doc.bsonBytes)
        let valueBytes = try XCTUnwrap(decodedDoc["test"])
        XCTAssertTrue(try Bool(bsonBytes: valueBytes))
    }

    /// Asserts decoding an empty document succeeds without errors.
    func testEmptyDocParsed() throws {
        let encodedDoc: [UInt8] = [5, 0, 0, 0, 0]
        let decodedDoc = try ParsedDocument(bsonBytes: encodedDoc)
        XCTAssertNil(decodedDoc["test"])
    }

    /// Asserts attempting to parse a document from less than 5 bytes throws 
    /// `ParsedDocument<_>.Error.docTooShort`.
    func testDocDataTooShort() throws {
        let faultyBytes: [UInt8] = [4, 0, 0, 0]
        do {
            let decodedDoc = try ParsedDocument(bsonBytes: faultyBytes)
            XCTFail("expected decoding to fail, but returned \(decodedDoc)")
        } catch ParsedDocument<[UInt8]>.Error.docTooShort {
            // This is expected
        }
    }

    /// Asserts attempting to parse a document with a declared size less than `data.count`
    /// throws `.docTooShort` with the expected values.
    func testDocSizeMismatch() throws {
        let faultyBytes: [UInt8] = [3, 0, 0, 0, 0]
        do {
            let decodedDoc = try ParsedDocument(bsonBytes: faultyBytes)
            XCTFail("expected decoding to fail, but returned \(decodedDoc)")
        } catch let error as ParsedDocument<[UInt8]>.Error {
            XCTAssertEqual(error, .docSizeMismatch(3))
        }
    }
}