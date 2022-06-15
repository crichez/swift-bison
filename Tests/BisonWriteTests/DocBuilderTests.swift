//
//  DocBuilderTests.swift
//  
//
//  Created by Christopher Richez on 2/6/22.
//

import BisonWrite
import XCTest

class DocBuilderTests: XCTestCase {
    func testConditional() throws {
        let flag = true
        let doc = WritableDoc {
            if flag {
                "test" => "passed"
            } else {
                "test" => "failed"
            }
        }
        let expectedDoc = WritableDoc {
            "test" => "passed"
        }
        XCTAssertEqual(doc.bsonBytes, expectedDoc.bsonBytes)
    }

    func testOptional() throws {
        let flag = false
        let doc = WritableDoc {
            if flag {
                "zero" => Int64(0)
            }
            if !flag {
                "one" => Int64(1)
            }
        }
        let expectedDoc = WritableDoc {
            "one" => Int64(1)
        }
        XCTAssertEqual(doc.bsonBytes, expectedDoc.bsonBytes)
    }

    func testLimitedAvailability() throws {
        if #available(macOS 11, iOS 14, tvOS 14, watchOS 7, *) {
            let doc = WritableDoc {
                if #available(macOS 11, iOS 14, tvOS 14, watchOS 7, *) {
                    "isOn2020ReleaseOrGreater" => true
                }
            }
            let expectedDoc = WritableDoc {
                "isOn2020ReleaseOrGreater" => true
            }
            XCTAssertEqual(doc.bsonBytes, expectedDoc.bsonBytes)
        } else {
            try XCTSkipIf(true, "this test requires a specific platform & version")
        }
    }
}
