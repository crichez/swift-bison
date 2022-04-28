//
//  BSONKeyedDecodingContainer.swift
//
//
//  Created by Christopher Richez on April 4 2022
//

import BSONParse

class BSONKeyedDecodingContainer<Data: Collection, Key: CodingKey> where Data.Element == UInt8 {
    /// The parsed document to decode from. 
    let doc: ParsedDocument<Data>

    /// The path the decoder took to this point.
    var codingPath: [CodingKey]

    /// Initializes a container from a parsed document and optionally a previous coding path.
    init(doc: ParsedDocument<Data>, codingPath: [CodingKey] = []) {
        self.doc = doc
        self.codingPath = codingPath
    }
}

extension BSONKeyedDecodingContainer: KeyedDecodingContainerProtocol {
    var allKeys: [Key] {
        doc.keys.compactMap { keyName in
            Key(stringValue: keyName)
        }
    }

    func contains(_ key: Key) -> Bool {
        doc.keys.contains(key.stringValue)
    }

    /// Retrieves the data for a value, or throws the appropriate error if the key wasn't found.
    private func valueData(forKey key: Key) throws -> Data.SubSequence {
        guard let valueData = doc[key.stringValue] else {
            let context = DecodingError.Context(
                codingPath: codingPath, 
                debugDescription: "no \"\(key.stringValue)\" key in this container")
            throw DecodingError.keyNotFound(key, context)
        }
        return valueData
    }

    func decodeNil(forKey key: Key) throws -> Bool {
        try valueData(forKey: key).isEmpty
    }

    private func read<T: ParsableValue>(_ type: T.Type, forKey key: Key) throws -> T {
        let valueData = try valueData(forKey: key)
        do {
            let decodedValue = try type.init(bsonBytes: valueData)
            codingPath.append(key)
            return decodedValue
        } catch ValueParseError.sizeMismatch(let need, let have) {
            let context = DecodingError.Context(
                codingPath: codingPath, 
                debugDescription: "expected \(need) bytes for a \(type) but found \(have)",
                underlyingError: ValueParseError.sizeMismatch(need, have))
            throw DecodingError.typeMismatch(type, context)
        } catch ValueParseError.dataTooShort(let needAtLeast, let have) {
            let context = DecodingError.Context(
                codingPath: codingPath, 
                debugDescription: """
                    expected at least\(needAtLeast) bytes for a \(type) but found \(have)
                """,
                underlyingError: ValueParseError.dataTooShort(needAtLeast, have))
            throw DecodingError.typeMismatch(type, context)
        }
    }

    private func readExistential<T>(
        _ type: ParsableValue.Type, 
        forKey key: Key, as unwrappedType: T.Type
    ) throws -> T where T : Decodable {
        let valueData = try valueData(forKey: key)
        do {
            let decodedValue = try type.init(bsonBytes: valueData)
            codingPath.append(key)
            return decodedValue as! T
        } catch ValueParseError.sizeMismatch(let need, let have) {
            let context = DecodingError.Context(
                codingPath: codingPath, 
                debugDescription: "expected \(need) bytes for a \(type) but found \(have)",
                underlyingError: ValueParseError.sizeMismatch(need, have))
            throw DecodingError.typeMismatch(type, context)
        } catch ValueParseError.dataTooShort(let needAtLeast, let have) {
            let context = DecodingError.Context(
                codingPath: codingPath, 
                debugDescription: """
                    expected at least\(needAtLeast) bytes for a \(type) but found \(have)
                """,
                underlyingError: ValueParseError.dataTooShort(needAtLeast, have))
            throw DecodingError.typeMismatch(type, context)
        }
    }

    func decode(_ type: Bool.Type, forKey key: Key) throws -> Bool {
        try read(type, forKey: key)
    }

    func decode(_ type: String.Type, forKey key: Key) throws -> String {
        try read(type, forKey: key)
    }

    func decode(_ type: Double.Type, forKey key: Key) throws -> Double {
        try read(type, forKey: key)
    }

    func decode(_ type: Float.Type, forKey key: Key) throws -> Float {
        Float(try read(Double.self, forKey: key))
    }

    func decode(_ type: Int.Type, forKey key: Key) throws -> Int {
        if MemoryLayout<Int>.size == 4 {
            return Int(try read(Int32.self, forKey: key))
        } else {
            return Int(try read(Int64.self, forKey: key))
        }
    }

    func decode(_ type: Int8.Type, forKey key: Key) throws -> Int8 {
        Int8(try read(Int32.self, forKey: key))
    }

    func decode(_ type: Int16.Type, forKey key: Key) throws -> Int16 {
        Int16(try read(Int32.self, forKey: key))
    }

    func decode(_ type: Int32.Type, forKey key: Key) throws -> Int32 {
        try read(type, forKey: key)
    }

    func decode(_ type: Int64.Type, forKey key: Key) throws -> Int64 {
        try read(type, forKey: key)
    }

    func decode(_ type: UInt.Type, forKey key: Key) throws -> UInt {
        UInt(try read(UInt64.self, forKey: key))
    }

    func decode(_ type: UInt8.Type, forKey key: Key) throws -> UInt8 {
        UInt8(try read(UInt64.self, forKey: key))
    }

    func decode(_ type: UInt16.Type, forKey key: Key) throws -> UInt16 {
        UInt16(try read(UInt64.self, forKey: key))
    }

    func decode(_ type: UInt32.Type, forKey key: Key) throws -> UInt32 {
        UInt32(try read(UInt64.self, forKey: key))
    }

    func decode(_ type: UInt64.Type, forKey key: Key) throws -> UInt64 {
        try read(type, forKey: key)
    }

    func decode<T: Decodable>(_ type: T.Type, forKey key: Key) throws -> T {
        if type is ParsableValue.Type {
            let decodedValue = try readExistential(
                (type as! ParsableValue.Type), 
                forKey: key, 
                as: type)
            codingPath.append(key)
            return decodedValue
        } else {
            let encodedValue = try valueData(forKey: key)
            let decoder = DecodingContainerProvider(encodedValue: encodedValue, codingPath: codingPath)
            let decodedValue = try type.init(from: decoder)
            codingPath.append(key)
            return decodedValue
        }
    }

    /// The error expected from parsing a nested keyed document.
    private typealias NestedDocError = ParsedDocument<Data.SubSequence>.Error

    func nestedContainer<NestedKey: CodingKey>(
        keyedBy type: NestedKey.Type, 
        forKey key: Key
    ) throws -> KeyedDecodingContainer<NestedKey> {
        let encodedDoc = try valueData(forKey: key)
        let parsedDoc = try ParsedDocument(
            decoding: encodedDoc, 
            codingPath: codingPath, 
            for: KeyedDecodingContainer<NestedKey>.self)
        codingPath.append(key)
        let container = BSONKeyedDecodingContainer<Data.SubSequence, NestedKey>(
            doc: parsedDoc, 
            codingPath: codingPath)
        return KeyedDecodingContainer(container)
    }

    func nestedUnkeyedContainer(forKey key: Key) throws -> UnkeyedDecodingContainer {
        let encodedDoc = try valueData(forKey: key)
        let parsedDoc = try ParsedDocument(
            decoding: encodedDoc, 
            codingPath: codingPath, 
            for: UnkeyedDecodingContainer.self)
        codingPath.append(key)
        return BSONUnkeyedDecodingContainer<Data.SubSequence>(
            doc: parsedDoc, 
            codingPath: codingPath)
    }

    private enum MissingKey: CodingKey {
        case `super`
    }

    func superDecoder() throws -> Decoder {
        guard let encodedValue = doc["super"] else {
            let context = DecodingError.Context(
                codingPath: codingPath, 
                debugDescription: "no key named \"super\" in document")
            throw DecodingError.keyNotFound(MissingKey.super, context)
        }
        return DecodingContainerProvider(encodedValue: encodedValue, codingPath: codingPath)
    }

    func superDecoder(forKey key: Key) throws -> Decoder {
        let encodedValue = try valueData(forKey: key)
        codingPath.append(key)
        return DecodingContainerProvider(encodedValue: encodedValue, codingPath: codingPath)
    }
}
