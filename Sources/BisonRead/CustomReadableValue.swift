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

/// A protocol that defines how a custom value is read from a document.
///
/// ## Conforming to CustomReadableValue
/// 
/// Conform to this protocol to decode a custom value from its raw BSON representation. The value's
/// raw bytes are passed to the ``init(bsonValueBytes:)`` initializer as a generic `Collection`.
/// The following example is the actual `UUID` conformance.
/// 
/// ```swift
/// extension UUID: CustomReadableValue {
///     public init<Data: Collection>(bsonValueBytes: Data) throws where Data.Element == UInt8 {
///         guard bsonValueBytes.count == 16 else {    
///             throw BisonError.sizeMismatch(16, bsonValueBytes.count)
///         }
///         let copyBuffer = UnsafeMutableRawBufferPointer.allocate(capacity: 16, alignment: 16)
///         copyBuffer.copyBytes(from: bsonValueBytes)
///         self = copyBuffer.load(as: UUID.self)
///     }
/// }
/// ```
/// 
/// > Note: BSON "binary" types include size and type metadata. These are usually parsed for you,
///   so the data in `bsonValueBytes` is always the declared size. This may not be the size
///   you expect due to encoding errors, so you should always check.
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
            throw ValueError.sizeMismatch(expected: declaredSize + 5, have: data.count)
        }
        try self.init(bsonValueBytes: data.dropFirst(5))
    }
}
