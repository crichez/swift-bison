//
//  BSONContainerProvider.swift
//
//
//  Created by Christopher Richez on March 31 2022
//

import BisonWrite
import Foundation

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
    var bsonBytes: Data {
        container!.bsonBytes
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