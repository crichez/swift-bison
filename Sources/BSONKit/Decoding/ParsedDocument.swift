//
//  ParsedDocument.swift
//  ParsedDocument
//
//  Created by Christopher Richez on March 4th 2022
//

import OrderedCollections

/// A document where keys and values have been discovered and can be retrieved.
public struct ParsedDocument<Data: Collection> where Data.Element == UInt8 {
    /// The keys and discovered values in this document.
    let discovered: OrderedDictionary<String, Data.SubSequence>

    /// The keys discovered in this document.
    public var keys: OrderedSet<String> {
        discovered.keys
    }

    /// The value blocks discovered in this document.
    public var values: OrderedDictionary<String, Data.SubSequence>.Values {
        discovered.values
    }

    /// Returns the value data block for the specified key, or `nil` if the key doesn't exist.
    public subscript(key: String) -> Data.SubSequence? {
        discovered[key]
    }

    /// The declared minimum key for this document.
    let minKey: String?

    /// The minimum value declared by this document, or `nil` if none was declared.
    public var min: Data.SubSequence? {
        guard let minKey = minKey, let min = discovered[minKey] else { return nil }
        return min
    }

    /// The declared maximum key for this document.
    let maxKey: String?

    /// The maximum value declared by this document, or `nil` if none was declared.
    public var max: Data.SubSequence? {
        guard let maxKey = maxKey, let max = discovered[maxKey] else { return nil }
        return max
    }
}

extension ParsedDocument {
    /// A type that describes the size of an encoded value.
    enum ValueSize {
        /// A fixed size, independent of the encoded value.
        case fixed(Int)
        
        /// A variable size, determined by the encoded value itself.
        case variable((Data.SubSequence) throws -> Int)

        /// An unknown type byte.
        case none
    }

    static var stringHandler: ValueSize {
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

    static var docHandler: ValueSize {
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

    /// An array where type bytes 0..<20 can be mapped to the size of their encoded values.
    static var typeMap: [ValueSize] {
        [  
            .none,
            .fixed(8),
            stringHandler,
            docHandler,
            docHandler,
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
            stringHandler,
            .none,
            .none,
            .fixed(4),
            .fixed(8),
            .fixed(8),
            .fixed(16),
        ]
    }

    static func encodedSizeOf(
        type: UInt8, 
        data: Data.SubSequence, 
        typeMap: [ValueSize]
    ) throws -> Int {
        guard 0 < type && type < 20 else {
            throw ParsingError.unknownType(type)
        }
        switch typeMap[Int(truncatingIfNeeded: type)] {
        case .fixed(let size):
            return size
        case .variable(let variableSize):
            return try variableSize(data)
        case .none:
            throw ParsingError.unknownType(type)
        }
    }

    public init(bsonBytes data: Data) throws {
        // Read and check the declared size of the document against its data
        let sizeStart = data.startIndex
        let sizeEnd = data.index(sizeStart, offsetBy: 4)
        let size = Int(try Int32(bsonBytes: data[sizeStart..<sizeEnd]))
        guard data.count == size else { throw ParsingError.sizeMismatch }

        // Start reading the document
        let typeMap = Self.typeMap
        var discovered = OrderedDictionary<String, Data.SubSequence>()
        var minKey = String?.none
        var maxKey = String?.none
        var cursor = sizeEnd
        while cursor < data.index(data.endIndex, offsetBy: -1) {
            // Get the type byte
            let type = data[cursor]
            cursor = data.index(after: cursor)
            
            // Read the name of the key
            let nameStart = cursor
            var nameEndOffset = 0
            while cursor < data.endIndex && data[cursor] != 0 {
                nameEndOffset += 1
                cursor = data.index(after: cursor)
            }
            guard cursor < data.endIndex else { throw ParsingError.unexpectedEnd }
            let nameEnd = data.index(nameStart, offsetBy: nameEndOffset)
            let name = String(decoding: data[nameStart..<nameEnd], as: UTF8.self)
            cursor = data.index(after: cursor)
            
            // Check if this is a min or max key
            guard type != 255 else {
                minKey = name
                continue
            }
            guard type != 127 else {
                maxKey = name
                continue
            }

            // Compute the size of the value
            let size = try Self.encodedSizeOf(type: type, data: data[cursor...], typeMap: typeMap)
            
            // Store the pair
            discovered[name] = data[cursor..<data.index(cursor, offsetBy: size)]
            cursor = data.index(cursor, offsetBy: size)
        }
        // Assign the discovered contents
        self.discovered = discovered
        self.minKey = minKey
        self.maxKey = maxKey
    }
}

extension ParsedDocument: Sequence {
    public func makeIterator() -> some IteratorProtocol {
        discovered.makeIterator()
    }
}