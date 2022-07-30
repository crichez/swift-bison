//
//  BSONUnkeyedEncodingContainer.swift
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
    mutating func append<T: WritableValue>(_ value: T) {
        append(ValueBox(value))
    }
}

extension BSONUnkeyedEncodingContainer: WritableValue {
    func append<Doc>(to document: inout Doc)
    where Doc : RangeReplaceableCollection, Doc.Element == UInt8 {
        WritableDoc {
            ForEach(self.contents.enumerated()) { index, value in 
                String(describing: index) => value
            }
        }
        .append(to: &document)
    }

    var bsonType: UInt8 {
        0x04
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
        if let bsonValue = value as? WritableValue {
            contents.append(ValueBox(bsonValue))
        } else {
            let encoder = BSONEncodingContainerProvider(codingPath: codingPath)
            try value.encode(to: encoder)
            contents.append(encoder)
        }
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