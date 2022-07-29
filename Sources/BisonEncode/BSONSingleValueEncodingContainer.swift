//
//  BSONSingleValueEncodingContainer.swift
//
//
//  Created by Christopher Richez on March 28 2022
//

import BisonWrite

class BSONSingleValueEncodingContainer {
    /// The value assigned to this container.
    var value: WritableValue? = nil

    /// The path the encoder took to get to this point, used for error composition.
    var codingPath: [CodingKey]

    /// Initializes a single value container with the provided coding path.
    init(codingPath: [CodingKey]) {
        self.codingPath = codingPath
    }
}

extension BSONSingleValueEncodingContainer: WritableValue {
    func append<Doc>(to document: inout Doc)
    where Doc : RangeReplaceableCollection, Doc.Element == UInt8 {
        value!.append(to: &document)
    }

    var bsonType: UInt8 {
        value!.bsonType
    }
}

extension BSONSingleValueEncodingContainer: SingleValueEncodingContainer {
    func encodeNil() throws {
        value = Optional<Bool>.none as WritableValue
    }

    func encode(_ value: Bool) throws {
        self.value = value
    }

    func encode(_ value: String) throws {
        self.value = value
    }

    func encode(_ value: Double) throws {
        self.value = value
    }

    func encode(_ value: Int32) throws {
        self.value = value
    }

    func encode(_ value: UInt64) throws {
        self.value = value
    }

    func encode(_ value: Int64) throws {
        self.value = value
    }

    func encode(_ value: Float) throws {
        self.value = Double(value)
    }

    func encode(_ value: Int) throws {
        if MemoryLayout<Int>.size == 4 {
            self.value = Int32(value)
        } else {
            self.value = Int64(value)
        }
        
    }

    func encode(_ value: Int8) throws {
        self.value = Int32(value)
    }

    func encode(_ value: Int16) throws {
        self.value = Int32(value)
    }

    func encode(_ value: UInt) throws {
        self.value = UInt64(value)
    }

    func encode(_ value: UInt8) throws {
        self.value = UInt64(value)
    }

    func encode(_ value: UInt16) throws {
        self.value = UInt64(value)
    }

    func encode(_ value: UInt32) throws {
        self.value = UInt64(value)
    }

    func encode<T>(_ value: T) throws where T : Encodable {
        if let bsonValue = value as? WritableValue {
            self.value = bsonValue
        } else {
            let encoder = BSONEncodingContainerProvider(codingPath: codingPath)
            try value.encode(to: encoder)
            self.value = encoder
        }
    }
}