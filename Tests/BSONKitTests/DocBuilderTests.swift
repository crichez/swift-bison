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
            "zero" => Int32(0)
            "one" => Int64(1)
            "two" => Double(2)
            "three" => "three"
        }

        let content = buildContent()
        let expectedType = Tuple4<Pair<Int32>, Pair<Int64>, Pair<Double>, Pair<String>>.self
        XCTAssertTrue(type(of: content) == expectedType)

        let encodedContent = try content.encode()
        let expectedEncodedType = Chain4<Pair<Int32>.Encoded, Pair<Int64>.Encoded, Pair<Double>.Encoded, Pair<String>.Encoded>.self
        XCTAssertTrue(type(of: encodedContent) == expectedEncodedType)
    }
}
