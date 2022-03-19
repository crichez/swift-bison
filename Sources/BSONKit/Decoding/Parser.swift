//
//  Parser.swift
//  Parser
//
//  Created by Christopher Richez on March 4 2022
//

/// The default parser for BSON specification types.
struct Parser<Doc> where Doc : Collection, Doc.Element == UInt8 {
    /// A type that describes the size of an encoded value.
    enum EncodedSize {
        /// A fixed size, independent of the encoded value.
        case fixed(Int)
        
        /// A variable size, determined by the encoded value itself.
        case variable((Doc.SubSequence) throws -> Int)

        /// An unknown type byte.
        case none
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

    let typeMap: [EncodedSize] = [
        .none,
        .fixed(8),
        Self.stringHandler,
        Self.docHandler,
        Self.docHandler,
        .variable { data in 
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
        .none,
        .fixed(12),
        .fixed(1),
        .fixed(8),
        .fixed(0),
        .variable { data in 
            var zeroesFound = 0
            var cursor = 0
            for byte in data where byte == 0 {
                guard zeroesFound == 2 else { break }
                zeroesFound += 1
                cursor += 1
            }
            return cursor
        },
        .none,
        Self.stringHandler,
        .none,
        .none,
        .fixed(4),
        .fixed(8),
        .fixed(8),
        .fixed(16),
    ]

    public init(bsonData: Doc) {
        self.raw = bsonData
    }

    let raw: Doc

    func encodedSizeOf(bsonType: UInt8, in remainingDoc: Doc.SubSequence) throws -> Int 
    where Doc : Collection, Doc.Element == UInt8 {
        guard 0 < bsonType && bsonType < 20 else {
            throw ParsingError.unknownType(bsonType)
        }
        switch typeMap[Int(truncatingIfNeeded: bsonType)] {
        case .fixed(let size):
            return size
        case .variable(let ruler):
            return try ruler(remainingDoc)
        case .none:
            throw ParsingError.unknownType(bsonType)
        }
    }

    func parse() throws -> ParsedDocument<Doc> {
        try ParsedDocument(bsonData: raw)
    }
}