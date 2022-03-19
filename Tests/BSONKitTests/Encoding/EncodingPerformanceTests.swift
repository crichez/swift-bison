//
//  EncodingPerformanceTests.swift
//  EncodingPerformanceTests
//
//  Created by Christopher Richez on March 18 2022
//

import XCTest
import BSONKit

/// A test case that measures the time taken to encode documents of varying complexity.
class EncodingPerformanceTests: XCTestCase {
    func testTuple9Doc() {
        let doc = ComposedDocument {
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
        let options = XCTMeasureOptions()
        options.iterationCount = 100
        measure(options: options) {
            let _ = doc.bsonBytes
        }
    }

    func testForEachDoc() {
        let doc = ComposedDocument {
            ForEach(Int64(0)..<10) { n in 
                "\(n)" => n
            }
        }
        let options = XCTMeasureOptions()
        options.iterationCount = 100
        measure(options: options) {
            let _ = doc.bsonBytes
        }
    }
}