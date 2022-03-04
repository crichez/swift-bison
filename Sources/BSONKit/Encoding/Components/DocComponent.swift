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
    /// The collection of BSON-encoded bytes returned by the `bsonBytes` property.
    /// 
    /// `Encoded` must conform to `Collection`, since the size of the component must be known
    /// to calculate the final size of the parent document.
    associatedtype Encoded: Collection where Encoded.Element == UInt8
    
    /// This value's BSON-encoded bytes.
    var bsonEncoded: Encoded { get }
}
