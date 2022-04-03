//
//  BSONEncoder.swift
//
//
//  Created by Christopher Richez on March 31 2022
//

/// Use `BSONEncoder` to encode `Encodable` values into fully-formed BSON documents.
/// 
/// - Note: 
/// This encoder does not respect custom `ValueProtocol` implementations.
/// To encode custom BSON values differently than their `Encodable` implementation,
/// Use `ComposedDocument` or `ComposedArrayDocument`.
public struct BSONEncoder {
    /// Initializes an encoder.
    public init() {}

    /// Encodes the provided value into a BSON document.
    /// 
    /// - Note: 
    /// This encoder does not respect custom ``ValueProtocol`` implementations.
    /// To encode custom BSON values differently than their `Encodable` implementation,
    /// Use ``ComposedDocument`` or ``ComposedArrayDocument``.
    /// 
    /// - Throws: 
    /// Re-throws any errors thrown in the value's `encode(to:)` method.
    /// 
    /// - Parameter value: an `Encodable` value
    /// 
    /// - Returns: 
    /// The bytes of the resulting BSON document.
    public func encode<T: Encodable>(_ value: T) throws -> [UInt8] {
        let containerProvider = BSONEncodingContainerProvider(codingPath: [])
        try value.encode(to: containerProvider)
        return containerProvider.bsonBytes
    }
}