//
//  BSONKeyedEncodingContainer.swift
//  BSONKeyedEncodingContainer
//
//  Created by Christopher Richez on March 31 2022
//

import BSONCompose

class BSONKeyedEncodingContainer<Key: CodingKey> {
    /// The contents of this container.
    var contents: [(String, ValueBox)] = []
    
    /// The path the encoder took to this point.
    var codingPath: [CodingKey]

    /// Initializes a container with the provided coding path record.
    init(codingPath: [CodingKey]) {
        self.codingPath = codingPath
    }
}

extension BSONKeyedEncodingContainer: ValueProtocol {
    var bsonBytes: [UInt8] {
        let contents = self.contents
        return ComposedDocument {
            ForEach(contents) { key, value in 
                key => value
            }
        }
        .bsonBytes
    }

    var bsonType: UInt8 {
        3
    }
}

extension Array where Element == (String, ValueBox) {
    /// Appends the provided key-value pair to the container's storage.
    fileprivate mutating func append<T: ValueProtocol, K: CodingKey>(_ key: K, _ value: T) {
        self.append((key.stringValue, ValueBox(value)))
    }
}

extension BSONKeyedEncodingContainer: KeyedEncodingContainerProtocol {
    func encodeNil(forKey key: Key) throws {
        contents.append(key, Int32?.none)
        codingPath.append(key)
    }

    func encode(_ value: Bool, forKey key: Key) throws {
        contents.append(key, value)
        codingPath.append(key)
    }

    func encode(_ value: String, forKey key: Key) throws {
        contents.append(key, value)
        codingPath.append(key)
    }

    func encode(_ value: Double, forKey key: Key) throws {
        contents.append(key, value)
        codingPath.append(key)
    }

    func encode(_ value: Float, forKey key: Key) throws {
        contents.append(key, Double(value))
        codingPath.append(key)
    }

    func encode(_ value: Int, forKey key: Key) throws {
        if MemoryLayout<Int>.size == 4 {
            contents.append(key, Int32(value))
        } else {
            contents.append(key, Int64(value))
        }
        codingPath.append(key)
    }

    func encode(_ value: Int8, forKey key: Key) throws {
        contents.append(key, Int32(value))
        codingPath.append(key)
    }

    func encode(_ value: Int16, forKey key: Key) throws {
        contents.append(key, Int32(value))
        codingPath.append(key)
    }

    func encode(_ value: Int32, forKey key: Key) throws {
        contents.append(key, value)
        codingPath.append(key)
    }

    func encode(_ value: Int64, forKey key: Key) throws {
        contents.append(key, value)
        codingPath.append(key)
    }

    func encode(_ value: UInt, forKey key: Key) throws {
        contents.append(key, UInt64(value))
        codingPath.append(key)
    }

    func encode(_ value: UInt8, forKey key: Key) throws {
        contents.append(key, UInt64(value))
        codingPath.append(key)
    }

    func encode(_ value: UInt16, forKey key: Key) throws {
        contents.append(key, UInt64(value))
        codingPath.append(key)
    }

    func encode(_ value: UInt32, forKey key: Key) throws {
        contents.append(key, UInt64(value))
        codingPath.append(key)
    }

    func encode(_ value: UInt64, forKey key: Key) throws {
        contents.append(key, value)
        codingPath.append(key)
    }

    func encode<T: Encodable>(_ value: T, forKey key: Key) throws {
        if let bsonValue = value as? ValueProtocol {
            contents.append(key, ValueBox(bsonValue))
            codingPath.append(key)
        } else {
            let encoder = BSONEncodingContainerProvider(codingPath: codingPath)
            try value.encode(to: encoder)
            contents.append(key, encoder)
            codingPath.append(key)
        }
    }

    func nestedContainer<NestedKey: CodingKey>(
        keyedBy keyType: NestedKey.Type, 
        forKey key: Key
    ) -> KeyedEncodingContainer<NestedKey> {
        let nestedContainer = BSONKeyedEncodingContainer<NestedKey>(codingPath: codingPath)
        contents.append(key, nestedContainer)
        return KeyedEncodingContainer(nestedContainer)
    }

    func nestedUnkeyedContainer(forKey key: Key) -> UnkeyedEncodingContainer {
        let nestedContainer = BSONUnkeyedEncodingContainer(codingPath: codingPath)
        contents.append(key, nestedContainer)
        return nestedContainer
    }

    func superEncoder() -> Encoder {
        let superEncoder = BSONEncodingContainerProvider(codingPath: codingPath)
        contents.append(("super", ValueBox(superEncoder)))
        return superEncoder
    }

    func superEncoder(forKey key: Key) -> Encoder {
        let superEncoder = BSONEncodingContainerProvider(codingPath: codingPath)
        contents.append(key, superEncoder)
        return superEncoder
    }
}