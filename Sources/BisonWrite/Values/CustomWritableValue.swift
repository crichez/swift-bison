//
//  CustomWritableValue.swift
//
//
//  Created by Christopher Richez on April 14 2022
//

import Foundation

/// A BSON value that declares the `binary` type (5).
/// 
/// Conform to `CustomWritableValue` instead of `WritableValue` for binary values.
/// Size and subtype metadata are generated for you, and you only need to return the value's
/// content data.
public protocol CustomWritableValue: WritableValue {
    /// The subtype byte to declare.
    var bsonSubtype: UInt8 { get }

    /// The bytes of the value itself, not including its size and subtype.
    var bsonValueBytes: Data { get }
}

extension CustomWritableValue {
    public var bsonType: UInt8 {
        5
    }

    public var bsonBytes: Data {
        let valueBytes = bsonValueBytes
        var bsonBytes = Int32(valueBytes.count).bsonBytes
        bsonBytes.append(bsonSubtype)
        bsonBytes.append(contentsOf: valueBytes)
        return bsonBytes
    }
}
