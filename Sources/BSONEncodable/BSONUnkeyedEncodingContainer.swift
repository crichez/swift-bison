//
//  BSONUnkeyedEncodingContainer.swift
//
//
//  Created by Christopher Richez on March 31 2022
//

import BSONCompose

class BSONUnkeyedEncodingContainer {
    /// The contents of this container.
    var contents: [ValueBox] = []

    /// The path the encoder took to this point.
    var codingPath: [CodingKey]

    /// Initialies a container with the provided coding path.
    init(codingPath: [CodingKey]) {
        self.codingPath = codingPath
    }
}

extension Array where Element == ValueBox {
    mutating func append<T: ValueProtocol>(_ value: T) {
        append(ValueBox(value))
    }
}

extension BSONUnkeyedEncodingContainer: ValueProtocol {
    var bsonBytes: [UInt8] {
        let contents = self.contents
        return ComposedDocument {
            ForEach(contents.enumerated()) { index, value in 
                String(describing: index) => value
            }
        }
        .bsonBytes
    }

    var bsonType: UInt8 {
        4
    }
}

extension BSONUnkeyedEncodingContainer: UnkeyedEncodingContainer {
    /// The number of elements in this container.
    var count: Int {
        contents.count
    }

    func encode(_ value: String) throws {
        contents.append(value)
    }

    func encode(_ value: Double) throws {
        contents.append(value)
    }

    func encode(_ value: Float) throws {
        contents.append(Double(value))
    }

    func encode(_ value: Int) throws {
        if MemoryLayout<Int>.size == 4 {
            contents.append(Int32(value))
        } else {
            contents.append(Int64(value))
        }
    }

    func encode(_ value: Int8) throws {
        contents.append(Int32(value))
    }

    func encode(_ value: Int16) throws {
        contents.append(Int32(value))
    }

    func encode(_ value: Int32) throws {
        contents.append(value)
    }

    func encode(_ value: Int64) throws {
        contents.append(value)
    }

    func encode(_ value: UInt) throws {
        contents.append(UInt64(value))
    }

    func encode(_ value: UInt8) throws {
        contents.append(UInt64(value))
    }

    func encode(_ value: UInt16) throws {
        contents.append(UInt64(value))
    }

    func encode(_ value: UInt32) throws {
        contents.append(UInt64(value))
    }

    func encode(_ value: UInt64) throws {
        contents.append(value)
    }

    func encode<T: Encodable>(_ value: T) throws {
        let encoder = BSONEncodingContainerProvider(codingPath: codingPath)
        try value.encode(to: encoder)
        contents.append(encoder)
    }

    func encode(_ value: Bool) throws {
        contents.append(value)
    }

    func encodeNil() throws {
        contents.append(Bool?.none)
    }

    func nestedContainer<NestedKey: CodingKey>(
        keyedBy keyType: NestedKey.Type
    ) -> KeyedEncodingContainer<NestedKey> {
        let nestedContainer = BSONKeyedEncodingContainer<NestedKey>(codingPath: codingPath)
        contents.append(nestedContainer)
        return KeyedEncodingContainer(nestedContainer)
    }

    func nestedUnkeyedContainer() -> UnkeyedEncodingContainer {
        let nestedContainer = BSONUnkeyedEncodingContainer(codingPath: codingPath)
        contents.append(nestedContainer)
        return nestedContainer
    }

    func superEncoder() -> Encoder {
        let superEncoder = BSONEncodingContainerProvider(codingPath: codingPath)
        contents.append(superEncoder)
        return superEncoder
    }
}