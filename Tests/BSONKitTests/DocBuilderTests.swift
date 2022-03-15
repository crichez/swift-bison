//
//  DocBuilderTests.swift
//  
//
//  Created by Christopher Richez on 2/6/22.
//

import BSONKit
import XCTest

class DocBuilderTests: XCTestCase {
    /// This test asserts the content, size and terminator of the document are property encoded.
    func testComposedDocument() throws {
        let doc = ComposedDocument {
            "test" => true
        }
        let bytes = Array(doc.bsonEncoded)
        let declaredSizeData = UnsafeMutableRawBufferPointer.allocate(byteCount: 4, alignment: 4)
        declaredSizeData.copyBytes(from: bytes.prefix(4))
        let declaredSize = Int(declaredSizeData.load(as: Int32.self))
        XCTAssertEqual(bytes.count, declaredSize, "\(bytes)")
        XCTAssertEqual(bytes.last, 0, "\(bytes)")
    }
    
    /// This test asserts content from a loop is encoded as expected.
    func testLoop() throws {
        let doc = ComposedDocument {
            ForEach([Int64]([0, 1, 2, 3, 4, 5, 6, 7, 8, 9])) { number in
                String(describing: number) => number
            }
        }
        let encodedDoc = Array(doc.bsonEncoded)
        XCTAssertEqual(encodedDoc.count, (3 * 10) + (8 * 10) + 5)
    }

    func testConditional() throws {
        let flag = true
        let doc = ComposedDocument {
            if flag {
                "test" => "passed"
            } else {
                "test" => "failed"
            }
        }
        let expectedDoc = ComposedDocument {
            "test" => "passed"
        }
        let encodedDoc = Array(doc.bsonEncoded)
        let expectedEncodedDoc = Array(expectedDoc.bsonEncoded)
        XCTAssertEqual(encodedDoc, expectedEncodedDoc)
    }

    func testOptional() throws {
        let flag = false
        let doc = ComposedDocument {
            if flag {
                "zero" => Int64(0)
            }
            "one" => Int64(1)
        }
        let expectedDoc = ComposedDocument {
            "one" => Int64(1)
        }
        let encodedDoc = Array(doc.bsonEncoded)
        let expectedEncodedDoc = Array(expectedDoc.bsonEncoded)
        XCTAssertEqual(encodedDoc, expectedEncodedDoc)
    }

    func testLimitedAvailability() throws {
        let doc = ComposedDocument {
            if #available(macOS 11, iOS 14, tvOS 14, watchOS 7, *) {
                "isOn2020ReleaseOrGreater" => true
            }
        }
        let encodedDoc = Array(doc.bsonEncoded)
        let expectedDoc = ComposedDocument {
            "isOn2020ReleaseOrGreater" => true
        }
        let expectedEncodedDoc = Array(expectedDoc.bsonEncoded)
        if #available(macOS 11, iOS 14, tvOS 14, watchOS 7, *) {
            XCTAssertEqual(encodedDoc, expectedEncodedDoc)
        } else {
            try XCTSkipIf(true, "test requires specific version to complete")
        }
    }
}
