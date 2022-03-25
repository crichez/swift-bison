//
//  DocBuilderTests.swift
//  
//
//  Created by Christopher Richez on 2/6/22.
//

import BSONCompose
import XCTest

class DocBuilderTests: XCTestCase {
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
        XCTAssertEqual(doc.bsonBytes, expectedDoc.bsonBytes)
    }

    func testOptional() throws {
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

    func testLimitedAvailability() throws {
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
}
