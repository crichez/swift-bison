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
        defer { codingPath.append(key) }
        return try valueData(forKey: key).isEmpty
    }

    func decode(_ type: Bool.Type, forKey key: Key) throws -> Bool {
        defer { codingPath.append(key) }
        let encodedValue = try valueData(forKey: key)
        do {
            return try Bool(bsonBytes: encodedValue)
        } catch Bool.Error.sizeMismatch {
            let context = DecodingError.Context(
                codingPath: codingPath, 
                debugDescription: "expected 1 byte but found \(encodedValue.count)",
                underlyingError: Bool.Error.sizeMismatch)
            throw DecodingError.typeMismatch(type, context)
        }
    }

    func decode(_ type: String.Type, forKey key: Key) throws -> String {
        defer { codingPath.append(key) }
        let encodedValue = try valueData(forKey: key)
        do {
            return try String(bsonBytes: encodedValue)
        } catch String.Error.dataTooShort {
            let context = DecodingError.Context(
                codingPath: codingPath, 
                debugDescription: "expected at least 5 bytes, but found \(encodedValue.count)",
                underlyingError: String.Error.dataTooShort)
            throw DecodingError.typeMismatch(type, context)
        } catch String.Error.sizeMismatch {
            let context = DecodingError.Context(
                codingPath: codingPath, 
                debugDescription: "String actual size different from declared size",
                underlyingError: String.Error.sizeMismatch)
            throw DecodingError.typeMismatch(type, context)
        }
    }

    func decode(_ type: Double.Type, forKey key: Key) throws -> Double {
        defer { codingPath.append(key) }
        let encodedValue = try valueData(forKey: key)
        do {
            return try Double(bsonBytes: encodedValue)
        } catch Double.Error.sizeMismatch {
            let context = DecodingError.Context(
                codingPath: codingPath, 
                debugDescription: "expected 8 bytes, but found \(encodedValue.count)",
                underlyingError: Double.Error.sizeMismatch)
            throw DecodingError.typeMismatch(type, context)
        }
    }

    func decode(_ type: Float.Type, forKey key: Key) throws -> Float {
        do {
            return Float(try decode(Double.self, forKey: key))
        } catch DecodingError.typeMismatch(_, let context) {
            throw DecodingError.typeMismatch(type, context)
        }
    }

    func decode(_ type: Int.Type, forKey key: Key) throws -> Int {
        if MemoryLayout<Int>.size == 4 {
            do {
                return Int(try decode(Int32.self, forKey: key))
            } catch DecodingError.typeMismatch(_, let context) {
                throw DecodingError.typeMismatch(type, context)
            }
        } else {
            do {
                return Int(try decode(Int64.self, forKey: key))
            } catch DecodingError.typeMismatch(_, let context) {
                throw DecodingError.typeMismatch(type, context)
            }
        }
    }

    func decode(_ type: Int8.Type, forKey key: Key) throws -> Int8 {
        do {
            return Int8(try decode(Int32.self, forKey: key))
        } catch DecodingError.typeMismatch(_, let context) {
            throw DecodingError.typeMismatch(type, context)
        }
    }

    func decode(_ type: Int16.Type, forKey key: Key) throws -> Int16 {
        do {
            return Int16(try decode(Int32.self, forKey: key))
        } catch DecodingError.typeMismatch(_, let context) {
            throw DecodingError.typeMismatch(type, context)
        }
    }

    func decode(_ type: Int32.Type, forKey key: Key) throws -> Int32 {
        defer { codingPath.append(key) }
        let encodedValue = try valueData(forKey: key)
        do {
            return try type.init(bsonBytes: encodedValue)
        } catch Int32.Error.sizeMismatch {
            let context = DecodingError.Context(
                codingPath: codingPath, 
                debugDescription: "expected 4 bytes, but found \(encodedValue.count)",
                underlyingError: Int32.Error.sizeMismatch)
            throw DecodingError.typeMismatch(type, context)
        }
    }

    func decode(_ type: Int64.Type, forKey key: Key) throws -> Int64 {
        defer { codingPath.append(key) }
        let encodedValue = try valueData(forKey: key)
        do {
            return try type.init(bsonBytes: encodedValue)
        } catch Int64.Error.sizeMismatch {
            let context = DecodingError.Context(
                codingPath: codingPath, 
                debugDescription: "expected 8 bytes, but found \(encodedValue.count)",
                underlyingError: Int64.Error.sizeMismatch)
            throw DecodingError.typeMismatch(type, context)
        }
    }

    func decode(_ type: UInt.Type, forKey key: Key) throws -> UInt {
        do {
            return UInt(try decode(UInt64.self, forKey: key))
        } catch DecodingError.typeMismatch(_, let context) {
            throw DecodingError.typeMismatch(type, context)
        }
    }

    func decode(_ type: UInt8.Type, forKey key: Key) throws -> UInt8 {
        do {
            return UInt8(try decode(UInt64.self, forKey: key))
        } catch DecodingError.typeMismatch(_, let context) {
            throw DecodingError.typeMismatch(type, context)
        }
    }

    func decode(_ type: UInt16.Type, forKey key: Key) throws -> UInt16 {
        do {
            return UInt16(try decode(UInt64.self, forKey: key))
        } catch DecodingError.typeMismatch(_, let context) {
            throw DecodingError.typeMismatch(type, context)
        }
    }

    func decode(_ type: UInt32.Type, forKey key: Key) throws -> UInt32 {
        do {
            return UInt32(try decode(UInt64.self, forKey: key))
        } catch DecodingError.typeMismatch(_, let context) {
            throw DecodingError.typeMismatch(type, context)
        }
    }

    func decode(_ type: UInt64.Type, forKey key: Key) throws -> UInt64 {
        defer { codingPath.append(key) }
        let encodedValue = try valueData(forKey: key)
        do {
            return try type.init(bsonBytes: encodedValue)
        } catch UInt64.Error.sizeMismatch {
            let context = DecodingError.Context(
                codingPath: codingPath, 
                debugDescription: "expected 8 bytes, but found \(encodedValue.count)",
                underlyingError: UInt64.Error.sizeMismatch)
            throw DecodingError.typeMismatch(type, context)
        }
    }

    func decode<T: Decodable>(_ type: T.Type, forKey key: Key) throws -> T {
        fatalError("not implemented")
        // let encodedValue = try valueData(forKey: key)
        // codingPath.append(key)
        // var decoder = DecodingContainerProvider(data: encodedValue, codingPath: codingPath)
        // return try type.init(from: decoder)
    }

    /// The error expected from parsing a nested keyed document.
    private typealias NestedDocError = ParsedDocument<Data.SubSequence>.Error

    func nestedContainer<NestedKey: CodingKey>(
        keyedBy type: NestedKey.Type, 
        forKey key: Key
    ) throws -> KeyedDecodingContainer<NestedKey> {
        let encodedDoc = try valueData(forKey: key)
        do {
            let parsedDoc = try ParsedDocument(bsonBytes: encodedDoc)
            let nestedContainer = BSONKeyedDecodingContainer<Data.SubSequence, NestedKey>(
                doc: parsedDoc,
                codingPath: codingPath)
            return KeyedDecodingContainer(nestedContainer)
        } catch NestedDocError.docTooShort {
            let context = DecodingError.Context(
                codingPath: codingPath, 
                debugDescription: """
                    expected at least 5 bytes for a document, but found \(encodedDoc.count)
                """,
                underlyingError: NestedDocError.docTooShort)
            throw DecodingError.typeMismatch(KeyedDecodingContainer<NestedKey>.self, context)
        } catch NestedDocError.notTerminated {
            let context = DecodingError.Context(
                codingPath: codingPath, 
                debugDescription: "expected a null byte at the end of the document",
                underlyingError: NestedDocError.notTerminated)
            throw DecodingError.dataCorrupted(context)
        } catch NestedDocError.docSizeMismatch(let declared) {
            let context = DecodingError.Context(
                codingPath: codingPath, 
                debugDescription: """
                    declared document size is \(declared) but actual size is \(encodedDoc.count)
                """,
                underlyingError: NestedDocError.docSizeMismatch(declared))
            throw DecodingError.typeMismatch(KeyedDecodingContainer<NestedKey>.self, context)
        } catch NestedDocError.unknownType(let type, let key, let progress) {
            let context = DecodingError.Context(
                codingPath: codingPath, 
                debugDescription: "key \"\(key)\" has unknown type byte \(type)", 
                underlyingError: NestedDocError.unknownType(type, key, progress))
            throw DecodingError.dataCorrupted(context)
        } catch NestedDocError.valueSizeMismatch(let need, let key, let progress) {
            let context = DecodingError.Context(
                codingPath: codingPath, 
                debugDescription: "expected at least \(need) bytes for value \"\(key)\"",
                underlyingError: NestedDocError.valueSizeMismatch(need, key, progress))
            throw DecodingError.dataCorrupted(context)
        }
    }

    func nestedUnkeyedContainer(forKey key: Key) throws -> UnkeyedDecodingContainer {
        fatalError("not implemented")
        let encodedDoc = try valueData(forKey: key)
        do {
            let parsedDoc = try ParsedDocument(bsonBytes: encodedDoc)
            // return BSONUnkeyedDecodingContainer<Data.SubSequence>(
            //    doc: parsedDoc,
            //     codingPath: codingPath)
        } catch NestedDocError.docTooShort {
            let context = DecodingError.Context(
                codingPath: codingPath, 
                debugDescription: """
                    expected at least 5 bytes for a document, but found \(encodedDoc.count)
                """,
                underlyingError: NestedDocError.docTooShort)
            throw DecodingError.typeMismatch(UnkeyedDecodingContainer.self, context)
        } catch NestedDocError.notTerminated {
            let context = DecodingError.Context(
                codingPath: codingPath, 
                debugDescription: "expected a null byte at the end of the document",
                underlyingError: NestedDocError.notTerminated)
            throw DecodingError.dataCorrupted(context)
        } catch NestedDocError.docSizeMismatch(let declared) {
            let context = DecodingError.Context(
                codingPath: codingPath, 
                debugDescription: """
                    declared document size is \(declared) but actual size is \(encodedDoc.count)
                """,
                underlyingError: NestedDocError.docSizeMismatch(declared))
            throw DecodingError.typeMismatch(UnkeyedDecodingContainer.self, context)
        } catch NestedDocError.unknownType(let type, let key, let progress) {
            let context = DecodingError.Context(
                codingPath: codingPath, 
                debugDescription: "key \"\(key)\" has unknown type byte \(type)", 
                underlyingError: NestedDocError.unknownType(type, key, progress))
            throw DecodingError.dataCorrupted(context)
        } catch NestedDocError.valueSizeMismatch(let need, let key, let progress) {
            let context = DecodingError.Context(
                codingPath: codingPath, 
                debugDescription: "expected at least \(need) bytes for value \"\(key)\"",
                underlyingError: NestedDocError.valueSizeMismatch(need, key, progress))
            throw DecodingError.dataCorrupted(context)
        }
    }

    func superDecoder() throws -> Decoder {
        fatalError("not implemented")
        // return DecodingContainerProvider(data: doc["super"], codingPath: codingPath)
    }

    func superDecoder(forKey key: Key) throws -> Decoder {
        fatalError("not implemented")
        // let valueData = try valueData(forKey: key)
        // codingPath.append(key)
        // return DecodingContainerProvider(data: valueData, codingPath: codingPath)
    }
}
