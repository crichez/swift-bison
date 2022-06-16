//
//  DecodingContainerProvider.swift
//
//
//  Created by Christopher Richez on April 11 2022
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