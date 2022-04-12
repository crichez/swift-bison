//
//  DecodingContainerProvider.swift
//
//
//  Created by Christopher Richez on April 11 2022
//

import BSONParse

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
    private typealias NestedDocError = ParsedDocument<Data>.Error

    func container<Key: CodingKey>(keyedBy type: Key.Type) throws -> KeyedDecodingContainer<Key> {
        do {
            let doc = try ParsedDocument(bsonBytes: encodedValue)
            let container = BSONKeyedDecodingContainer<Data, Key>(doc: doc, codingPath: codingPath)
            return KeyedDecodingContainer(container)
        } catch NestedDocError.docTooShort {
            let context = DecodingError.Context(
                codingPath: codingPath, 
                debugDescription: """
                    expected at least 5 bytes for a document, but found \(encodedValue.count)
                """,
                underlyingError: NestedDocError.docTooShort)
            throw DecodingError.typeMismatch(KeyedDecodingContainer<Key>.self, context)
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
                    declared document size is \(declared) but actual size is \(encodedValue.count)
                """,
                underlyingError: NestedDocError.docSizeMismatch(declared))
            throw DecodingError.typeMismatch(KeyedDecodingContainer<Key>.self, context)
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

    func unkeyedContainer() throws -> UnkeyedDecodingContainer {
        do {
            let parsedDoc = try ParsedDocument(bsonBytes: encodedValue)
            return BSONUnkeyedDecodingContainer<Data>(
                doc: parsedDoc,
                codingPath: codingPath)
        } catch NestedDocError.docTooShort {
            let context = DecodingError.Context(
                codingPath: codingPath, 
                debugDescription: """
                    expected at least 5 bytes for a document, but found \(encodedValue.count)
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
                    declared document size is \(declared) but actual size is \(encodedValue.count)
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

    func singleValueContainer() throws -> SingleValueDecodingContainer {
        BSONSingleValueDecodingContainer(contents: encodedValue, codingPath: codingPath)
    }
}