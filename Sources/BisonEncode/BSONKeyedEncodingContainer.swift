//
//  BSONKeyedEncodingContainer.swift
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

import BisonWrite

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

extension BSONKeyedEncodingContainer: WritableValue {
    func append<Doc>(to document: inout Doc)
    where Doc : RangeReplaceableCollection, Doc.Element == UInt8 {
        WritableDoc {
            ForEach(self.contents) { key, value in 
                key => value
            }
        }
        .append(to: &document)
    }

    var bsonType: UInt8 {
        3
    }
}

extension Array where Element == (String, ValueBox) {
    /// Appends the provided key-value pair to the container's storage.
    fileprivate mutating func append<T: WritableValue, K: CodingKey>(_ key: K, _ value: T) {
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
        if let bsonValue = value as? WritableValue {
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