//
//  BSONSingleValueEncodingContainer.swift
//
//
//  Created by Christopher Richez on March 28 2022
//

import BSONCompose

struct BSONSingleValueEncodingContainer {
    /// The value assigned to this container.
    var encodedValue: [UInt8]? = nil

    /// The type byte declared by the value assigned to this container.
    var encodedType: UInt8? = nil

    /// The path the encoder took to get to this point, used for error composition.
    var codingPath: [CodingKey]
}

extension BSONSingleValueEncodingContainer: ValueProtocol {
    var bsonBytes: [UInt8] {
        encodedValue!
    }

    var bsonType: UInt8 {
        encodedType!
    }
}

extension BSONSingleValueEncodingContainer: SingleValueEncodingContainer {
    mutating func encodeNil() throws {
        encodedValue = []
        encodedType = 10
    }

    mutating func encode(_ value: Bool) throws {
        encodedValue = value.bsonBytes
        encodedType = value.bsonType
    }

    mutating func encode(_ value: String) throws {
        encodedValue = value.bsonBytes
        encodedType = value.bsonType
    }

    mutating func encode(_ value: Double) throws {
        encodedValue = value.bsonBytes
        encodedType = value.bsonType
    }

    mutating func encode(_ value: Int32) throws {
        encodedValue = value.bsonBytes
        encodedType = value.bsonType
    }

    mutating func encode(_ value: UInt64) throws {
        encodedValue = value.bsonBytes
        encodedType = value.bsonType
    }

    mutating func encode(_ value: Int64) throws {
        encodedValue = value.bsonBytes
        encodedType = value.bsonType
    }

    mutating func encode(_ value: Float) throws {
        let convertedValue = Double(value)
        encodedValue = convertedValue.bsonBytes
        encodedType = convertedValue.bsonType
    }

    mutating func encode(_ value: Int) throws {
        if MemoryLayout<Int>.size == 4 {
            let convertedValue = Int32(value)
            encodedValue = convertedValue.bsonBytes
            encodedType = convertedValue.bsonType
        } else {
            let convertedValue = Int64(value)
            encodedValue = convertedValue.bsonBytes
            encodedType = convertedValue.bsonType
        }
        
    }

    mutating func encode(_ value: Int8) throws {
        let convertedValue = Int32(value)
        encodedValue = convertedValue.bsonBytes
        encodedType = convertedValue.bsonType
    }

    mutating func encode(_ value: Int16) throws {
        let convertedValue = Int32(value)
        encodedValue = convertedValue.bsonBytes
        encodedType = convertedValue.bsonType
    }

    mutating func encode(_ value: UInt) throws {
        let convertedValue = UInt64(value)
        encodedValue = convertedValue.bsonBytes
        encodedType = convertedValue.bsonType
    }

    mutating func encode(_ value: UInt8) throws {
        let convertedValue = UInt64(value)
        encodedValue = convertedValue.bsonBytes
        encodedType = convertedValue.bsonType
    }

    mutating func encode(_ value: UInt16) throws {
        let convertedValue = UInt64(value)
        encodedValue = convertedValue.bsonBytes
        encodedType = convertedValue.bsonType
    }

    mutating func encode(_ value: UInt32) throws {
        let convertedValue = UInt64(value)
        encodedValue = convertedValue.bsonBytes
        encodedType = convertedValue.bsonType
    }

    mutating func encode<T>(_ value: T) throws where T : Encodable {
        fatalError("not implemented")
    }
}