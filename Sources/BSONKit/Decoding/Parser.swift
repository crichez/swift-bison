//
//  Parser.swift
//  Parser
//
//  Created by Christopher Richez on March 4 2022
//

/// A type that can return the encoded size of a BSON value in a raw document.
public protocol Parser {
    /// The data type of the document being parsed.
    associatedtype Doc: Collection where Doc.Element == UInt8

    /// A raw, unparsed BSON document.
    var raw: Doc { get }

    /// Reads the next value in the remaining document and returns its size in bytes.
    /// 
    /// - Parameters:
    ///   - bsonType: the BSON type byte associated with this value
    ///   - remainingDoc: the remaining unparsed document from the start of the value to size
    /// 
    /// - Returns: 
    /// The size of the next encoded value in bytes.
    func encodedSizeOf(bsonType: UInt8, in remainingDoc: Doc.SubSequence) throws -> Int
}

extension Parser {
    public func parse() throws -> ParsedDocument<Doc> {
        try ParsedDocument(bsonData: raw, parser: self)
    }
}

/// The default parser for BSON specification types.
public struct BSONParser<Doc>: Parser where Doc : Collection, Doc.Element == UInt8 {
    /// A type that describes the size of an encoded value.
    enum EncodedSize {
        /// A fixed size, independent of the encoded value.
        case fixed(Int)
        
        /// A variable size, determined by the encoded value itself.
        case variable((Doc.SubSequence) throws -> Int)
    }

    static var stringHandler: EncodedSize {
        .variable { data in 
            guard data.count >= 5 else { throw ParsingError.sizeMismatch }
            let sizeBytes = UnsafeMutableRawBufferPointer.allocate(byteCount: 4, alignment: 4)
            let sizeStart = data.startIndex
            let sizeEnd = data.index(sizeStart, offsetBy: 4)
            sizeBytes.copyBytes(from: data[sizeStart..<sizeEnd])
            let size = Int(sizeBytes.load(as: Int32.self))
            guard data.count >= size + 4 else { throw ParsingError.sizeMismatch }
            return size + 4
        }
    } 

    static var docHandler: EncodedSize {
        .variable { data in 
            guard data.count >= 5 else {
                throw ParsingError.sizeMismatch
            }
            let sizeBytes = UnsafeMutableRawBufferPointer.allocate(byteCount: 4, alignment: 4)
            let sizeStart = data.startIndex
            let sizeEnd = data.index(sizeStart, offsetBy: 4)
            sizeBytes.copyBytes(from: data[sizeStart..<sizeEnd])
            let size = Int(sizeBytes.load(as: Int32.self))
            guard data.count >= size else {
                throw ParsingError.sizeMismatch
            }
            return size
        }
    }

    let typeMap: [UInt8 : EncodedSize] = [
        1: .fixed(8),
        2: stringHandler,
        3: docHandler,
        4: docHandler,
        5: .variable { data in 
            guard data.count >= 5 else {
                throw ParsingError.sizeMismatch
            }
            let sizeBytes = UnsafeMutableRawBufferPointer.allocate(byteCount: 4, alignment: 4)
            let sizeStart = data.startIndex
            let sizeEnd = data.index(sizeStart, offsetBy: 4)
            sizeBytes.copyBytes(from: data[sizeStart..<sizeEnd])
            let size = Int(sizeBytes.load(as: Int32.self))
            guard data.count >= size + 5 else {
                throw ParsingError.sizeMismatch
            }
            return size + 5
        },
        7: .fixed(12),
        8: .fixed(1),
        9: .fixed(8),
        10: .fixed(0),
        11: .variable { data in 
            var zeroesFound = 0
            var cursor = 0
            for byte in data where byte == 0 {
                guard zeroesFound == 2 else { break }
                zeroesFound += 1
                cursor += 1
            }
            return cursor
        },
        13: stringHandler,
        16: .fixed(4),
        17: .fixed(8),
        18: .fixed(8),
        19: .fixed(16),
        255: .fixed(0),
        127: .fixed(0),
    ]

    public init(bsonData: Doc) {
        self.raw = bsonData
    }

    public let raw: Doc

    public func encodedSizeOf(bsonType: UInt8, in remainingDoc: Doc.SubSequence) throws -> Int 
    where Doc : Collection, Doc.Element == UInt8 {
        switch typeMap[bsonType] {
        case .fixed(let size):
            return size
        case .variable(let ruler):
            return try ruler(remainingDoc)
        case .none:
            throw ParsingError.unknownType(bsonType)
        }
    }
}