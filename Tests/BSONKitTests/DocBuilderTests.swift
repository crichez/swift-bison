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
}
