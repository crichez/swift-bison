//
//  BSONEncoder.swift
//
//
//  Created by Christopher Richez on March 31 2022
//

import Foundation

/// Use `BSONEncoder` to encode `Encodable` values into fully-formed BSON documents.
/// 
/// - Note: 
/// This encoder does not respect custom `WritableValue` implementations.
/// To encode custom BSON values differently than their `Encodable` implementation,
/// Use `WritableDoc` or `WritableArray`.
public struct BSONEncoder {
    /// Initializes an encoder.
    public init() {}

    /// Encodes the provided value into a BSON document.
    /// 
    /// - Note: 
    /// This encoder does not respect custom ``WritableValue`` implementations.
    /// To encode custom BSON values differently than their `Encodable` implementation,
    /// Use ``WritableDoc`` or ``WritableArray``.
    /// 
    /// - Throws: 
    /// Re-throws any errors thrown in the value's `encode(to:)` method.
    /// 
    /// - Parameter value: an `Encodable` value
    /// 
    /// - Returns: 
    /// The bytes of the resulting BSON document.
    public func encode<T: Encodable>(_ value: T) throws -> Data {
        let containerProvider = BSONEncodingContainerProvider(codingPath: [])
        try value.encode(to: containerProvider)
        return containerProvider.bsonBytes
    }
}