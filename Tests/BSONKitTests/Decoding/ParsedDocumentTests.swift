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
    let typeMap = ParsedDocument<[UInt8]>.typeMap

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

    /// Asserts attempting to parse a document with a non-specification type throws 
    /// `ParsedDocument<_>.Error.unknownType` with the expected attached values.
    func testUnknownType() throws {
        let faultyBytes: [UInt8] = [
            /* size: */ 10, 0, 0, 0, 
            /* Bool key-value paur: */ 8, 0, 1, 
            /* faulty typed key: */ 100, 0, 0
        ]
        do {
            let decodedDoc = try ParsedDocument(bsonBytes: faultyBytes)
            XCTFail("expected decoding to fail, but returned \(decodedDoc)")
        } catch let error as ParsedDocument<[UInt8]>.Error {
            let partialDoc = ParsedDocument<[UInt8]>(["": faultyBytes[6...6]])
            let progress = ParsedDocument<[UInt8]>.Progress(
                parsed: partialDoc, 
                remaining: faultyBytes[7...])
            XCTAssertEqual(error, .unknownType(100, "", progress))
        }
    }

    /// Asserts parsing a document with a value truncated to less than its expected number of bytes
    /// throws `ParsedDocument<_>.Error.valueSizeMismatch` with the expected attached values.
    /// 
    /// This test uses `Double` as its fixed-size type of choice. The logic is the same for other
    /// fixed-size types, so this test satisfies those requirements as well.
    func testFixedValueSizeMismatch() throws {
        let faultyBytes: [UInt8] = [
            /* size: */ 10, 0, 0, 0, 
            /* Double key: */ 1, 0,
            /* Double data: */ 1, 1, 1,
            /* terminator: */ 0,
        ]
        do {
            let decodedDoc = try ParsedDocument(bsonBytes: faultyBytes)
            XCTFail("expected decoding to fail, but returned \(decodedDoc)")
        } catch let error as ParsedDocument<[UInt8]>.Error {
            let partialDoc = ParsedDocument<[UInt8]>([:])
            let progress = ParsedDocument<[UInt8]>.Progress(
                parsed: partialDoc, 
                remaining: faultyBytes[6...])
            XCTAssertEqual(error, .valueSizeMismatch(8, "", progress))
        }
    }

    /// Asserts parsing a document with a `String` value less than 5 bytes long throws
    /// `ParsedDocument<_>.Error.valueSizeMismatch` with the expected attached values.
    func testStringTooShort() throws {
        let faultyBytes: [UInt8] = [
            /* size: */ 10, 0, 0, 0, 
            /* String key: */ 2, 0, 
            /* String data: */ 1, 1, 1, 
            /* terminator: */ 0
        ]
        do {
            let decodedDoc = try ParsedDocument(bsonBytes: faultyBytes)
            XCTFail("expected decoding to fail, but returned \(decodedDoc)")
        } catch let error as ParsedDocument<[UInt8]>.Error {
            let partialDoc = ParsedDocument<[UInt8]>([:])
            let progress = ParsedDocument<[UInt8]>.Progress(
                parsed: partialDoc, 
                remaining: faultyBytes[6...])
                XCTAssertEqual(error, .valueSizeMismatch(5, "", progress))
        }
    }

    /// Asserts parsing a document with a `String` value shorter than its declared size
    /// throws `ParsedDocument<_>.Error.valueSizeMismatch` with the expected attached values.
    func testStringSizeMismatch() throws {
        let faultyBytes: [UInt8] = [
            /* size: */ 15, 0, 0, 0,
            /* String key: */ 2, 0,
            /* String size: */ 10, 0, 0, 0,
            /* String data: */ 1, 2, 3, 4,
            /* terminator: */ 0,
        ]
        do {
            let decodedDoc = try ParsedDocument(bsonBytes: faultyBytes)
            XCTFail("expected decoding to fail, but returned \(decodedDoc)")
        } catch let error as ParsedDocument<[UInt8]>.Error {
            let partialDoc = ParsedDocument<[UInt8]>([:])
            let progress = ParsedDocument<[UInt8]>.Progress(
                parsed: partialDoc, 
                remaining: faultyBytes[6...])
            XCTAssertEqual(error, .valueSizeMismatch(14, "", progress))
        }
    }

    /// Asserts decoding a document that declares a nested document but offers less than 5 
    /// remaining bytes throws `ParsedDocument<_>.Error.valueSizeMismatch` with the expected
    /// attached values.
    func testDocValueDataTooShort() throws {
        let faultyBytes: [UInt8] = [
            /* size: */ 10, 0, 0, 0,
            /* document key: */ 3, 0,
            /* document data: */ 1, 1, 1,
            /* terminator: */ 0,
        ]
        do {
            let decodedDoc = try ParsedDocument(bsonBytes: faultyBytes)
            XCTFail("expected decoding to fail, but returned \(decodedDoc)")
        } catch let error as ParsedDocument<[UInt8]>.Error {
            let partialDoc = ParsedDocument<[UInt8]>([:])
            let progress = ParsedDocument<[UInt8]>.Progress(
                parsed: partialDoc, 
                remaining: faultyBytes[6...])
            XCTAssertEqual(error, .valueSizeMismatch(5, "", progress))
        }
    }

    /// Asserts decoding a document that declares a nested document but offers fewer bytes left
    /// than are declared throws `ParsedDocument<_>.Error.valueSizeMismatch` with the expected
    /// attached values.
    func testDocValueSizeMismatch() throws {
        let faultyBytes: [UInt8] = [
            /* size: */ 11, 0, 0, 0,
            /* document key: */ 3, 0,
            /* document data: */ 10, 0, 0, 0,
            /* terminator: */ 0,
        ]
        do {
            let decodedDoc = try ParsedDocument(bsonBytes: faultyBytes)
            XCTFail("expected decoding to fail, but returned \(decodedDoc)")
        } catch let error as ParsedDocument<[UInt8]>.Error {
            let partialDoc = ParsedDocument<[UInt8]>([:])
            let progress = ParsedDocument<[UInt8]>.Progress(
                parsed: partialDoc, 
                remaining: faultyBytes[6...])
            XCTAssertEqual(error, .valueSizeMismatch(10, "", progress))
        }
    }
    
}
