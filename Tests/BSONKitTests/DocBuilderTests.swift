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
    func testSingleValue() throws {
        @DocBuilder func buildContent() -> some BinaryConvertible {
            true
        }

        let content = buildContent()
        let expectedType = Bool.self
        XCTAssertTrue(type(of: content) == expectedType)

        let encodedContent = try content.encode()
        let expectedEncodedType = Bool.Encoded.self
        XCTAssertTrue(type(of: encodedContent) == expectedEncodedType)
    }

    typealias EncodedString = Chain3<[UInt8], String.UTF8View, CollectionOfOne<UInt8>>

    func testTuple2() throws {
        @DocBuilder func buildContent() -> some BinaryConvertible {
            "one"
            "two"
        }

        let content = buildContent()
        let expectedType = Tuple2<String, String>.self
        XCTAssertTrue(type(of: content) == expectedType)

        let encodedContent = try content.encode()
        let expectedEncodedType = Chain2<EncodedString, EncodedString>.self
        XCTAssertTrue(type(of: encodedContent) == expectedEncodedType)
    }

    func testTuple3() throws {
        @DocBuilder func buildContent() -> some BinaryConvertible {
            Int32(0)
            Int64(1)
            Double(2)
        }

        let content = buildContent()
        let expectedType = Tuple3<Int32, Int64, Double>.self
        XCTAssertTrue(type(of: content) == expectedType)

        let encodedContent = try content.encode()
        let expectedEncodedType = Chain3<[UInt8], [UInt8], [UInt8]>.self
        XCTAssertTrue(type(of: encodedContent) == expectedEncodedType)
    }

    func testTuple4() throws {
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
        let expectedEncodedType = Chain4<[UInt8], [UInt8], [UInt8], EncodedString>.self
        XCTAssertTrue(type(of: encodedContent) == expectedEncodedType)
    }

    func testTuple5() throws {
        @DocBuilder func buildContent() -> some BinaryConvertible {
            Int32(0)
            Int64(1)
            Double(2)
            "three"
            false
        }

        let content = buildContent()
        let expectedType = Tuple5<Int32, Int64, Double, String, Bool>.self
        XCTAssertTrue(type(of: content) == expectedType)

        let encodedContent = try content.encode()
        let expectedEncodedType = Chain5<[UInt8], [UInt8], [UInt8], EncodedString, CollectionOfOne<UInt8>>.self
        XCTAssertTrue(type(of: encodedContent) == expectedEncodedType)
    }
}
