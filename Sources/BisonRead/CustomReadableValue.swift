//
//  CustomReadableValue.swift
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

/// A BSON value whose encoded form declares the BSON binary type (5).
///
/// Conform to `CustomReadableValue` for BSON binary values to inherit metadata parsing.
public protocol CustomReadableValue: ReadableValue {
    /// Initializes a value from the provided BSON data.
    ///
    /// - Parameter bsonValueBytes: the value's encoded bytes, not including size and subtype bytes
    ///
    /// - Throws: The appropriate ``ValueError``.
    init<Data: Collection>(bsonValueBytes: Data) throws where Data.Element == UInt8
}

extension CustomReadableValue {
    public init<Data: Collection>(bsonBytes data: Data) throws where Data.Element == UInt8 {
        guard data.count >= 5 else { 
            throw ValueError.dataTooShort(needAtLeast: 5, found: data.count) 
        }
        let declaredSize = Int(truncatingIfNeeded: try Int32(bsonBytes: data.prefix(4)))
        guard data.count == declaredSize + 5 else {
            throw ValueError.sizeMismatch(declaredSize + 5, data.count)
        }
        try self.init(bsonValueBytes: data.dropFirst(5))
    }
}
