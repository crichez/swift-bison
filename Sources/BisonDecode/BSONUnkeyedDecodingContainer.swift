//
//  BSONUnkeyedDecodingContainer.swift
//
//
//  Created by Christopher Richez on April 5 2022
//

import BisonRead

struct BSONUnkeyedDecodingContainer<Data: Collection> where Data.Element == UInt8 {
    /// The parsed document to retrieve values from.
    let doc: ReadableDoc<Data>

    /// The path the decoder took to this point.
    let codingPath: [CodingKey]

    /// The current index of the decoder for this container.
    var currentIndex: Int = 0

    init(doc: ReadableDoc<Data>, codingPath: [CodingKey] = []) {
        self.doc = doc
        self.codingPath = codingPath
    }
}

extension BSONUnkeyedDecodingContainer: UnkeyedDecodingContainer {
    var count: Int? {
        doc.keys.count
    }

    var isAtEnd: Bool {
        currentIndex == count
    }

    private struct MissingKey: CodingKey {
        let stringValue: String

        var intValue: Int? {
            Int(stringValue)
        }

        init?(stringValue: String) {
            self.stringValue = stringValue
        }

        init?(intValue: Int) {
            self.stringValue = String(intValue)
        }
    }

    mutating func decodeNil() throws -> Bool {
        if let encodedValue = doc[String(currentIndex)], encodedValue.isEmpty {
            currentIndex += 1
            return true
        } else {
            return false
        }
    }

    private mutating func nextValueData() throws -> Data.SubSequence {
        guard let encodedValue = doc[String(currentIndex)] else {
            let context = DecodingError.Context(
                codingPath: codingPath, 
                debugDescription: "no key \"(currentIndex)\" in document")
            throw DecodingError.keyNotFound(MissingKey(intValue: currentIndex)!, context)
        }
        currentIndex += 1
        return encodedValue
    }

    private mutating func read<T: ReadableValue>(_ type: T.Type) throws -> T {
        let encodedValue = try nextValueData()
        do {
            return try type.init(bsonBytes: encodedValue)
        } catch BisonError.sizeMismatch(let need, let have) {
            let context = DecodingError.Context(
                codingPath: codingPath,
                debugDescription: """
                    expected \(need) bytes for a \(type) but found \(have)
                """,
                underlyingError: BisonError.sizeMismatch(need, have))
            throw DecodingError.typeMismatch(type, context)
        } catch BisonError.dataTooShort(let needAtLeast, let have) {
            let context = DecodingError.Context(
                codingPath: codingPath,
                debugDescription: """
                    expected at least \(needAtLeast) bytes for a \(type) but found \(have)
                """,
                underlyingError: BisonError.dataTooShort(needAtLeast, have))
            throw DecodingError.typeMismatch(type, context)
        }
    }

    private mutating func readExistential<T: Decodable>(
        _ type: ReadableValue.Type, 
        as unwrappedType: T.Type
    ) throws -> T {
        let valueData = try nextValueData()
        do {
            let decodedValue = try type.init(bsonBytes: valueData)
            return decodedValue as! T
        } catch BisonError.sizeMismatch(let need, let have) {
            let context = DecodingError.Context(
                codingPath: codingPath, 
                debugDescription: "expected \(need) bytes for a \(type) but found \(have)",
                underlyingError: BisonError.sizeMismatch(need, have))
            throw DecodingError.typeMismatch(type, context)
        } catch BisonError.dataTooShort(let needAtLeast, let have) {
            let context = DecodingError.Context(
                codingPath: codingPath, 
                debugDescription: """
                    expected at least\(needAtLeast) bytes for a \(type) but found \(have)
                """,
                underlyingError: BisonError.dataTooShort(needAtLeast, have))
            throw DecodingError.typeMismatch(type, context)
        }
    }

    mutating func decode(_ type: Bool.Type) throws -> Bool {
        try read(type)
    }

    mutating func decode(_ type: String.Type) throws -> String {
        try read(type)
    }

    mutating func decode(_ type: Double.Type) throws -> Double {
        try read(type)
    }

    mutating func decode(_ type: Float.Type) throws -> Float {
        Float(try read(Double.self))
    }

    mutating func decode(_ type: Int.Type) throws -> Int {
        if MemoryLayout<Int>.size == 4 {
            return Int(try read(Int32.self))
        } else {
            return Int(try read(Int64.self))
        }
    }

    mutating func decode(_ type: Int8.Type) throws -> Int8 {
        Int8(try read(Int32.self))
    }

    mutating func decode(_ type: Int16.Type) throws -> Int16 {
        Int16(try read(Int32.self))
    }

    mutating func decode(_ type: Int32.Type) throws -> Int32 {
        try read(type)
    }

    mutating func decode(_ type: Int64.Type) throws -> Int64 {
        try read(type)
    }

    mutating func decode(_ type: UInt.Type) throws -> UInt {
        UInt(try read(UInt64.self))
    }

    mutating func decode(_ type: UInt8.Type) throws -> UInt8 {
        UInt8(try read(UInt64.self))
    }

    mutating func decode(_ type: UInt16.Type) throws -> UInt16 {
        UInt16(try read(UInt64.self))
    }

    mutating func decode(_ type: UInt32.Type) throws -> UInt32 {
        UInt32(try read(UInt64.self))
    }

    mutating func decode(_ type: UInt64.Type) throws -> UInt64 {
        try read(type)
    }

    mutating func decode<T>(_ type: T.Type) throws -> T where T : Decodable {
        if type is ReadableValue.Type {
            let decodedValue = try readExistential(type as! ReadableValue.Type, as: type)
            return decodedValue
        } else {
            let encodedValue = try nextValueData()
            let decoder = DecodingContainerProvider(encodedValue: encodedValue, codingPath: codingPath)
            return try type.init(from: decoder)
        }
    }

    /// The error expected from parsing a nested keyed document.
    private typealias NestedDocError = ReadableDoc<Data.SubSequence>.Error

    mutating func nestedContainer<NestedKey: CodingKey>(
        keyedBy type: NestedKey.Type
    ) throws -> KeyedDecodingContainer<NestedKey> {
        let encodedDoc = try nextValueData()
        let parsedDoc = try ReadableDoc(
            decoding: encodedDoc, 
            codingPath: codingPath, 
            for: KeyedDecodingContainer<NestedKey>.self)
        let container = BSONKeyedDecodingContainer<Data.SubSequence, NestedKey>(
            doc: parsedDoc, 
            codingPath: codingPath)
        return KeyedDecodingContainer(container)
    }

    mutating func nestedUnkeyedContainer() throws -> UnkeyedDecodingContainer {
        let encodedDoc = try nextValueData()
        let parsedDoc = try ReadableDoc(
            decoding: encodedDoc, 
            codingPath: codingPath, 
            for: UnkeyedDecodingContainer.self)
        return BSONUnkeyedDecodingContainer<Data.SubSequence>(
            doc: parsedDoc, 
            codingPath: codingPath)
    }

    mutating func superDecoder() throws -> Decoder {
        DecodingContainerProvider(encodedValue: try nextValueData(), codingPath: codingPath)
    }
}