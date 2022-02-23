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
    func testBuilder() throws {
        @DocBuilder func buildContent() -> some BinaryConvertible {
            Int32(0)
            Int64(1)
            Double(2)
            "three"
        }

        let content = buildContent()
        let expectedType = Tuple4<Int32, Int64, Double, String>.self
        XCTAssertTrue(type(of: content) == expectedType)

        let encodedContent = try content.encode()
        let expectedEncodedType = Chain4<Int32.Encoded, Int64.Encoded, Double.Encoded, String.Encoded>.self
        XCTAssertTrue(type(of: encodedContent) == expectedEncodedType)
    }
}
