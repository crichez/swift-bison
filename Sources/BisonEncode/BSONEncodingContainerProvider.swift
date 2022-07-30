//
//  BSONEncodingContainerProvider.swift
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

class BSONEncodingContainerProvider {
    /// The container selected by the object to encode.
    var container: ValueBox? = nil

    /// The path the encoder took to this point.
    let codingPath: [CodingKey]

    /// The userInfo dictionary for this encoder.
    let userInfo: [CodingUserInfoKey: Any] = [:]

    /// Initializes a container with the provided coding path.
    init(codingPath: [CodingKey]) {
        self.codingPath = codingPath
    }
}

extension BSONEncodingContainerProvider: WritableValue {
    func append<Doc>(to document: inout Doc)
    where Doc : RangeReplaceableCollection, Doc.Element == UInt8 {
        container!.append(to: &document)
    }

    var bsonType: UInt8 {
        container!.bsonType
    }
}

extension BSONEncodingContainerProvider: Encoder {
    func container<Key: CodingKey>(keyedBy type: Key.Type) -> KeyedEncodingContainer<Key> {
        let container = BSONKeyedEncodingContainer<Key>(codingPath: codingPath)
        self.container = ValueBox(container)
        return KeyedEncodingContainer(container)
    }

    func unkeyedContainer() -> UnkeyedEncodingContainer {
        let container = BSONUnkeyedEncodingContainer(codingPath: codingPath)
        self.container = ValueBox(container)
        return container
    }

    func singleValueContainer() -> SingleValueEncodingContainer {
        let container = BSONSingleValueEncodingContainer(codingPath: codingPath)
        self.container = ValueBox(container)
        return container
    }
}