//
//  DocComponent.swift
//  DocComponent
//
//  Created by Christopher Richez on March 1 2022
//

/// A value that can be converted into a collection of BSON-encoded bytes.
/// 
/// BSON document components include `Pair`, `Group` and `ForEach`.
public protocol DocComponent {
    /// This value's BSON-encoded bytes.
    var bsonEncoded: [UInt8] { get }
}
