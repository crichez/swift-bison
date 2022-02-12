//
//  BSONValue.swift
//  
//
//  Created by Christopher Richez on 2/6/22.
//

import Algorithms

typealias Byte = CollectionOfOne<UInt8>

/// A value that can be encoded into a BSON document.
protocol BSONValue {
    /// The type used by the encoded representation of this value.
    associatedtype Encoded: Sequence where Encoded.Element == UInt8
    
    /// Encodes the value into its `Encoded` type.
    func encode() throws -> Encoded
    
    /// The BSON type byte to attach to the key associated with this value.
    var type: Byte { get }
}

typealias Chained = Chain2Sequence

extension Int32: BSONValue {
    typealias Encoded = [UInt8]
    
    var type: Byte { CollectionOfOne(0x10) }
    
    func encode() throws -> Encoded {
        withUnsafeBytes(of: self) { bytes in
            Array(bytes)
        }
    }
}

extension String: BSONValue {
    typealias Encoded = Chained<Int32.Encoded, Chained<String.UTF8View, Byte>>
    
    var type: Byte { CollectionOfOne(0x02) }
    
    func encode() throws -> Encoded {
        let content = utf8
        let terminator = CollectionOfOne<UInt8>(0x00)
        let terminatedContent = chain(content, terminator)
        guard let size = Int32(exactly: terminatedContent.count) else {
            fatalError("string too long")
        }
        let encodedValue = chain(try size.encode(), terminatedContent)
        return encodedValue
    }
}

extension Bool: BSONValue {
    typealias Encoded = Byte
    
    var type: Byte { CollectionOfOne(0x00) }
    
    func encode() throws -> Encoded {
        self ? CollectionOfOne(0x01) : CollectionOfOne(0x00)
    }
}

extension Int64: BSONValue {
    typealias Encoded = [UInt8]
    
    var type: Byte { CollectionOfOne(0x12) }
    
    func encode() throws -> Encoded {
        withUnsafeBytes(of: self) { bytes in
            Array(bytes)
        }
    }
}

extension UInt64: BSONValue {
    typealias Encoded = [UInt8]
    
    var type: Byte { CollectionOfOne(0x11) }
    
    func encode() throws -> Encoded {
        withUnsafeBytes(of: self) { bytes in
            Array(bytes)
        }
    }
}

extension Double: BSONValue {
    typealias Encoded = [UInt8]
    
    var type: Byte { CollectionOfOne(0x01) }
    
    func encode() throws -> Encoded {
        withUnsafeBytes(of: bitPattern) { bytes in
            Array(bytes)
        }
    }
}

extension Optional: BSONValue where Wrapped : BSONValue {
    enum Encoded: Sequence {
        case none
        case some(Wrapped.Encoded)
        
        struct Iterator: IteratorProtocol {
            /// The iterator for the encoded value, or `nil` if the value is `nil`.
            var encodedValueIterator: Wrapped.Encoded.Iterator?
            
            /// If the sequence is empty, unconditionally returns nil.
            /// Oterwise, returns the next element in `Encoded`.
            mutating func next() -> UInt8? {
                encodedValueIterator?.next()
            }
        }
        
        func makeIterator() -> Iterator {
            switch self {
            case .none:
                return Iterator(encodedValueIterator: nil)
            case .some(let encodedValue):
                return Iterator(encodedValueIterator: encodedValue.makeIterator())
            }
        }
    }
    
    var type: Byte { self?.type ?? CollectionOfOne(0x0A) }
    
    func encode() throws -> Encoded {
        switch self {
        case .none:
            return .none
        case .some(let value):
            return .some(try value.encode())
        }
    }
}
