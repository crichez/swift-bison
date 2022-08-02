//
//  ParsedDocumentHelper.swift
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

extension ReadableDoc {
    /// Parses the provided document, but maps all errors to `DecodingError`.
    init(decoding data: Data, codingPath: [CodingKey], for type: Any.Type) throws {
        do {
            try self.init(bsonBytes: data)
        } catch DocError<Data>.docTooShort {
            let context = DecodingError.Context(
                codingPath: codingPath, 
                debugDescription: """
                    expected at least 5 bytes for a document, but found \(data.count)
                """,
                underlyingError: DocError<Data>.docTooShort)
            throw DecodingError.typeMismatch(type, context)
        } catch DocError<Data>.notTerminated {
            let context = DecodingError.Context(
                codingPath: codingPath, 
                debugDescription: "expected a null byte at the end of the document",
                underlyingError: DocError<Data>.notTerminated)
            throw DecodingError.dataCorrupted(context)
        } catch DocError<Data>.docSizeMismatch(let declared) {
            let context = DecodingError.Context(
                codingPath: codingPath, 
                debugDescription: """
                    declared document size is \(declared) but actual size is \(data.count)
                """,
                underlyingError: DocError<Data>.docSizeMismatch(expectedExactly: declared))
            throw DecodingError.typeMismatch(type, context)
        } catch DocError<Data>.unknownType(let type, let key, let progress) {
            let context = DecodingError.Context(
                codingPath: codingPath, 
                debugDescription: "key \"\(key)\" has unknown type byte \(type)", 
                underlyingError: DocError<Data>.unknownType(
                    type: type, 
                    key: key, 
                    progress: progress))
            throw DecodingError.dataCorrupted(context)
        } catch DocError<Data>.valueSizeMismatch(let need, let key, let progress) {
            let context = DecodingError.Context(
                codingPath: codingPath, 
                debugDescription: "expected at least \(need) bytes for value \"\(key)\"",
                underlyingError: DocError<Data>.valueSizeMismatch(need, key, progress))
            throw DecodingError.dataCorrupted(context)
        }
    }
}