//
//  ParsingPerformanceTests.swift
//  ParsingPerformanceTests
//
//  Created by Christopher Richez on March 18 2022
//

import BSONKit
import XCTest

class ParsingPerformanceTests: XCTestCase {
    func testLargeDoc() throws {
        let doc = ComposedDocument {
            ForEach(Int64(0)..<1000) { n in 
                "\(n)" => n
            }
        }
        let encodedDoc = doc.bsonBytes
        let options = XCTMeasureOptions()
        options.iterationCount = 100
        measure(options: options) {
            let decodedDoc = try! ParsedDocument(bsonData: encodedDoc)
            for n in Int64(0)..<1000 {
                let _ = try! Int64(bsonData: decodedDoc["\(n)"]!)
            }
        }
    }
}