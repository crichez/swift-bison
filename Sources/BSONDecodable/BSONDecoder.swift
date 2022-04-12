//
//  BSONDecoder.swift
//
//
//  Created by Christopher Richez on April 11 2022
//

/// A type that decodes `Decodable` types from BSON documents.
public struct BSONDecoder {
    /// Decodes the specified type from the provided BSON document.
    /// 
    /// - Parameters:
    ///   - type: the type to decode
    ///   - data: the value encoded as a BSON document
    /// 
    /// - Throws:
    /// An appropriate `DecodingError` for the situation.
    /// 
    /// - Returns:
    /// The decoded instance of the specified type.
    public func decode<T: Decodable, Data: Collection>(_ type: T.Type, from data: Data) throws -> T
    where Data.Element == UInt8 {
        let decoder = DecodingContainerProvider(encodedValue: data)
        return try T(from: decoder)
    }

    /// Initializes a decoder.
    public init() {}
}