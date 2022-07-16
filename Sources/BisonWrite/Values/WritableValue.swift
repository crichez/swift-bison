//
//  WritableValue.swift
//  
//
//  Created by Christopher Richez on 2/6/22.
//

import Foundation

/// A value that can be assigned to a ``Pair`` in a BSON document.
public protocol WritableValue {
    /// The BSON type byte for this type.
    var bsonType: UInt8 { get }
    
    /// This value's BSON-encoded bytes.
    var bsonBytes: Data { get }
}

extension Int32: WritableValue {
    public var bsonBytes: Data {
        withUnsafeBytes(of: self) { bytes in
            Data(bytes)
        }
    }

    public var bsonType: UInt8 {
        0x10
    }
}

extension String: WritableValue {
    public var bsonBytes: Data {
        let content = Data(utf8) + [0]
        guard let size = Int32(exactly: content.count)?.bsonBytes else {
            fatalError("string too long")
        }
        return size + content
    }

    public var bsonType: UInt8 {
        0x02
    }
}

extension Bool: WritableValue {
    public var bsonBytes: Data {
        self ? Data([1]) : Data([0])
    }
    
    public var bsonType: UInt8 {
        0x08
    }
}

extension Int64: WritableValue {
    public var bsonBytes: Data {
        withUnsafeBytes(of: self) { bytes in
            Data(bytes)
        }
    }
    
    public var bsonType: UInt8 {
        0x12
    }
}

extension UInt64: WritableValue {
    public var bsonBytes: Data {
        withUnsafeBytes(of: self) { bytes in
            Data(bytes)
        }
    }
    
    public var bsonType: UInt8 {
        0x11
    }
}

extension Double: WritableValue {
    public var bsonBytes: Data {
        withUnsafeBytes(of: bitPattern) { bytes in
            Data(bytes)
        }
    }
    
    public var bsonType: UInt8 {
        0x01
    }
}

extension Optional: WritableValue where Wrapped : WritableValue {
    public var bsonBytes: Data {
        switch self {
        case .some(let value):
            return value.bsonBytes
        case .none:
            return Data()
        }
    }

    public var bsonType: UInt8 {
        switch self {
        case .some(let value):
            return value.bsonType
        case .none:
            return 0x0A
        }
    }
}
