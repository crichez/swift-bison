//
//  BSONEncoder.swift
//
//
//  Created by Christopher Richez on March 31 2022
//

import Foundation

/// Use `BSONEncoder` to write `Encodable` values into fully-formed BSON documents.
/// 
/// `BSONEncoder` is generic over its encoded document type: `Doc`.
/// The only constraint on this type is it must be a `RangeReplaceableCollection` with an
/// element type of `UInt8`. In most cases, you can simply initialize your encoder over
/// over the `Data` type as follows.
/// 
///     import Foundation
///     import BisonEncode
///     
///     let encoder = BSONEncoder<Data>()
///     let document = try encoder.encode(myEncodableInstance)
///     try document.write(to: file)
/// 
public struct BSONEncoder<Doc: RangeReplaceableCollection> where Doc.Element == UInt8 {
    /// Initializes an encoder.
    public init() {}

    /// Encodes the provided value into a BSON document.
    /// 
    /// - Throws: 
    /// Re-throws any errors thrown in the value's `encode(to:)` method.
    /// For built-in types, no errors are thrown.
    /// 
    /// - Parameter value: an `Encodable` value
    /// 
    /// - Returns: 
    /// The bytes of the resulting BSON document as the `Doc` collection type.
    public func encode<T: Encodable>(_ value: T) throws -> Doc {
        let containerProvider = BSONEncodingContainerProvider(codingPath: [])
        try value.encode(to: containerProvider)
        var buffer = Doc()
        containerProvider.append(to: &buffer)
        return buffer
    }
}