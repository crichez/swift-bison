//
//  BSONSingleValueDecodingContainer.swift
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

struct BSONSingleValueDecodingContainer<Data: Collection> where Data.Element == UInt8 {
    /// The bytes in this container.
    let contents: Data

    /// The path the decoder took to this point.
    let codingPath: [CodingKey]
}

extension BSONSingleValueDecodingContainer: SingleValueDecodingContainer {
    func decodeNil() -> Bool {
        contents.isEmpty
    }

    private func read<T: ReadableValue>(_ type: T.Type) throws -> T {
        do {
            return try type.init(bsonBytes: contents)
        } catch ValueError.dataTooShort(let needAtLeast, let have) {
            let context = DecodingError.Context(
                codingPath: codingPath, 
                debugDescription: """
                    expected at least \(needAtLeast) bytes for a \(type), but found \(contents.count)
                """,
                underlyingError: ValueError.dataTooShort(needAtLeast: needAtLeast, found: have))
            throw DecodingError.typeMismatch(type, context)
        } catch ValueError.sizeMismatch(let need, let have) {
            let context = DecodingError.Context(
                codingPath: codingPath, 
                debugDescription: """
                    expected \(need) bytes for a \(type), but found \(contents.count)
                """,
                underlyingError: ValueError.sizeMismatch(expected: need, have: have))
            throw DecodingError.typeMismatch(type, context)
        }
    }

    private func readExistential<T>(
        _ type: ReadableValue.Type, 
        as unwrappedType: T.Type
    ) throws -> T where T : Decodable {
        do {
            let decodedValue = try type.init(bsonBytes: contents)
            return decodedValue as! T
        } catch ValueError.sizeMismatch(let need, let have) {
            let context = DecodingError.Context(
                codingPath: codingPath, 
                debugDescription: "expected \(need) bytes for a \(type) but found \(have)",
                underlyingError: ValueError.sizeMismatch(expected: need, have: have))
            throw DecodingError.typeMismatch(type, context)
        } catch ValueError.dataTooShort(let needAtLeast, let have) {
             let context = DecodingError.Context(
                codingPath: codingPath, 
                debugDescription: """
                    expected at least\(needAtLeast) bytes for a \(type) but found \(have)
                """,
                underlyingError: ValueError.dataTooShort(needAtLeast: needAtLeast, found: have))
            throw DecodingError.typeMismatch(type, context)
        }
    }

    func decode(_ type: Bool.Type) throws -> Bool {
        try read(type)
    }

    func decode(_ type: String.Type) throws -> String {
        try read(type)
    }

    func decode(_ type: Double.Type) throws -> Double {
        try read(type)
    }

    func decode(_ type: Float.Type) throws -> Float {
        Float(try read(Double.self))
    }

    func decode(_ type: Int.Type) throws -> Int {
        if MemoryLayout<Int>.size == 4 {
            return Int(try read(Int32.self))
        } else {
            return Int(try read(Int64.self))
        }
    }

    func decode(_ type: Int8.Type) throws -> Int8 {
        Int8(try read(Int32.self))
    }

    func decode(_ type: Int16.Type) throws -> Int16 {
        Int16(try read(Int32.self))
    }

    func decode(_ type: Int32.Type) throws -> Int32 {
        try read(type)
    }

    func decode(_ type: Int64.Type) throws -> Int64 {
        try read(type)
    }

    func decode(_ type: UInt.Type) throws -> UInt {
        UInt(try read(UInt64.self))
    }

    func decode(_ type: UInt8.Type) throws -> UInt8 {
        UInt8(try read(UInt64.self))
    }

    func decode(_ type: UInt16.Type) throws -> UInt16 {
        UInt16(try read(UInt64.self))
    }

    func decode(_ type: UInt32.Type) throws -> UInt32 {
        UInt32(try read(UInt64.self))
    }

    func decode(_ type: UInt64.Type) throws -> UInt64 {
        try read(type)
    }
    
    func decode<T>(_ type: T.Type) throws -> T where T : Decodable {
        if type is ReadableValue.Type {
            let decodedValue = try readExistential(type as! ReadableValue.Type, as: type)
            return decodedValue
        } else {
            let decoder = DecodingContainerProvider(encodedValue: contents, codingPath: codingPath)
            return try T(from: decoder)
        }
    }
}
