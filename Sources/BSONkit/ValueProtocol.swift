//
//  ValueProtocol.swift
//  
//
//  Created by Christopher Richez on 2/6/22.
//

/// A value that can be encoded into a BSON document.
protocol ValueProtocol: BinaryConvertible {
    /// The BSON type byte to attach to the key associated with this value.
    var type: CollectionOfOne<UInt8> { get }
}

extension Int32: ValueProtocol {
    typealias Encoded = [UInt8]
    
    func encode() throws -> Encoded {
        withUnsafeBytes(of: self) { bytes in
            Array(bytes)
        }
    }

    var type: CollectionOfOne<UInt8> { CollectionOfOne(0x10) }
}

extension String: ValueProtocol {
    typealias Encoded = Chain3<Int32.Encoded, String.UTF8View, CollectionOfOne<UInt8>>
    
    func encode() throws -> Encoded {
        let content = utf8
        let terminator = CollectionOfOne<UInt8>(0x00)
        guard let size = Int32(exactly: content.count + 1) else {
            fatalError("string too long")
        }
        let encodedValue = Chain3(try size.encode(), content, terminator)
        return encodedValue
    }

    var type: CollectionOfOne<UInt8> { CollectionOfOne(0x02) }
}

extension Bool: ValueProtocol {
    typealias Encoded = CollectionOfOne<UInt8>
    
    func encode() throws -> Encoded {
        self ? CollectionOfOne(0x01) : CollectionOfOne(0x00)
    }
    
    var type: CollectionOfOne<UInt8> { CollectionOfOne(0x00) }
}

extension Int64: ValueProtocol {
    typealias Encoded = [UInt8]
    
    func encode() throws -> Encoded {
        withUnsafeBytes(of: self) { bytes in
            Array(bytes)
        }
    }
    
    var type: CollectionOfOne<UInt8> { CollectionOfOne(0x12) }
}

extension UInt64: ValueProtocol {
    typealias Encoded = [UInt8]
    
    func encode() throws -> Encoded {
        withUnsafeBytes(of: self) { bytes in
            Array(bytes)
        }
    }
    
    var type: CollectionOfOne<UInt8> { CollectionOfOne(0x11) }
}

extension Double: ValueProtocol {
    typealias Encoded = [UInt8]
    
    func encode() throws -> Encoded {
        withUnsafeBytes(of: bitPattern) { bytes in
            Array(bytes)
        }
    }
    
    var type: CollectionOfOne<UInt8> { CollectionOfOne(0x01) }
}

extension Optional: BinaryConvertible, ValueProtocol where Wrapped : ValueProtocol {
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
    
    func encode() throws -> Encoded {
        switch self {
        case .none:
            return .none
        case .some(let value):
            return .some(try value.encode())
        }
    }
    
    var type: CollectionOfOne<UInt8> { self?.type ?? CollectionOfOne(0x0A) }
}
