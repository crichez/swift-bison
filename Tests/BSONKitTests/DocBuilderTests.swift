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
    /// This test compares the type of the value outputted by `DocBuilder` to developer expectations.
    func testBuilderTypes() throws {
        @DocBuilder func buildContent() -> some BinaryConvertible {
            Group {
                "zero" => Int32(0)
                "one" => Int64(1)
                "two" => Double(2)
                "three" => "three"
            }
            Group {
                "four" => UInt64(4)
            }
        }

        let content = buildContent()
        let expectedType = Tuple2<Group<Tuple4<Pair<Int32>, Pair<Int64>, Pair<Double>, Pair<String>>>, Group<Pair<UInt64>>>.self
        XCTAssertTrue(type(of: content) == expectedType, "built type: \(type(of: content))")

        let encodedContent = try content.encode()
        let expectedEncodedType = Chain2<Chain4<Pair<Int32>.Encoded, Pair<Int64>.Encoded, Pair<Double>.Encoded, Pair<String>.Encoded>, Pair<UInt64>.Encoded>.self
        XCTAssertTrue(type(of: encodedContent) == expectedEncodedType, "built type: \(type(of: encodedContent))")
    }
    
    /// This test asserts the content, size and terminator of the document are property encoded.
    func testDocument() throws {
        let doc = Document {
            "test" => true
        }
        let bytes = Array(try doc.encode())
        let declaredSizeData = UnsafeMutableRawBufferPointer.allocate(byteCount: 4, alignment: 4)
        declaredSizeData.copyBytes(from: bytes.prefix(4))
        let declaredSize = Int(declaredSizeData.load(as: Int32.self))
        XCTAssertEqual(bytes.count, declaredSize, "\(bytes)")
        XCTAssertEqual(bytes.last, 0, "\(bytes)")
    }
    
    /// This test asserts content from a loop is encoded as expected.
    func testLoop() throws {
        let doc = Document {
            ForEach([Int64]([0, 1, 2, 3, 4, 5, 6, 7, 8, 9])) { number in
                String(describing: number) => number
            }
        }
        let encodedDoc = Array(try doc.encode())
        XCTAssertEqual(encodedDoc.count, (3 * 10) + (8 * 10) + 5)
    }

    func testConditional() throws {
        let flag = true
        let doc = Document {
            if flag {
                "test" => "passed"
            } else {
                "test" => "failed"
            }
        }
        let expectedDoc = Document {
            "test" => "passed"
        }
        let encodedDoc = Array(try doc.encode())
        let expectedEncodedDoc = Array(try expectedDoc.encode())
        XCTAssertEqual(encodedDoc, expectedEncodedDoc)
    }

    func testOptional() throws {
        let flag = false
        let doc = Document {
            if flag {
                "zero" => Int64(0)
            }
            "one" => Int64(1)
        }
        let expectedDoc = Document {
            "one" => Int64(1)
        }
        let encodedDoc = Array(try doc.encode())
        let expectedEncodedDoc = Array(try expectedDoc.encode())
        XCTAssertEqual(encodedDoc, expectedEncodedDoc)
    }

    func testLimitedAvailability() throws {
        let doc = Document {
            if #available(macOS 11, iOS 14, tvOS 14, watchOS 7, *) {
                "isOn2020ReleaseOrGreater" => true
            }
        }
        let encodedDoc = Array(try doc.encode())
        let expectedDoc = Document {
            "isOn2020ReleaseOrGreater" => true
        }
        let expectedEncodedDoc = Array(try expectedDoc.encode())
        if #available(macOS 11, iOS 14, tvOS 14, watchOS 7, *) {
            XCTAssertEqual(encodedDoc, expectedEncodedDoc)
        } else {
            try XCTSkipIf(true, "test requires specific version to complete")
        }
    }

    func testNestedDocuments() throws {
        let doc = Document {
            "nestedDoc" => Document {
                "test" => true
            }
        }

        let expectedType = Document<Pair<Document<Pair<Bool>>>>.self
        let actualType = type(of: doc)
        XCTAssertTrue(expectedType == actualType, "\(actualType)")

        let encodedDoc = try doc.encode()
        let expectedEncodedType = Chain3<Int32.Encoded, Pair<Document<Pair<Bool>>>.Encoded, CollectionOfOne<UInt8>>.self
        let actualEncodedType = type(of: encodedDoc)
        XCTAssertTrue(expectedEncodedType == actualEncodedType, "\(actualEncodedType)")
    }
}
