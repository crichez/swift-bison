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
            
        }
        measure {
            let _ = doc.bsonEncoded
        }
    }
}