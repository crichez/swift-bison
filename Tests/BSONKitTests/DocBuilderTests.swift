//
//  DocBuilderTests.swift
//  
//
//  Created by Christopher Richez on 2/6/22.
//

@testable
import BSONKit
import XCTest

class DocBuilderTests: XCTestCase {
    func testSingleValue() {
        @DocBuilder func content() -> some BinaryConvertible {
            true
        }
        XCTAssertTrue(type(of: content()) == Bool.self)
    }

    func testTuple2() {
        @DocBuilder func content() -> some BinaryConvertible {
            "one"
            "two"
        }
        XCTAssertTrue(type(of: content()) == Tuple2<String, String>.self)
    }

    func testTuple3() {
        @DocBuilder func content() -> some BinaryConvertible {
            Int32(0)
            Int64(1)
            Double(2)

        }
        XCTAssertTrue(type(of: content()) == Tuple3<Int32, Int64, Double>.self)
    }
}
