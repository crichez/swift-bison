//
//  ValueProtocol.swift
//  
//
//  Created by Christopher Richez on 2/6/22.
//

/// A value that can be encoded into a BSON document.
public protocol ValueProtocol {
    /// The type of the encoded representation for this value.
    associatedtype Encoded: Collection where Encoded.Element == UInt8

    /// The BSON type byte to attach to the key associated with this value.
    var type: CollectionOfOne<UInt8> { get }

    var bsonEncoded: Encoded { get }
}

extension Int32: ValueProtocol {
    public typealias Encoded = [UInt8]
    
    public var bsonEncoded: Encoded {
        withUnsafeBytes(of: self) { bytes in
            Array(bytes)
        }
    }

    public var type: CollectionOfOne<UInt8> { CollectionOfOne(0x10) }
}

extension String: ValueProtocol {
    public typealias Encoded = Chain3<Int32.Encoded, String.UTF8View, CollectionOfOne<UInt8>>
    
    public var bsonEncoded: Encoded {
        let content = utf8
        let terminator = CollectionOfOne<UInt8>(0x00)
        guard let size = Int32(exactly: content.count + 1) else {
            fatalError("string too long")
        }
        let encodedValue = Chain3(s0: size.bsonEncoded, s1: content, s2: terminator)
        return encodedValue
    }

    public var type: CollectionOfOne<UInt8> { CollectionOfOne(0x02) }
}

extension Bool: ValueProtocol {
    public typealias Encoded = CollectionOfOne<UInt8>
    
    public var bsonEncoded: Encoded {
        self ? CollectionOfOne(0x01) : CollectionOfOne(0x00)
    }
    
    public var type: CollectionOfOne<UInt8> { CollectionOfOne(0x00) }
}

extension Int64: ValueProtocol {
    public typealias Encoded = [UInt8]
    
    public var bsonEncoded: Encoded {
        withUnsafeBytes(of: self) { bytes in
            Array(bytes)
        }
    }
    
    public var type: CollectionOfOne<UInt8> { CollectionOfOne(0x12) }
}

extension UInt64: ValueProtocol {
    public typealias Encoded = [UInt8]
    
    public var bsonEncoded: Encoded {
        withUnsafeBytes(of: self) { bytes in
            Array(bytes)
        }
    }
    
    public var type: CollectionOfOne<UInt8> { CollectionOfOne(0x11) }
}

extension Double: ValueProtocol {
    public typealias Encoded = [UInt8]
    
    public var bsonEncoded: Encoded {
        withUnsafeBytes(of: bitPattern) { bytes in
            Array(bytes)
        }
    }
    
    public var type: CollectionOfOne<UInt8> { CollectionOfOne(0x01) }
}

extension Optional: DocComponent, ValueProtocol where Wrapped : ValueProtocol {
    public enum Encoded: Sequence {
        case none
        case some(Wrapped.Encoded)
        
        public struct Iterator: IteratorProtocol {
            /// The iterator for the encoded value, or `nil` if the value is `nil`.
            var encodedValueIterator: Wrapped.Encoded.Iterator?
            
            /// If the sequence is empty, unconditionally returns nil.
            /// Oterwise, returns the next element in `Encoded`.
            public mutating func next() -> UInt8? {
                encodedValueIterator?.next()
            }
        }
        
        public func makeIterator() -> Iterator {
            switch self {
            case .none:
                return Iterator(encodedValueIterator: nil)
            case .some(let encodedValue):
                return Iterator(encodedValueIterator: encodedValue.makeIterator())
            }
        }
    }
    
    public var bsonEncoded: Encoded {
        switch self {
        case .none:
            return .none
        case .some(let value):
            return .some(value.bsonEncoded)
        }
    }
    
    public var type: CollectionOfOne<UInt8> { self?.type ?? CollectionOfOne(0x0A) }
}

extension Optional.Encoded: Collection where Wrapped.Encoded : Collection {
    public enum Index: Comparable {
        case none, some(Wrapped.Encoded.Index)

        public static func < (lhs: Self, rhs: Self) -> Bool {
            switch (lhs, rhs) {
            case (.none, .none):
                return false
            case (.none, .some(_)):
                return true
            case (.some(_), .none):
                return false
            case (.some(let lhs), .some(let rhs)):
                return lhs < rhs
            }
        }
    }

    public func index(after i: Index) -> Index {
        switch i {
        case .none:
            return .none
        case .some(let i):
            switch self {
            case .none:
                return .none
            case .some(let encoded):
                return .some(encoded.index(after: i))
            }
        }
    }

    public var count: Int {
        switch self {
        case .none:
            return 0
        case .some(let encoded):
            return encoded.count
        }
    }

    public var startIndex: Index {
        switch self {
        case .none:
            return .none
        case .some(let encoded):
            return .some(encoded.startIndex)
        }
    }

    public var endIndex: Index {
        switch self {
        case .none:
            return .none
        case .some(let encoded):
            return .some(encoded.endIndex)
        }
    }

    public subscript(position: Index) -> UInt8 {
        switch position {
        case .none:
            fatalError("requested the position of a nil index")
        case .some(let position):
            switch self {
            case .none:
                fatalError("encoded optional index out of range")
            case .some(let encoded):
                return encoded[position]
            }
        }
    }
}
