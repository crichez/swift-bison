//
//  WritableArrayBuilderTests.swift
//
//
//  Created by Christopher Richez on July 29 2022.
//

@testable
import BisonWrite
import XCTest

class WritableArrayBuilderTests: XCTestCase {
    func testBuildBlock() {
        let doc = WritableArray {
            "zero"
            "one"
            "two"
            "three"
        }
        var encodedDoc = [UInt8]()
        doc.append(to: &encodedDoc)
        let expectedDoc = WritableDoc {
            "0" => "zero"
            "1" => "one"
            "2" => "two"
            "3" => "three"
        }
        let expectedEncodedDoc = expectedDoc.encode(as: [UInt8].self)
        XCTAssertEqual(encodedDoc, expectedEncodedDoc)
    }

    func testBuildEither() {
        let skipTwo = true
        let doc = WritableArray {
            "zero"
            "one"
            if skipTwo {
                "three"
            } else {
                "two"
            }
        }
        var encodedDoc = [UInt8]()
        doc.append(to: &encodedDoc)
        let expectedDoc = WritableDoc {
            "0" => "zero"
            "1" => "one"
            "2" => "three"
        }
        let expectedEncodedDoc = expectedDoc.encode(as: [UInt8].self)
        XCTAssertEqual(encodedDoc, expectedEncodedDoc)
    }

    func testBuildArray() {
        let numbers: Range<Int64> = 0..<100
        let doc = WritableArray {
            for number in numbers {
                number
            }
        }
        var encodedDoc = [UInt8]()
        doc.append(to: &encodedDoc)
        let expectedDoc = WritableDoc {
            ForEach(numbers) { number in 
                String(number) => number
            }
        }
        .encode(as: [UInt8].self)
        XCTAssertEqual(encodedDoc, expectedDoc)
    }

    /// Asserts blocks declared in control-flow branches are stitched at the appropriate index.
    func testBlockStitching() {
        let doc = WritableArray {
            0.0
            1.0
            do {
                2.0
                3.0
            }
            4.0
        }
        .encode(as: [UInt8].self)
        let expectedDoc = WritableDoc {
            "0" => 0.0
            "1" => 1.0
            "2" => 2.0
            "3" => 3.0
            "4" => 4.0
        }
        .encode(as: [UInt8].self)
        XCTAssertEqual(doc, expectedDoc)
    }

    /// Asserts nested documents are indexed as expected.
    func testNestedDoc() {
        let doc = WritableArray {
            WritableArray {
                "zero"
            }
            WritableArray {
                "one"
            }
        }
        .encode(as: Data.self)
        let expectedDoc = WritableDoc {
            "0" => WritableArray {
                "zero"
            }
            "1" => WritableArray {
                "one"
            }
        }
        .encode(as: Data.self)
        XCTAssertEqual(doc, expectedDoc)
    }
}