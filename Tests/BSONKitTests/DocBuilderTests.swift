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
        let encodedDoc = doc.bsonBytes
        
        // Assert the declared and actual size are the same.
        let declaredSizeData = UnsafeMutableRawBufferPointer.allocate(byteCount: 4, alignment: 4)
        declaredSizeData.copyBytes(from: encodedDoc.prefix(4))
        let declaredSize = Int(declaredSizeData.load(as: Int32.self))
        XCTAssertEqual(encodedDoc.count, declaredSize, "\(encodedDoc)")
        
        // Assert the document is properly null-terminated.
        XCTAssertEqual(encodedDoc.last, 0, "\(encodedDoc)")
    }
    
    /// This test asserts content from a loop is encoded as expected.
    func testLoop() throws {
        let doc = ComposedDocument {
            ForEach([Int64]([0, 1, 2, 3, 4, 5, 6, 7, 8, 9])) { number in
                String(describing: number) => number
            }
        }
        let expectedDoc = ComposedDocument {
            "0" => Int64(0)
            "1" => Int64(1)
            "2" => Int64(2)
            "3" => Int64(3)
            "4" => Int64(4)
            "5" => Int64(5)
            "6" => Int64(6)
            "7" => Int64(7)
            "8" => Int64(8)
            "9" => Int64(9)
        }
        let encodedDoc = doc.bsonBytes
        let expectedEncodedDoc = expectedDoc.bsonBytes
        XCTAssertEqual(encodedDoc, expectedEncodedDoc)
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
        let encodedDoc = doc.bsonBytes
        let expectedEncodedDoc = expectedDoc.bsonBytes
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
        let encodedDoc = Array(doc.bsonBytes)
        let expectedEncodedDoc = Array(expectedDoc.bsonBytes)
        XCTAssertEqual(encodedDoc, expectedEncodedDoc)
    }

    func testLimitedAvailability() throws {
        let doc = ComposedDocument {
            if #available(macOS 11, iOS 14, tvOS 14, watchOS 7, *) {
                "isOn2020ReleaseOrGreater" => true
            }
        }
        let encodedDoc = Array(doc.bsonBytes)
        let expectedDoc = ComposedDocument {
            "isOn2020ReleaseOrGreater" => true
        }
        let expectedEncodedDoc = Array(expectedDoc.bsonBytes)
        if #available(macOS 11, iOS 14, tvOS 14, watchOS 7, *) {
            XCTAssertEqual(encodedDoc, expectedEncodedDoc)
        } else {
            try XCTSkipIf(true, "test requires specific version to complete")
        }
    }
}
