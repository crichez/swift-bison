//
//  ReadableDocTests.swift
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

@testable 
import BisonRead
import BisonWrite
import ObjectID
import XCTest

extension WritableValue {
    var bsonBytes: [UInt8] {
        var buffer: [UInt8] = []
        append(to: &buffer)
        return buffer
    }
}

/// Tests internal functionality of the `ReadableDoc` type.
class ReadableDocTests: XCTestCase {
    let typeMap = ReadableDoc<[UInt8]>.typeMap

    /// Asserts encoding and decoding a valid document returns the same value.
    func testDocParsed() throws {
        let doc = WritableDoc {
            "test" => true
        }
        let decodedDoc = try ReadableDoc(bsonBytes: doc.bsonBytes)
        let valueBytes = try XCTUnwrap(decodedDoc["test"])
        XCTAssertTrue(try Bool(bsonBytes: valueBytes))
    }

    /// Asserts decoding an empty document succeeds without errors.
    func testEmptyDocParsed() throws {
        let encodedDoc: [UInt8] = [5, 0, 0, 0, 0]
        let decodedDoc = try ReadableDoc(bsonBytes: encodedDoc)
        XCTAssertNil(decodedDoc["test"])
    }

    /// Asserts attempting to parse a document from less than 5 bytes throws 
    /// `DocError<_>.docTooShort`.
    func testDocDataTooShort() throws {
        let faultyBytes: [UInt8] = [4, 0, 0, 0]
        do {
            let decodedDoc = try ReadableDoc(bsonBytes: faultyBytes)
            XCTFail("expected decoding to fail, but returned \(decodedDoc)")
        } catch DocError<[UInt8]>.docTooShort {
            // This is expected
        }
    }

    /// Asserts attempting to parse a document from non null-terminated data throws
    /// `DocError<_>.notTerminated`.
    func testDocDataNotTerminated() throws {
        let faultyBytes: [UInt8] = [10] + [UInt8](repeating: 1, count: 9)
        do {
            let decodedDoc = try ReadableDoc(bsonBytes: faultyBytes)
            XCTFail("expected decoding to fail, but returned \(decodedDoc)")
        } catch DocError<[UInt8]>.notTerminated {
            // This is expected
        }
    }

    /// Asserts attempting to parse a document with a declared size less than `data.count`
    /// throws `.docTooShort` with the expected values.
    func testDocSizeMismatch() throws {
        let faultyBytes: [UInt8] = [3, 0, 0, 0, 0]
        do {
            let decodedDoc = try ReadableDoc(bsonBytes: faultyBytes)
            XCTFail("expected decoding to fail, but returned \(decodedDoc)")
        } catch let error as DocError<[UInt8]> {
            XCTAssertEqual(error, .docSizeMismatch(expectedExactly: 3))
        }
    }

    /// Asserts attempting to parse a document with a non-specification type throws 
    /// `DocError<_>.unknownType` with the expected attached values.
    func testUnknownType() throws {
        let faultyBytes: [UInt8] = [
            /* size: */ 10, 0, 0, 0, 
            /* Bool key-value paur: */ 8, 0, 1, 
            /* faulty typed key: */ 100, 0, 0
        ]
        do {
            let decodedDoc = try ReadableDoc(bsonBytes: faultyBytes)
            XCTFail("expected decoding to fail, but returned \(decodedDoc)")
        } catch let error as DocError<[UInt8]> {
            let partialDoc = ReadableDoc<[UInt8]>(["": faultyBytes[6...6]])
            let progress = Progress(
                parsed: partialDoc, 
                remaining: faultyBytes[7...])
            XCTAssertEqual(error, .unknownType(100, "", progress))
        }
    }

    /// Asserts parsing a document with a value truncated to less than its expected number of bytes
    /// throws `DocError<_>.valueSizeMismatch` with the expected attached values.
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
            let decodedDoc = try ReadableDoc(bsonBytes: faultyBytes)
            XCTFail("expected decoding to fail, but returned \(decodedDoc)")
        } catch let error as DocError<[UInt8]> {
            let partialDoc = ReadableDoc<[UInt8]>([:])
            let progress = Progress(
                parsed: partialDoc, 
                remaining: faultyBytes[6...])
            XCTAssertEqual(error, .valueSizeMismatch(8, "", progress))
        }
    }

    /// Asserts decoding a document that declares a type with recursive size rules uses those
    /// rules as defined in the type map.
    /// 
    /// Recursive size rules mean the same rules as another type declared in the type map.
    func testRecursiveValueSizeMismatch() throws {
        let faultyBytes: [UInt8] = [
            /* size: */ 10, 0, 0, 0,
            /* array key: */ 4, 0,
            /* array data: */ 1, 1, 1,
            /* terminator: */ 0,
        ]
        do {
            let decodedDoc = try ReadableDoc(bsonBytes: faultyBytes)
            XCTFail("expected decoding to fail, but returned \(decodedDoc)")
        } catch let error as DocError<[UInt8]> {
            let partialDoc = ReadableDoc<[UInt8]>([:])
            let progress = Progress(
                parsed: partialDoc, 
                remaining: faultyBytes[6...])
            XCTAssertEqual(error, .valueSizeMismatch(5, "", progress))
        }
    }

    /// Asserts parsing a document with a `String` value less than 5 bytes long throws
    /// `DocError<_>.valueSizeMismatch` with the expected attached values.
    func testStringTooShort() throws {
        let faultyBytes: [UInt8] = [
            /* size: */ 10, 0, 0, 0, 
            /* String key: */ 2, 0, 
            /* String data: */ 1, 1, 1, 
            /* terminator: */ 0
        ]
        do {
            let decodedDoc = try ReadableDoc(bsonBytes: faultyBytes)
            XCTFail("expected decoding to fail, but returned \(decodedDoc)")
        } catch let error as DocError<[UInt8]> {
            let partialDoc = ReadableDoc<[UInt8]>([:])
            let progress = Progress(
                parsed: partialDoc, 
                remaining: faultyBytes[6...])
                XCTAssertEqual(error, .valueSizeMismatch(5, "", progress))
        }
    }

    /// Asserts parsing a document with a `String` value shorter than its declared size
    /// throws `DocError<_>.valueSizeMismatch` with the expected attached values.
    func testStringSizeMismatch() throws {
        let faultyBytes: [UInt8] = [
            /* size: */ 15, 0, 0, 0,
            /* String key: */ 2, 0,
            /* String size: */ 10, 0, 0, 0,
            /* String data: */ 1, 2, 3, 4,
            /* terminator: */ 0,
        ]
        do {
            let decodedDoc = try ReadableDoc(bsonBytes: faultyBytes)
            XCTFail("expected decoding to fail, but returned \(decodedDoc)")
        } catch let error as DocError<[UInt8]> {
            let partialDoc = ReadableDoc<[UInt8]>([:])
            let progress = Progress(
                parsed: partialDoc, 
                remaining: faultyBytes[6...])
            XCTAssertEqual(error, .valueSizeMismatch(14, "", progress))
        }
    }

    /// Asserts decoding a document that declares a nested document but offers less than 5 
    /// remaining bytes throws `DocError<_>.valueSizeMismatch` with the expected
    /// attached values.
    func testDocValueDataTooShort() throws {
        let faultyBytes: [UInt8] = [
            /* size: */ 10, 0, 0, 0,
            /* document key: */ 3, 0,
            /* document data: */ 1, 1, 1,
            /* terminator: */ 0,
        ]
        do {
            let decodedDoc = try ReadableDoc(bsonBytes: faultyBytes)
            XCTFail("expected decoding to fail, but returned \(decodedDoc)")
        } catch let error as DocError<[UInt8]> {
            let partialDoc = ReadableDoc<[UInt8]>([:])
            let progress = Progress(
                parsed: partialDoc, 
                remaining: faultyBytes[6...])
            XCTAssertEqual(error, .valueSizeMismatch(5, "", progress))
        }
    }

    /// Asserts decoding a document that declares a nested document but offers fewer bytes left
    /// than are declared throws `DocError<_>.valueSizeMismatch` with the expected
    /// attached values.
    func testDocValueSizeMismatch() throws {
        let faultyBytes: [UInt8] = [
            /* size: */ 11, 0, 0, 0,
            /* document key: */ 3, 0,
            /* document data: */ 10, 0, 0, 0,
            /* terminator: */ 0,
        ]
        do {
            let decodedDoc = try ReadableDoc(bsonBytes: faultyBytes)
            XCTFail("expected decoding to fail, but returned \(decodedDoc)")
        } catch let error as DocError<[UInt8]> {
            let partialDoc = ReadableDoc<[UInt8]>([:])
            let progress = Progress(
                parsed: partialDoc, 
                remaining: faultyBytes[6...])
            XCTAssertEqual(error, .valueSizeMismatch(10, "", progress))
        }
    }
    
    /// Asserts decoding a document that declares a binary value but offers fewer than 5 bytes
    /// left throws `DocError<_>.valueSizeMismatch` with the expected attached values.
    func testBinaryValueDataTooShort() throws {
        let faultyBytes: [UInt8] = [
            /* size: */ 10, 0, 0, 0,
            /* binary key: */ 5, 0,
            /* binary data: */ 1, 1, 1,
            /* terminator: */ 0,
        ]
        do {
            let decodedDoc = try ReadableDoc(bsonBytes: faultyBytes)
            XCTFail("expected decoding to fail, but returned \(decodedDoc)")
        } catch let error as DocError<[UInt8]> {
            let partialDoc = ReadableDoc<[UInt8]>([:])
            let progress = Progress(
                parsed: partialDoc, 
                remaining: faultyBytes[6...])
            XCTAssertEqual(error, .valueSizeMismatch(5, "", progress))
        }
    }

    /// Asserts decoding a document that declares a binary value but offers fewer bytes left
    /// than declared throws `DocError<_>.valueSizeMismatch` with the expected
    /// attached values.
    func testBinaryValueSizeMismatch() throws {
        let faultyBytes: [UInt8] = [
            /* size: */ 12, 0, 0, 0,
            /* binary key: */ 5, 0,
            /* binary size: */ 10, 0, 0, 0, 
            /* binary data: */ 1,
            /* terminator: */ 0,
        ]
        do {
            let decodedDoc = try ReadableDoc(bsonBytes: faultyBytes)
            XCTFail("expected decoding to fail, but returned \(decodedDoc)")
        } catch let error as DocError<[UInt8]> {
            let partialDoc = ReadableDoc<[UInt8]>([:])
            let progress = Progress(
                parsed: partialDoc, 
                remaining: faultyBytes[6...])
            XCTAssertEqual(error, .valueSizeMismatch(15, "", progress))
        }
    }

    /// Asserts parsing a document with a regular expression value that doesn't contain a zero
    /// throws `DocError<_>.valueSizeMismatch` with the expected attached values.
    func testRegularExpressionSizeMismatch() throws {
        let faultyBytes: [UInt8] = [
            /* size: */ 11, 0, 0, 0,
            /* regex key: */ 11, 0,
            /* regex data: */ 1, 1, 1, 1, 
            /* terminator: */ 0,
        ]
        do {
            let decodedDoc = try ReadableDoc(bsonBytes: faultyBytes)
            XCTFail("expected decoding to fail, but returned \(decodedDoc)")
        } catch let error as DocError<[UInt8]> {
            let partialDoc = ReadableDoc<[UInt8]>([:])
            let progress = Progress(
                parsed: partialDoc, 
                remaining: faultyBytes[6...])
            XCTAssertEqual(error, .valueSizeMismatch(6, "", progress))
        }
    }

    /// Asserts reading a document with a deprecated "undefined" value succeeds.
    func testUndefinedParsed() throws {
        var encodedDoc = WritableDoc {
            // Encode a null since it has the same size as undefined.
            "test" => Bool?.none
        }
        .encode(as: [UInt8].self)
        // Replace the null type byte with the undefined type byte.
        encodedDoc[4] = 6
        // Try parsing the document.
        let decodedDoc = try ReadableDoc(bsonBytes: encodedDoc)
        // Try retrieving the value's data.
        let valueData = try XCTUnwrap(decodedDoc["test"])
        // That data should be empty.
        XCTAssertTrue(valueData.isEmpty)
    }
    /// Asserts reading a document with a deprecated "DBPointer" value succeeds.
    func testDBPointerParsed() throws {
        var encodedDoc: [UInt8] = []
        // Append placeholder size bytes
        Int32(0).append(to: &encodedDoc)
        // Append the DBPointer type byte
        encodedDoc.append(12)
        // Append a key
        encodedDoc.append(contentsOf: "test".utf8)
        encodedDoc.append(0)
        // Append a random String
        "test".append(to: &encodedDoc)
        // Append a random ObjectID
        let id = ObjectID()
        id.append(to: &encodedDoc)
        // Terminate the document
        encodedDoc.append(0)
        // Size the document
        encodedDoc.replaceSubrange(0..<4, with: withUnsafeBytes(of: Int32(encodedDoc.count)) { $0 })
        // Parse the document
        let decodedDoc = try ReadableDoc(bsonBytes: encodedDoc)
        let stringBytes = try XCTUnwrap(decodedDoc["test"]).dropLast(12)
        let idBytes = try XCTUnwrap(decodedDoc["test"]).dropFirst(stringBytes.count)
        let decodedString = try String(bsonBytes: stringBytes)
        let decodedID = try ObjectID(bsonBytes: idBytes)
        XCTAssertEqual(decodedString, "test")
        XCTAssertEqual(decodedID, id)
    }

    /// Asserts reading a document with a deprecated "code_w_scope" value succeeds.
    func testJSCodeParsed() throws {
        var encodedDoc: [UInt8] = []
        // Append placeholder size bytes
        Int32(0).append(to: &encodedDoc)
        // Append the code_w_scope type byte
        encodedDoc.append(15)
        // Append a key
        encodedDoc.append(contentsOf: "test".utf8)
        encodedDoc.append(0)
        // Append a random String
        "test".append(to: &encodedDoc)
        // Append a random Document
        let valueDoc = WritableDoc {
            "test" => true
        }
        valueDoc.append(to: &encodedDoc)
        // Terminate the document
        encodedDoc.append(0)
        // Size the document
        encodedDoc.replaceSubrange(0..<4, with: withUnsafeBytes(of: Int32(encodedDoc.count)) { $0 })
        // Parse the document
        let decodedDoc = try ReadableDoc(bsonBytes: encodedDoc)
        let valueDocBytes = try XCTUnwrap(decodedDoc["test"]).dropFirst("test".utf8.count + 5)
        let stringBytes = try XCTUnwrap(decodedDoc["test"]).dropLast(valueDocBytes.count)
        let decodedString = try String(bsonBytes: stringBytes)
        XCTAssertEqual(decodedString, "test")
        XCTAssertEqual(Array(valueDocBytes), valueDoc.encode(as: [UInt8].self))
    }
}
