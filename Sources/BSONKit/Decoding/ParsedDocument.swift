//
//  ParsedDocument.swift
//  ParsedDocument
//
//  Created by Christopher Richez on March 4th 2022
//

import OrderedCollections

// MARK: Public API & Storage

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

// MARK: Errors

extension ParsedDocument {
    /// A BSON document component, used for errors and debugging.
    public enum Component: Equatable {
        /// A null-terminated key.
        case key

        /// A value with the provided type byte.
        case value(UInt8)
    }

    /// An error that occured during initialization.
    public enum Error: Swift.Error, Equatable {
        /// There were not enough bytes left in the document to read a component.
        ///
        /// This error usually means the document was corrupted, or the
        /// data provided was not a valid BSON document to begin with.
        case docTooShort(needAtLeast: Int, forComponent: Component, inData: Data.SubSequence)

        /// A key was started but a null byte was never found.
        /// 
        /// The attached `keyStart` value is the full document starting at the key that triggered
        /// the error.
        case keyNeverEnds(keyStart: Data.SubSequence)

        /// The type byte declared by a key is not part of the BSON specification.
        ///
        /// This error usually means the document was corrupted, or the
        /// data provided was not a valid BSON document to begin with.
        case unknownType(UInt8)

        public static func == (lhs: Self, rhs: Self) -> Bool {
            switch (lhs, rhs) {
            case (.docTooShort(let lhsNeed, let lhsComp, let lhsData), 
                  .docTooShort(let rhsNeed, let rhsComp, let rhsData)):
                return lhsNeed == rhsNeed && lhsComp == rhsComp && Array(rhsData) == Array(lhsData)
            case (.keyNeverEnds(let lhsKeyStart), .keyNeverEnds(let rhsKeyStart)):
                return Array(lhsKeyStart) == Array(rhsKeyStart)
            case (.unknownType(let lhsType), .unknownType(let rhsType)):
                return lhsType == rhsType
            default: 
                return false
            }
        }
    }
}

// MARK: Type Maps & Parsing

extension ParsedDocument {
    /// A type that describes the size of an encoded value.
    enum ValueSize {
        /// A fixed size, independent of the encoded value.
        case fixed(Int)
        
        /// A variable size, determined by the encoded value itself.
        case variable((Data.SubSequence) throws -> Int)

        /// An unknown type.
        case none
    }

    /// An array where type bytes 0..<20 can be mapped to the size of their encoded values.
    static var typeMap: [ValueSize] {
        [  
            /* [0] Not Set: */ .none,
            /* [1] Double: */ .fixed(8),
            /* [2] String: */ .variable { data in 
                // Ensure the data is at least 5 bytes long for size and null terminator
                guard data.count >= 5 else { 
                    throw Error.docTooShort(needAtLeast: 5, forComponent: .value(2), inData: data)
                }
                // Read the size of the string
                // try! since we already guaranteed four bytes
                let size = Int(truncatingIfNeeded: try! Int32(bsonBytes: data.prefix(4)))
                // Ensure the data is at least as long as the declared string size plus metadata
                guard data.count >= size + 4 else { 
                    throw Error.docTooShort(
                        needAtLeast: size + 4, 
                        forComponent: .value(2), 
                        inData: data) 
                }
                // Return the declared size of the string plus metadata
                return size + 4
            },
            /* [3] Document: */ .variable { data in 
                // Ensure the document is at least 5 bytes long for the size and terminator
                guard data.count >= 5 else {
                    throw Error.docTooShort(needAtLeast: 5, forComponent: .value(3), inData: data)
                }
                // Read the size of the document
                // try! since we already guaranteed four bytes
                let size = Int(truncatingIfNeeded: try! Int32(bsonBytes: data.prefix(4)))
                // Ensure the data is at least as long as the declared size of the document
                guard data.count >= size else {
                    throw Error.docTooShort(
                        needAtLeast: size, 
                        forComponent: .value(3), 
                        inData: data)
                }
                // Return the declared size of the document
                return size
            },
            /* [4] Array: */ .variable { data in 
                // Ensure the document is at least 5 bytes long for the size and terminator
                guard data.count >= 5 else {
                    throw Error.docTooShort(needAtLeast: 5, forComponent: .value(4), inData: data)
                }
                // Read the size of the document
                // try! since we already guaranteed four bytes
                let size = Int(truncatingIfNeeded: try! Int32(bsonBytes: data.prefix(4)))
                // Ensure the data is at least as long as the declared size of the document
                guard data.count >= size else {
                    throw Error.docTooShort(
                        needAtLeast: size, 
                        forComponent: .value(4), 
                        inData: data)
                }
                // Return the declared size of the document
                return size
            },
            /* [5] Binary: */ .variable { data in 
                // Ensure there are at least 5 bytes for the size and subtype
                guard data.count >= 5 else {
                    throw Error.docTooShort(needAtLeast: 5, forComponent: .value(5), inData: data)
                }
                // Read the declared size of the value
                // try! since we already guaranteed four bytes
                let size = Int(truncatingIfNeeded: try! Int32(bsonBytes: data.prefix(4)))
                // Ensure there are enough bytes to read the value plus metadata
                guard data.count >= size + 5 else {
                    throw Error.docTooShort(
                        needAtLeast: size + 5, 
                        forComponent: .value(5), 
                        inData: data)
                }
                /// Return the declared size of the value plus metadata
                return size + 5
            },
            /* [6] Undefined (deprecated): */ .none,
            /* [7] ObjectID: */ .fixed(12),
            /* [8] Bool: */ .fixed(1),
            /* [9] UTC DateTime: */ .fixed(8),
            /* [10] Null: */ .fixed(0),
            /* [11] Regular Expression: */ .variable { data in 
                var zeroesFound = 0
                var cursor = 0
                for byte in data {
                    cursor += 1
                    if byte == 0 { zeroesFound += 1 }
                    if zeroesFound == 2 { break }
                }
                if zeroesFound == 2 {
                    return cursor
                } else {
                    throw Error.docTooShort(
                        needAtLeast: cursor + 1, 
                        forComponent: .value(11), 
                        inData: data)
                }
            },
            /* [12] DBPointer (deprecated): */ .none,
            /* [13] JavaScript Code: */ .variable { data in 
                // Ensure the data is at least 5 bytes long for size and null terminator
                guard data.count >= 5 else { 
                    throw Error.docTooShort(needAtLeast: 5, forComponent: .value(13), inData: data)
                }
                // Read the size of the string
                // try! since we already guaranteed four bytes
                let size = Int(truncatingIfNeeded: try! Int32(bsonBytes: data.prefix(4)))
                // Ensure the data is at least as long as the declared string size plus metadata
                guard data.count >= size + 4 else { 
                    throw Error.docTooShort(
                        needAtLeast: size + 4, 
                        forComponent: .value(13), 
                        inData: data) 
                }
                // Return the declared size of the string plus metadata
                return size + 4
            },
            /* [14] Symbol (deprecated): */ .none,
            /* [15] JavaScript Code with Scope (Deprecated): */ .none,
            /* [16] Int32: */ .fixed(4),
            /* [17] UInt64: */ .fixed(8),
            /* [18] Int64: */ .fixed(8),
            /* [19] Decimal128: */ .fixed(16),
        ]
    }

    /// Returns the size of a value in bytes.
    /// 
    /// - Parameters:
    ///   - type: a BSON type byte between 1 and 19
    ///   - data: a sliced document starting at the value to measure
    ///   - typeMap: an array that maps BSON type bytes to their `ValueSize`
    /// 
    /// - Returns: 
    /// The size of the first value in `data` using the rules defined in the `typeMap` 
    /// for that `type`.
    /// 
    /// - Throws:
    /// `ParsedDocument<_>.Error.docTooShort(needAtLeast:forComponent:inData:)` 
    /// if computing the variable size of a value failed. `ParsedDocument<_>.Error.unknownType(_)`
    /// if the type byte provided is not part of the BSON specification. In both those errors,
    /// the data type `_` must be specified in your error capture for the error to match.
    static func encodedSizeOf(
        type: UInt8, 
        data: Data.SubSequence, 
        typeMap: [ValueSize]
    ) throws -> Int {
        // Ensure the type byte is between 
        guard 0 < type && type < 20 else {
            throw Error.unknownType(type)
        }
        switch typeMap[Int(truncatingIfNeeded: type)] {
        case .fixed(let size):
            return size
        case .variable(let variableSize):
            return try variableSize(data)
        case .none:
            throw Error.unknownType(type)
        }
    }

    public init(bsonBytes data: Data) throws {
        // Ensure there are at least 5 bytes for the size and terminator
        guard data.count >= 5 else {
            throw Error.docTooShort(
                needAtLeast: 5, 
                forComponent: .value(3), 
                inData: data.dropFirst(0))
        }
        // Read and check the declared size of the document against its data
        let size = Int(truncatingIfNeeded: try Int32(bsonBytes: data.prefix(4)))
        guard data.count == size else { 
            throw Error.docTooShort(
                needAtLeast: size, 
                forComponent: .value(3), 
                inData: data.dropFirst(0)) 
        }

        // Store the type map for the entire parsing process
        let typeMap = Self.typeMap
        // Initialize a mutable dictionary to store each pair
        var discovered = OrderedDictionary<String, Data.SubSequence>()
        // Store mutable min and max key names in case we come accross them
        var minKey = String?.none
        var maxKey = String?.none
        // Keep track of a cursor so we can slice each value accurately
        var cursor = data.index(data.startIndex, offsetBy: 4)
        let lastContentByte = data.index(data.endIndex, offsetBy: -1)
        while cursor < lastContentByte {
            // Get the type byte
            let type = data[cursor]
            cursor = data.index(after: cursor)
            
            // Read the key
            let keyStart = cursor
            while data[cursor] != 0 {
                cursor = data.index(after: cursor)
                guard cursor < lastContentByte else {
                    throw Error.keyNeverEnds(keyStart: data[keyStart...])
                }
            }
            let keyEnd = cursor
            let name = String(decoding: data[keyStart..<keyEnd], as: UTF8.self)
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

// MARK: Protocol Conformance

extension ParsedDocument: Sequence {
    public func makeIterator() -> some IteratorProtocol {
        discovered.makeIterator()
    }
}