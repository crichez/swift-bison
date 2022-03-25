//
//  ParsedDocumentTests.swift
//  ParsedDocumentTests
//
//  Created by Christopher Richez on March 5 2022
//

@testable 
import BSONKit
import XCTest

/// Tests internal functionality of the `ParsedDocument` type.
class ParsedDocumentTests: XCTestCase {
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

    /// Asserts attempting to parse a document from non null-terminated data throws
    /// `ParsedDocument<_>.Error.notTerminated`.
    func testDocDataNotTerminated() throws {
        let faultyBytes: [UInt8] = [10] + [UInt8](repeating: 1, count: 9)
        do {
            let decodedDoc = try ParsedDocument(bsonBytes: faultyBytes)
            XCTFail("expected decoding to fail, but returned \(decodedDoc)")
        } catch ParsedDocument<[UInt8]>.Error.notTerminated {
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
