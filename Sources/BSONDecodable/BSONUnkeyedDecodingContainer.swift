//
//  BSONUnkeyedDecodingContainer.swift
//
//
//  Created by Christopher Richez on April 5 2022
//

import BSONParse

struct BSONUnkeyedDecodingContainer<Data: Collection> where Data.Element == UInt8 {
    /// The parsed document to retrieve values from.
    let doc: ParsedDocument<Data>

    /// The path the decoder took to this point.
    let codingPath: [CodingKey]

    /// The current index of the decoder for this container.
    var currentIndex: Int = 0

    init(doc: ParsedDocument<Data>, codingPath: [CodingKey] = []) {
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

    mutating func nextValueData() throws -> Data.SubSequence {
        guard let encodedValue = doc[String(currentIndex)] else {
            let context = DecodingError.Context(
                codingPath: codingPath, 
                debugDescription: "no key \"(currentIndex)\" in document")
            throw DecodingError.keyNotFound(MissingKey(intValue: currentIndex)!, context)
        }
        currentIndex += 1
        return encodedValue
    }

    mutating func decode(_ type: Bool.Type) throws -> Bool {
        let encodedValue = try nextValueData()
        do {
            return try type.init(bsonBytes: encodedValue)
        } catch Bool.Error.sizeMismatch {
            let context = DecodingError.Context(
                codingPath: codingPath,
                debugDescription: "expected 1 byte but found \(encodedValue.count)",
                underlyingError: Bool.Error.sizeMismatch)
            throw DecodingError.typeMismatch(type, context)
        }
    }

    mutating func decode(_ type: String.Type) throws -> String {
        let encodedValue = try nextValueData()
        do {
            return try type.init(bsonBytes: encodedValue)
        } catch String.Error.sizeMismatch {
            let context = DecodingError.Context(
                codingPath: codingPath,
                debugDescription: "declared size different from actual size",
                underlyingError: String.Error.sizeMismatch)
            throw DecodingError.typeMismatch(type, context)
        } catch String.Error.dataTooShort {
            let context = DecodingError.Context(
                codingPath: codingPath, 
                debugDescription: "expected at least 5 bytes but found \(encodedValue.count)",
                underlyingError: String.Error.dataTooShort)
            throw DecodingError.typeMismatch(type, context)
        }
    }

    mutating func decode(_ type: Double.Type) throws -> Double {
        let encodedValue = try nextValueData()
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

    mutating func decode(_ type: Float.Type) throws -> Float {
        do {
            return Float(try decode(Double.self))
        } catch DecodingError.typeMismatch(_, let context) {
            throw DecodingError.typeMismatch(type, context)
        }
    }

    mutating func decode(_ type: Int.Type) throws -> Int {
        if MemoryLayout<Int>.size == 4 {
            do {
                return Int(try decode(Int32.self))
            } catch DecodingError.typeMismatch(_, let context) {
                throw DecodingError.typeMismatch(type, context)
            }
        } else {
            do {
                return Int(try decode(Int64.self))
            } catch DecodingError.typeMismatch(_, let context) {
                throw DecodingError.typeMismatch(type, context)
            }
        }
    }

    mutating func decode(_ type: Int8.Type) throws -> Int8 {
        do {
            return Int8(try decode(Int32.self))
        } catch DecodingError.typeMismatch(_, let context) {
            throw DecodingError.typeMismatch(type, context)
        }
    }

    mutating func decode(_ type: Int16.Type) throws -> Int16 {
        do {
            return Int16(try decode(Int32.self))
        } catch DecodingError.typeMismatch(_, let context) {
            throw DecodingError.typeMismatch(type, context)
        }
    }

    mutating func decode(_ type: Int32.Type) throws -> Int32 {
        let encodedValue = try nextValueData()
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

    mutating func decode(_ type: Int64.Type) throws -> Int64 {
        let encodedValue = try nextValueData()
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

    mutating func decode(_ type: UInt.Type) throws -> UInt {
        do {
            return UInt(try decode(UInt64.self))
        } catch DecodingError.typeMismatch(_, let context) {
            throw DecodingError.typeMismatch(type, context)
        }
    }

    mutating func decode(_ type: UInt8.Type) throws -> UInt8 {
        do {
            return UInt8(try decode(UInt64.self))
        } catch DecodingError.typeMismatch(_, let context) {
            throw DecodingError.typeMismatch(type, context)
        }
    }

    mutating func decode(_ type: UInt16.Type) throws -> UInt16 {
        do {
            return UInt16(try decode(UInt64.self))
        } catch DecodingError.typeMismatch(_, let context) {
            throw DecodingError.typeMismatch(type, context)
        }
    }

    mutating func decode(_ type: UInt32.Type) throws -> UInt32 {
        do {
            return UInt32(try decode(UInt64.self))
        } catch DecodingError.typeMismatch(_, let context) {
            throw DecodingError.typeMismatch(type, context)
        }
    }

    mutating func decode(_ type: UInt64.Type) throws -> UInt64 {
        let encodedValue = try nextValueData()
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

    mutating func decode<T>(_ type: T.Type) throws -> T where T : Decodable {
        fatalError("not implemented")
        // let encodedValue = try nextValueData()
        // var decoder = DecodingContainerProvider(data: encodedValue, codingPath: codingPath)
        // return try type.init(from: decoder)
    }

    /// The error expected from parsing a nested keyed document.
    private typealias NestedDocError = ParsedDocument<Data.SubSequence>.Error

    mutating func nestedContainer<NestedKey: CodingKey>(
        keyedBy type: NestedKey.Type
    ) throws -> KeyedDecodingContainer<NestedKey> {
        let encodedDoc = try nextValueData()
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

    mutating func nestedUnkeyedContainer() throws -> UnkeyedDecodingContainer {
        let encodedDoc = try nextValueData()
        do {
            let parsedDoc = try ParsedDocument(bsonBytes: encodedDoc)
            return BSONUnkeyedDecodingContainer<Data.SubSequence>(
               doc: parsedDoc,
               codingPath: codingPath)
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

    mutating func superDecoder() throws -> Decoder {
        fatalError("not implemented")
        // return DecodingContainerProvider(data: try nextValueData(), codingPath: codingPath)
    }
}