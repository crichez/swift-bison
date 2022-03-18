//
//  DocBuilderTests.swift
//  
//
//  Created by Christopher Richez on 2/6/22.
//

import BSONKit
import XCTest

class DocBuilderTests: XCTestCase {
    func testConditionalEncodes() throws {
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
        XCTAssertEqual(doc.bsonBytes, expectedDoc.bsonBytes)
    }

    func testOptionalEncodes() throws {
        let flag = false
        let doc = ComposedDocument {
            if flag {
                "zero" => Int64(0)
            }
            if !flag {
                "one" => Int64(1)
            }
        }
        let expectedDoc = ComposedDocument {
            "one" => Int64(1)
        }
        XCTAssertEqual(doc.bsonBytes, expectedDoc.bsonBytes)
    }

    func testLimitedAvailabilityEncodes() throws {
        if #available(macOS 11, iOS 14, tvOS 14, watchOS 7, *) {
            let doc = ComposedDocument {
                if #available(macOS 11, iOS 14, tvOS 14, watchOS 7, *) {
                    "isOn2020ReleaseOrGreater" => true
                }
            }
            let expectedDoc = ComposedDocument {
                "isOn2020ReleaseOrGreater" => true
            }
            XCTAssertEqual(doc.bsonBytes, expectedDoc.bsonBytes)
        } else {
            try XCTSkipIf(true, "this test requires a specific platform & version")
        }
    }
    
    func testGroupDoesntAffectDocStructure() throws {
        let doc = ComposedDocument {
            Group {
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
            Group {
                "10" => Int64(10)
                "11" => Int64(11)
                "12" => Int64(12)
            }
        }
        let expectedDoc = ComposedDocument {
            ForEach(Int64(0)...12) { number in
                String(describing: number) => number
            }
        }
        XCTAssertEqual(doc.bsonBytes, expectedDoc.bsonBytes)
    }
}
