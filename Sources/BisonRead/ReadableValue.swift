//
//  ReadableValue.swift
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

/// A protocol that defines how a BSON value is read from a document.
/// 
/// ## Conforming to ReadableValue
/// 
/// ``BisonWrite`` supports external types in two cases:
/// 1. **Custom types** that do not exist in the specification.
/// 2. **Alternatives** to specification types built into the framework.
/// 
/// ### Custom Types
/// 
/// To decode a type that does not exist in the specification, ``CustomReadableValue`` provides
/// default implementations that make conforming to ``ReadableValue`` much simpler. In most cases,
/// That is the recommended protocol to conform to. 
/// 
/// ### Alternative Types
/// 
/// To decode an alternative version of a specification type, conform to this protocol directly.
/// You only need to provide a way to initialize a value from its encoded BSON bytes. These are
/// provided to you as a `Collection` in the ``init(bsonBytes:)`` method. The following example
/// copies the data for a `Double` into a raw buffer and loads it using Swift's manual memory
/// management APIs.
/// 
/// ```swift
/// extension Double: ReadableValue {
///     public init<Data: Collection>(bsonBytes data: Data) throws where Data.Element == UInt8 {
///         guard data.count == 8 else { throw ValueError.sizeMismatch(8, data.count) }
///         let copyBuffer = UnsafeMutableRawBufferPointer.allocate(byteCount: 8, alignment: 8)
///         copyBuffer.copyBytes(from: data)
///         self = copyBuffer.load(as: Double.self)
///     }
/// } 
/// ```
public protocol ReadableValue {
    /// Initializes this value from its encoded BSON representation.
    /// 
    /// - Parameter data: a collection of bytes containing the value's encoded BSON representation
    /// 
    /// - Throws:
    /// A `ValueError` appropriate for the type to initialize.
    init<Data: Collection>(bsonBytes data: Data) throws where Data.Element == UInt8
}

extension Int32: ReadableValue {
    public init<Data: Collection>(bsonBytes data: Data) throws where Data.Element == UInt8 {
        guard data.count == 4 else { throw ValueError.sizeMismatch(expected: 4, have: data.count) }
        let copyBuffer = UnsafeMutableRawBufferPointer.allocate(byteCount: 4, alignment: 4)
        copyBuffer.copyBytes(from: data)
        self = copyBuffer.load(as: Int32.self)
    }
}

extension Int64: ReadableValue {
    public init<Data: Collection>(bsonBytes data: Data) throws where Data.Element == UInt8 {
        guard data.count == 8 else { throw ValueError.sizeMismatch(expected: 8, have: data.count) }
        let copyBuffer = UnsafeMutableRawBufferPointer.allocate(byteCount: 8, alignment: 8)
        copyBuffer.copyBytes(from: data)
        self = copyBuffer.load(as: Int64.self)
    }
}

extension UInt64: ReadableValue {
    public init<Data: Collection>(bsonBytes data: Data) throws where Data.Element == UInt8 {
        guard data.count == 8 else { throw ValueError.sizeMismatch(expected: 8, have: data.count) }
        let copyBuffer = UnsafeMutableRawBufferPointer.allocate(byteCount: 8, alignment: 8)
        copyBuffer.copyBytes(from: data)
        self = copyBuffer.load(as: UInt64.self)
    }
}

extension Double: ReadableValue {
    public init<Data: Collection>(bsonBytes data: Data) throws where Data.Element == UInt8 {
        guard data.count == 8 else { throw ValueError.sizeMismatch(expected: 8, have: data.count) }
        let copyBuffer = UnsafeMutableRawBufferPointer.allocate(byteCount: 8, alignment: 8)
        copyBuffer.copyBytes(from: data)
        self = copyBuffer.load(as: Double.self)
    }
}

extension Bool: ReadableValue {
    public init<Data: Collection>(bsonBytes data: Data) throws where Data.Element == UInt8 {
        guard data.count == 1 else { 
            throw ValueError.sizeMismatch(expected: 1, have: data.count) 
        }
        self = data[data.startIndex] == 0 ? false : true
    }
}

extension String: ReadableValue {
    public init<Data: Collection>(bsonBytes data: Data) throws where Data.Element == UInt8 {
        guard data.count > 4 else { 
            throw ValueError.dataTooShort(needAtLeast: 5, found: data.count) 
        }
        let sizeStart = data.startIndex
        let sizeEnd = data.index(sizeStart, offsetBy: 4)
        // We try! here since we already ensured we have four bytes to read
        let size = Int(try! Int32(bsonBytes: data[sizeStart..<sizeEnd]))
        guard data.count == size + 4 else { 
            throw ValueError.sizeMismatch(expected: size + 4, have: data.count) 
        }
        self.init(decoding: data[sizeEnd..<data.index(data.endIndex, offsetBy: -1)], as: UTF8.self)
    }
}
