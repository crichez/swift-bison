//
//  ReadableDocHelper.swift
//
//
//  Created by Christopher Richez on April 11 2022
//

import BisonRead

extension ReadableDoc {
    /// Parses the provided document, but maps all errors to `DecodingError`.
    init(decoding data: Data, codingPath: [CodingKey], for type: Any.Type) throws {
        do {
            try self.init(bsonBytes: data)
        } catch Error.docTooShort {
            let context = DecodingError.Context(
                codingPath: codingPath, 
                debugDescription: """
                    expected at least 5 bytes for a document, but found \(data.count)
                """,
                underlyingError: Error.docTooShort)
            throw DecodingError.typeMismatch(type, context)
        } catch Error.notTerminated {
            let context = DecodingError.Context(
                codingPath: codingPath, 
                debugDescription: "expected a null byte at the end of the document",
                underlyingError: Error.notTerminated)
            throw DecodingError.dataCorrupted(context)
        } catch Error.docSizeMismatch(let declared) {
            let context = DecodingError.Context(
                codingPath: codingPath, 
                debugDescription: """
                    declared document size is \(declared) but actual size is \(data.count)
                """,
                underlyingError: Error.docSizeMismatch(declared))
            throw DecodingError.typeMismatch(type, context)
        } catch Error.unknownType(let type, let key, let progress) {
            let context = DecodingError.Context(
                codingPath: codingPath, 
                debugDescription: "key \"\(key)\" has unknown type byte \(type)", 
                underlyingError: Error.unknownType(type, key, progress))
            throw DecodingError.dataCorrupted(context)
        } catch Error.valueSizeMismatch(let need, let key, let progress) {
            let context = DecodingError.Context(
                codingPath: codingPath, 
                debugDescription: "expected at least \(need) bytes for value \"\(key)\"",
                underlyingError: Error.valueSizeMismatch(need, key, progress))
            throw DecodingError.dataCorrupted(context)
        }
    }
}