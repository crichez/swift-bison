//
//  DocBuilderTests.swift
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
