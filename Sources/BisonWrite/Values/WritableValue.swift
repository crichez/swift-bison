//
//  WritableValue.swift
//
//
//  Created by Christopher Richez on 2/6/22.
//

/// A value that can be assigned to a ``Pair`` in a BSON document.
public protocol WritableValue {
    /// The BSON type byte for this type.
    /// 
    /// This is the number that will be prefixed to keys that declare this value type.
    var bsonType: UInt8 { get }
    
    /// Appends this value to the end of a BSON document.
    /// 
    /// In most cases, implementations should only call `append(contentsOf:)`
    /// on the document and pass in the BSON representation of their value.
    /// 
    /// - Parameter document: a BSON document to which this value should be appended
    func append<Doc>(to document: inout Doc)
    where Doc : RangeReplaceableCollection, Doc.Element == UInt8
}

extension Int32: WritableValue {
    public func append<Doc>(to document: inout Doc)
    where Doc : RangeReplaceableCollection, Doc.Element == UInt8 {
        withUnsafeBytes(of: self) { bytes in
            document.append(contentsOf: bytes)
        }
    }

    public var bsonType: UInt8 {
        0x10
    }
}

extension String: WritableValue {
    public func append<Doc>(to document: inout Doc)
    where Doc : RangeReplaceableCollection, Doc.Element == UInt8 {
        let utf8 = utf8
        let longSize = utf8.count + 1
        guard let size = Int32(exactly: longSize) else { fatalError("string too long") }
        document.reserveCapacity(longSize + 4)
        size.append(to: &document)
        document.append(contentsOf: utf8)
        document.append(0)
    }

    public var bsonType: UInt8 {
        0x02
    }
}

extension Bool: WritableValue {
    public func append<Doc>(to document: inout Doc) 
    where Doc : RangeReplaceableCollection, Doc.Element == UInt8 {
        self ? document.append(1) : document.append(0)
    }
    
    public var bsonType: UInt8 {
        0x08
    }
}

extension Int64: WritableValue {
    public func append<Doc>(to document: inout Doc) 
    where Doc : RangeReplaceableCollection, Doc.Element == UInt8 {
        withUnsafeBytes(of: self) { bytes in
            document.append(contentsOf: bytes)
        }
    }
    
    public var bsonType: UInt8 {
        0x12
    }
}

extension UInt64: WritableValue {
    public func append<Doc>(to document: inout Doc) 
    where Doc : RangeReplaceableCollection, Doc.Element == UInt8 {
        withUnsafeBytes(of: self) { bytes in
            document.append(contentsOf: bytes)
        }
    }
    
    public var bsonType: UInt8 {
        0x11
    }
}

extension Double: WritableValue {
    public func append<Doc>(to document: inout Doc) 
    where Doc : RangeReplaceableCollection, Doc.Element == UInt8 {
        withUnsafeBytes(of: bitPattern) { bytes in
            document.append(contentsOf: bytes)
        }
    }
    
    public var bsonType: UInt8 {
        0x01
    }
}

extension Optional: WritableValue where Wrapped : WritableValue {
    public func append<Doc>(to document: inout Doc) 
    where Doc : RangeReplaceableCollection, Doc.Element == UInt8 {
        switch self {
        case .some(let value):
            value.append(to: &document)
        case .none:
            return
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
