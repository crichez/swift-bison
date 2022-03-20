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

    public init(bsonBytes data: Data) throws {
        let parser = Parser<Data>()

        // Read and check the declared size of the document against its data
        let sizeStart = data.startIndex
        let sizeEnd = data.index(sizeStart, offsetBy: 4)
        let size = Int(try Int32(bsonBytes: data[sizeStart..<sizeEnd]))
        guard data.count == size else { throw ParsingError.sizeMismatch }

        // Start reading the document
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
            let size = try parser.encodedSizeOf(bsonType: type, in: data[cursor...])
            
            // Store the pair
            discovered[name] = data[cursor..<data.index(cursor, offsetBy: size)]
            cursor = data.index(cursor, offsetBy: size)
        }
        // Assign the discovered contents
        self.discovered = discovered
        self.minKey = minKey
        self.maxKey = maxKey
    }

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
}

extension ParsedDocument: Sequence {
    public func makeIterator() -> some IteratorProtocol {
        discovered.makeIterator()
    }
}