//
//  ParsableValue.swift
//  ParsableValue
//
//  Created by Christopher Richez on March 4 2022
//

/// A value that can be parsed from its encoded BSON representation.
public protocol ParsableValue {
    /// The error type thrown when parsing this value fails.
    associatedtype Error: Swift.Error

    /// Initializes this value from the provided BSON bytes.
    /// 
    /// - Parameter data: the encoded value, usually returned by the `ParsedDocument` subscript
    /// 
    /// - Throws:
    /// An `Error` if the value couldn't be parsed.
    init<Data: Collection>(bsonBytes data: Data) throws where Data.Element == UInt8
}

extension Int32: ParsableValue {
    /// The error type thrown by `Int32.init(bsonBytes:)`.
    public enum Error: Swift.Error {
        /// The data passed to the initializer was not 4 bytes long.
        case sizeMismatch
    }
    
    /// Initializes a value from its BSON-encoded bytes.
    /// 
    /// - Parameter data: a collection of exactly 4 bytes that represent an `Int32`
    /// 
    /// - Throws: `Int32.Error.sizeMismatch` if `data` was not exactly 4 bytes.
    public init<Data: Collection>(bsonBytes data: Data) throws where Data.Element == UInt8 {
        guard data.count == 4 else { throw Error.sizeMismatch }
        let copyBuffer = UnsafeMutableRawBufferPointer.allocate(byteCount: 4, alignment: 4)
        copyBuffer.copyBytes(from: data)
        self = copyBuffer.load(as: Int32.self)
    }
}

extension Int64: ParsableValue {
    /// The error type thrown by `Int64.init(bsonBytes:)`.
    public enum Error: Swift.Error {
        /// The data passed to the initializer was not 8 bytes long.
        case sizeMismatch
    }

    /// Initializes a value from its BSON-encoded bytes.
    /// 
    /// - Parameter data: a collection of exactly 8 bytes that represent an `Int64`
    /// 
    /// - Throws: `Int64.Error.sizeMismatch` if `data` was not exactly 8 bytes.
    public init<Data: Collection>(bsonBytes data: Data) throws where Data.Element == UInt8 {
        guard data.count == 8 else { throw Error.sizeMismatch }
        let copyBuffer = UnsafeMutableRawBufferPointer.allocate(byteCount: 8, alignment: 8)
        copyBuffer.copyBytes(from: data)
        self = copyBuffer.load(as: Int64.self)
    }
}

extension UInt64: ParsableValue {
    /// The error type thrown by `UInt64.init(bsonBytes:)`.
    public enum Error: Swift.Error {
        /// The data passed to the initializer was not 8 bytes long.
        case sizeMismatch
    }
    
    /// Initializes a value fom its BSON-encoded bytes.
    /// 
    /// - Parameter data: a collection of exactly 8 bytes that represent an `UInt64`.
    /// 
    /// - Throws: `Int64.Error.sizeMismatch` if `data` was not exactly 8 bytes.
    public init<Data: Collection>(bsonBytes data: Data) throws where Data.Element == UInt8 {
        guard data.count == 8 else { throw Error.sizeMismatch }
        let copyBuffer = UnsafeMutableRawBufferPointer.allocate(byteCount: 8, alignment: 8)
        copyBuffer.copyBytes(from: data)
        self = copyBuffer.load(as: UInt64.self)
    }
}

extension Double: ParsableValue {
    /// The error type thrown by `Double.init(bsonBytes:)`.
    public enum Error: Swift.Error {
        /// The data passed to the initializer was not 8 bytes long.
        case sizeMismatch
    }
    
    /// Initializes a value from its BSON-encoded bytes.
    /// 
    /// - Parameter data: a collection of exactly 8 bytes that represent a `Double`.
    /// 
    /// - Throws: `Double.Error.sizeMismatch` if `data` was not exactly 8 bytes.
    public init<Data: Collection>(bsonBytes data: Data) throws where Data.Element == UInt8 {
        guard data.count == 8 else { throw Error.sizeMismatch }
        let copyBuffer = UnsafeMutableRawBufferPointer.allocate(byteCount: 8, alignment: 8)
        copyBuffer.copyBytes(from: data)
        self = copyBuffer.load(as: Double.self)
    }
}

extension Bool: ParsableValue {
    /// The error type thrown by `Bool.init(bsonBytes:)`.
    public enum Error: Swift.Error {
        /// The data passed to the initializer was not 1 byte long.
        case sizeMismatch
    }
    
    /// Initializes a value from its BSON-encoded bytes.
    /// 
    /// - Parameter data: a collection of exactly 1 byte that represents a `Bool`
    /// 
    /// - Throws: `Bool.Error.sizeMismatch` if `data` was not exactly 8 bytes.
    public init<Data: Collection>(bsonBytes data: Data) throws where Data.Element == UInt8 {
        guard data.count == 1 else { throw Error.sizeMismatch }
        self = data[data.startIndex] == 0 ? false : true
    }
}

extension String: ParsableValue {
    /// The error type thrown by `String.init(bsonBytes:)`.
    public enum Error: Swift.Error {
        /// Less than 5 bytes were provided to the initializer.
        case dataTooShort

        /// The declared size of the encoded string did not match the number of bytes passed
        /// to the initializer. For a size of `n`, the data passed to the initializer should 
        /// have a `count` of `n + 4`.
        case sizeMismatch
    }
    
    /// Initializes a value from its BSON-encoded bytes.
    /// 
    /// - Parameter data: a collection of 5 or more bytes that represent a BSON-encoded `String`
    /// 
    /// - Throws:
    /// `String.Error.dataTooShort` if less than 5 bytes were passed to the initializer.
    /// `String.Error.sizeMismatch` if the declared and actual size of the `String` did not match.
    public init<Data: Collection>(bsonBytes data: Data) throws where Data.Element == UInt8 {
        guard data.count > 4 else { throw Error.dataTooShort }
        let sizeStart = data.startIndex
        let sizeEnd = data.index(sizeStart, offsetBy: 4)
        // We try! here since we already ensured we have four bytes to read
        let size = Int(try! Int32(bsonBytes: data[sizeStart..<sizeEnd]))
        guard data.count == size + 4 else { throw Error.sizeMismatch }
        self.init(decoding: data[sizeEnd..<data.index(data.endIndex, offsetBy: -1)], as: UTF8.self)
    }
}