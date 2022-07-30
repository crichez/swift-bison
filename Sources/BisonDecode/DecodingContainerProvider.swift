//
//  DecodingContainerProvider.swift
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

import BisonRead

struct DecodingContainerProvider<Data: Collection> where Data.Element == UInt8 {
    let encodedValue: Data

    let codingPath: [CodingKey]

    let userInfo: [CodingUserInfoKey: Any]

    init(
        encodedValue: Data, 
        codingPath: [CodingKey] = [], 
        userInfo: [CodingUserInfoKey: Any] = [:]
    ) {
        self.encodedValue = encodedValue
        self.codingPath = codingPath
        self.userInfo = userInfo
    }
}

extension DecodingContainerProvider: Decoder {
    private typealias NestedDocError = ReadableDoc<Data>.Error

    func container<Key: CodingKey>(keyedBy type: Key.Type) throws -> KeyedDecodingContainer<Key> {
        let doc = try ReadableDoc(
            decoding: encodedValue, 
            codingPath: codingPath, 
            for: KeyedDecodingContainer<Key>.self)
        let container = BSONKeyedDecodingContainer<Data, Key>(doc: doc, codingPath: codingPath)
        return KeyedDecodingContainer(container)
    }

    func unkeyedContainer() throws -> UnkeyedDecodingContainer {
        let doc = try ReadableDoc(
            decoding: encodedValue, 
            codingPath: codingPath, 
            for: UnkeyedDecodingContainer.self)
            return BSONUnkeyedDecodingContainer<Data>(doc: doc, codingPath: codingPath)
    }

    func singleValueContainer() throws -> SingleValueDecodingContainer {
        BSONSingleValueDecodingContainer(contents: encodedValue, codingPath: codingPath)
    }
}