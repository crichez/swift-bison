//
//  BSONDecoder.swift
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