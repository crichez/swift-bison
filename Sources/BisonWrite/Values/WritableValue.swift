//
//  WritableValue.swift
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

/// A protocol that defines how a BSON value is written to a document.
/// 
/// ## Conforming to `WritableValue`
/// 
/// The framework can be extended to support alternative versions of built-in BSON types,
/// or custom types. 
/// 
/// ### Custom Non-Specification Types
/// 
/// The specification supports encoding custom user-defined types as "binary" types. 
/// ``BisonWrite`` provides a convenience protocol for this use case called
/// ``CustomWritableValue``. In most cases, conforming through that protocol is recommended.
/// 
/// ### Replacements to Specification Types
/// 
/// If you prefer to use your own type instead of a built-in one for a specification type,
/// you should conform that type to this protocol. A good example would be using a custom date 
/// type as an alternative to `Foundation.Date`. 
/// 
/// BSON values must declare a type byte (or type number) to inform decoder implementations of the
/// value assigned to each key. You can find the byte to declare for your type in 
/// [the specification](https://bsonspec.org/spec.html), then declare it using the ``bsonType``
/// property.
/// 
/// ```swift
/// extension Double: ValueProtocol {
///     public var bsonType: UInt8 { 1 }
///     ...
/// }
/// ```
///
/// The ``append(to:)`` method appends the value's data to the document. The document conforms
/// to `RangeReplaceableCollection` and can generally be thought of as an `Array` or `Data` buffer.
/// 
/// ```swift
/// extension Double: ValueProtocol {
///     ...
///     public func append<Doc>(to document: inout Doc)
///     where Doc : RangeReplaceableCollection, Doc.Element == UInt8 {
///         withUnsafeBytes(of: self.bitPattern) { bytes in 
///             document.append(contentsOf: bytes)
///         }    
///     }
/// }
/// ```
/// 
/// > Tip: The `Index` type of the document is unconstrained, which can make mutations other
///   than `append(_:)` and `append(contentsOf:)` more challenging. You can calculate indices
///   using `Collection` methods and replace entire ranges using the document's
///   `replaceSubrange(_:with:)` method.
/// 
public protocol WritableValue {
    /// The type byte to assign to keys that declare this value.
    /// 
    /// Type bytes are defined in [the BSON specification](https://bsonspec.org/spec.html).
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
