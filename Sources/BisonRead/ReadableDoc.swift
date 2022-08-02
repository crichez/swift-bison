//
//  ReadableDoc.swift
//  Copyright 2022 Christopher Richez
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

import OrderedCollections

// MARK: Public API & Storage

/// A document where keys and values have been discovered and can be retrieved.
public struct ReadableDoc<Data: Collection> where Data.Element == UInt8 {
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

    /// Initializes a document from its contents and optionally a min/max key.
    /// 
    /// This method exposes `OrderedDictionary` directly and therefore is only internal.
    init(
        _ discovered: OrderedDictionary<String, Data.SubSequence>, 
        minKey: String? = nil, 
        maxKey: String? = nil
    ) {
        self.discovered = discovered
        self.minKey = minKey
        self.maxKey = maxKey
    }
}

// MARK: Type Maps & Parsing

extension ReadableDoc {
    /// A type that describes the size of an encoded value.
    enum ValueSize {
        /// A fixed size, independent of the encoded value.
        case fixed(Int)
        
        /// A variable size, determined by the encoded value itself.
        case variable((Data.SubSequence) -> Result)

        /// The same size rules as the type at the provided index.
        case recursive(UInt8)

        /// The same size rules as two concatenated types at the provided indices.
        indirect case compound(UInt8, UInt8)

        /// An unknown type.
        case none

        /// The result of a variable size measurement closure.
        enum Result: Equatable {
            /// The measurement closure succeeded, and the size of the value was read.
            case success(size: Int)

            /// The measurement closure ran out of bytes, and needs at least the returned number of
            /// bytes in `data`.
            case failure(needAtLeast: Int)
        }
    }

    /// An array where type bytes 0..<20 can be mapped to the size of their encoded values.
    static var typeMap: [ValueSize] {
        [  
            /* [0] Not Set: */ .none,
            /* [1] Double: */ .fixed(8),
            /* [2] String: */ .variable { data in 
                // Ensure the data is at least 5 bytes long for size and null terminator
                guard data.count >= 5 else { return .failure(needAtLeast: 5) }
                // Read the size of the string
                // try! since we already guaranteed four bytes
                let declaredSize = Int(truncatingIfNeeded: try! Int32(bsonBytes: data.prefix(4)))
                // Ensure the data is at least as long as the declared string size plus metadata
                guard data.count >= declaredSize + 4 else { 
                    return .failure(needAtLeast: declaredSize + 4)
                }
                // Return the declared size of the string plus metadata
                return .success(size: declaredSize + 4)
            },
            /* [3] Document: */ .variable { data in 
                // Ensure the document is at least 5 bytes long for the size and terminator
                guard data.count >= 5 else { return .failure(needAtLeast: 5) }
                // Read the size of the document
                // try! since we already guaranteed four bytes
                let size = Int(truncatingIfNeeded: try! Int32(bsonBytes: data.prefix(4)))
                // Ensure the data is at least as long as the declared size of the document
                guard data.count >= size else { return .failure(needAtLeast: size) }
                // Return the declared size of the document
                return .success(size: size)
            },
            /* [4] Array: */ .recursive(3),
            /* [5] Binary: */ .variable { data in 
                // Ensure there are at least 5 bytes for the size and subtype
                guard data.count >= 5 else { return .failure(needAtLeast: 5) }
                // Read the declared size of the value
                // try! since we already guaranteed four bytes
                let declaredSize = Int(truncatingIfNeeded: try! Int32(bsonBytes: data.prefix(4)))
                // Ensure there are enough bytes to read the value plus metadata
                guard data.count >= declaredSize + 5 else { 
                    return .failure(needAtLeast: declaredSize + 5)
                }
                /// Return the declared size of the value plus metadata
                return .success(size: declaredSize + 5)
            },
            /* [6] Undefined (deprecated): */ .fixed(0),
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
                    return .success(size: cursor)
                } else {
                    return .failure(needAtLeast: data.count + 1)
                }
            },
            /* [12] DBPointer (deprecated): */ .compound(2, 7),
            /* [13] JavaScript Code: */ .recursive(2),
            /* [14] Symbol (deprecated): */ .recursive(2),
            /* [15] JavaScript Code with Scope (Deprecated): */ .compound(2, 3),
            /* [16] Int32: */ .fixed(4),
            /* [17] UInt64: */ .fixed(8),
            /* [18] Int64: */ .fixed(8),
            /* [19] Decimal128: */ .fixed(16),
        ]
    }

    /// Initializes a document by parsing its raw data.
    /// 
    /// This initializer does not traverse child documents. To traverse a child document,
    /// get its data from this document's subscript and initialize it separately.
    /// 
    /// - Parameter data: a collection of BSON-encoded bytes that represent a full document
    /// 
    /// - Throws: A `DocError<_>` where `_` is the type of `data` if parsing fails.
    public init(bsonBytes data: Data) throws {
        // Ensure there are at least 5 bytes for the size and terminator
        guard data.count >= 5 else { throw DocError<Data>.docTooShort }
        let terminatorIndex = data.index(data.endIndex, offsetBy: -1)
        guard data[terminatorIndex] == 0 else { throw DocError<Data>.notTerminated }
        // Read and check the declared size of the document against its data
        let size = Int(truncatingIfNeeded: try! Int32(bsonBytes: data.prefix(4)))
        guard data.count == size else { 
            throw DocError<Data>.docSizeMismatch(expectedExactly: size) 
        }

        // Store the type map for the entire parsing process
        let typeMap = Self.typeMap

        // Initialize a mutable dictionary to store each pair
        var discovered: OrderedDictionary<String, Data.SubSequence> = [:]
        // Store mutable min and max key names in case we come accross them
        var minKey = String?.none
        var maxKey = String?.none
        // Keep track of a cursor so we can slice each value accurately
        var cursor = data.index(data.startIndex, offsetBy: 4)

        // Start reading the document up to the null-terminator
        let lastContentByte = data.index(data.endIndex, offsetBy: -1)
        while cursor < lastContentByte {
            // Get the type byte
            let typeIndex = cursor
            let type = data[cursor]
            cursor = data.index(after: cursor)
            
            // Read the key
            let keyStart = cursor
            while data[cursor] != 0 { cursor = data.index(after: cursor) }
            let keyEnd = cursor

            // Parse the key
            let key = String(decoding: data[keyStart..<keyEnd], as: UTF8.self)
            cursor = data.index(after: cursor)
            
            // Check if this is a min or max key
            guard type != 255 else {
                minKey = key
                continue
            }
            guard type != 127 else {
                maxKey = key
                continue
            }
            guard type > 0 && type < 20 else {
                let partialDoc = ReadableDoc(discovered, minKey: minKey, maxKey: maxKey)
                let progress = Progress(parsed: partialDoc, remaining: data[typeIndex...])
                throw DocError<Data>.unknownType(type: type, key: key, progress: progress)
            }

            // Compute the size of the value
            guard let measurement = Self.measure(
                type: type, 
                in: data[cursor...], 
                using: typeMap
            ) else {
                let partialDoc = ReadableDoc(discovered, minKey: minKey, maxKey: maxKey)
                let progress = Progress(parsed: partialDoc, remaining: data[cursor...])
                throw DocError<Data>.unknownType(type: type, key: key, progress: progress)
            }

            // Ensure there are enough bytes left in the document to store that value
            switch measurement {
            case .success(let size):
                // If so, store the value and offset the cursor
                let valueEnd = data.index(cursor, offsetBy: size)
                discovered[key] = data[cursor..<valueEnd]
                cursor = valueEnd
            case .failure(let needAtLeast):
                // If not, compose context and throw
                let partialDoc = ReadableDoc(discovered, minKey: minKey, maxKey: maxKey)
                let progress = Progress(parsed: partialDoc, remaining: data[cursor...])
                throw DocError<Data>.valueSizeMismatch(needAtLeast, key, progress)
            }
        }
        // Assign the discovered contents
        self.discovered = discovered
        self.minKey = minKey
        self.maxKey = maxKey
    }

    /// Measures the size of a value of the specified type in the provided data.
    /// 
    /// This method is a helper to avoid nested switch statements by returning both fixed
    /// and variable sizes as `ValueSize.Result`. This was not done in `typeMap` for clarity.
    static func measure(
        type: UInt8, 
        in data: Data.SubSequence, 
        using typeMap: [ValueSize]
    ) -> ValueSize.Result? {
        switch typeMap[Int(type)] {
        case .fixed(let size):
            // Make sure we have enough data left for this value
            guard data.count >= size else { return .failure(needAtLeast: size) }
            return .success(size: size)
        case .variable(let sizeHandler):
            return sizeHandler(data)
        case .recursive(let alias):
            return measure(type: alias, in: data, using: typeMap)
        case .compound(let alias1, let alias2):
            var size1: Int = 0
            switch measure(type: alias1, in: data, using: typeMap) {
            case .success(let size):
                size1 = size
            case .failure(let needAtLeast):
                return .failure(needAtLeast: needAtLeast)
            case .none: 
                return nil
            }
            switch measure(type: alias2, in: data.dropFirst(size1), using: typeMap) {
            case .success(let size):
                return .success(size: size1 + size)
            case .failure(let needAtLeast):
                return .failure(needAtLeast: size1 + needAtLeast)
            case .none:
                return nil
            }
        case .none:
            return nil
        }
    }
}

// MARK: Protocol Conformance

extension ReadableDoc: Sequence {
    public func makeIterator() -> OrderedDictionary<String, Data.SubSequence>.Iterator {
        discovered.makeIterator()
    }
}

extension ReadableDoc: Equatable where Data.SubSequence : Equatable {
    // This conformance is inherited from `OrderedDictionary`.
}

extension ReadableDoc: Hashable where Data.SubSequence : Hashable {
    // This conformance is inherited from `OrderedDictionary`.
}