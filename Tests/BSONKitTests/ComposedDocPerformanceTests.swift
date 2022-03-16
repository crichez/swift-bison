//
//  ComposedDocPerformanceTests.swift
//
//
//  Created by Christopher Richez on March 14 2022
//

import BSONKit
import XCTest

class ComposedDocPerformanceTests: XCTestCase {
    func testEncodeToArrayPerformance() throws {
        let doc = ComposedDocument {
            "test" => true
            ForEach(Int64(0)..<10) { n in
                String(describing: n) => n
            }
            "complete?" => "yes"
            "1" => 1.0
            "2" => 2.0
            "3" => 3.0
            "4" => 4.0
            "5" => 5.0
            "6" => 6.0
            ForEach(Int64(7)..<100) { n in
                String(describing: n) => n
            }
        }
        measure {
            let _ = doc.bsonBytes
        }
    }
}
