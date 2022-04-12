//
//  BSONSingleValueDecodingContainer.swift
//
//
//  Created by Christopher Richez on April 3 20222
//

import BSONParse

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

    func decode(_ type: Bool.Type) throws -> Bool {
        do {
            return try type.init(bsonBytes: contents)
        } catch Bool.Error.sizeMismatch {
            let context = DecodingError.Context(
                codingPath: codingPath, 
                debugDescription: "expected 1 byte, but found \(contents.count)",
                underlyingError: Bool.Error.sizeMismatch)
            throw DecodingError.typeMismatch(type, context)
        }
    }

    func decode(_ type: String.Type) throws -> String {
        do {
            return try type.init(bsonBytes: contents)
        } catch String.Error.sizeMismatch {
            let context = DecodingError.Context(
                codingPath: codingPath, 
                debugDescription: "declared size different from actual size",
                underlyingError: String.Error.sizeMismatch)
            throw DecodingError.typeMismatch(type, context)
        } catch String.Error.dataTooShort {
            let context = DecodingError.Context(
                codingPath: codingPath, 
                debugDescription: "expected at least 5 bytes, but found \(contents.count)",
                underlyingError: String.Error.dataTooShort)
            throw DecodingError.typeMismatch(type, context)
        }
    }

    func decode(_ type: Double.Type) throws -> Double {
        do {
            return try type.init(bsonBytes: contents)
        } catch Double.Error.sizeMismatch {
            let context = DecodingError.Context(
                codingPath: codingPath, 
                debugDescription: "expected 8 bytes, but found \(contents.count)",
                underlyingError: Double.Error.sizeMismatch)
            throw DecodingError.typeMismatch(Double.self, context)
        }
    }

    func decode(_ type: Float.Type) throws -> Float {
        do {
            return Float(try Double(bsonBytes: contents))
        } catch Double.Error.sizeMismatch {
            let context = DecodingError.Context(
                codingPath: codingPath, 
                debugDescription: "expected 8 bytes, but found \(contents.count)",
                underlyingError: Double.Error.sizeMismatch)
            throw DecodingError.typeMismatch(Float.self, context)
        }
    }

    func decode(_ type: Int.Type) throws -> Int {
        if MemoryLayout<Int>.size == 4 {
            do {
                return Int(try Int32(bsonBytes: contents))
            } catch Int32.Error.sizeMismatch {
                let context = DecodingError.Context(
                    codingPath: codingPath, 
                    debugDescription: "expected 4 bytes, but found \(contents.count)",
                    underlyingError: Int32.Error.sizeMismatch)
                throw DecodingError.typeMismatch(Int.self, context)
            }
        } else {
            do {
                return Int(try Int64(bsonBytes: contents))
            } catch Int64.Error.sizeMismatch {
                let context = DecodingError.Context(
                    codingPath: codingPath, 
                    debugDescription: "expected 8 bytes, but found \(contents.count)",
                    underlyingError: Int64.Error.sizeMismatch)
                throw DecodingError.typeMismatch(Int.self, context)
            }
        }
    }

    func decode(_ type: Int8.Type) throws -> Int8 {
        do {
            return Int8(try Int32(bsonBytes: contents))
        } catch Int32.Error.sizeMismatch {
            let context = DecodingError.Context(
                codingPath: codingPath, 
                debugDescription: "expected 4 bytes, but found \(contents.count)",
                underlyingError: Int32.Error.sizeMismatch)
            throw DecodingError.typeMismatch(Int8.self, context)
        }
    }

    func decode(_ type: Int16.Type) throws -> Int16 {
        do {
            return Int16(try Int32(bsonBytes: contents))
        } catch Int32.Error.sizeMismatch {
            let context = DecodingError.Context(
                codingPath: codingPath, 
                debugDescription: "expected 4 bytes, but found \(contents.count)",
                underlyingError: Int32.Error.sizeMismatch)
            throw DecodingError.typeMismatch(Int16.self, context)
        }
    }

    func decode(_ type: Int32.Type) throws -> Int32 {
        do {
            return try type.init(bsonBytes: contents)
        } catch Int32.Error.sizeMismatch {
            let context = DecodingError.Context(
                codingPath: codingPath, 
                debugDescription: "expected 4 bytes, but found \(contents.count)",
                underlyingError: Int32.Error.sizeMismatch)
            throw DecodingError.typeMismatch(Int32.self, context)
        }
    }

    func decode(_ type: Int64.Type) throws -> Int64 {
        do {
            return try type.init(bsonBytes: contents)
        } catch Int64.Error.sizeMismatch {
            let context = DecodingError.Context(
                codingPath: codingPath, 
                debugDescription: "expected 8 bytes, but found \(contents.count)",
                underlyingError: Int64.Error.sizeMismatch)
            throw DecodingError.typeMismatch(Int64.self, context)
        }
    }

    func decode(_ type: UInt.Type) throws -> UInt {
        do {
            return UInt(try UInt64(bsonBytes: contents))
        } catch UInt64.Error.sizeMismatch {
            let context = DecodingError.Context(
                codingPath: codingPath, 
                debugDescription: "expected 8 bytes, but found \(contents.count)",
                underlyingError: UInt64.Error.sizeMismatch)
            throw DecodingError.typeMismatch(UInt.self, context)
        }
    }

    func decode(_ type: UInt8.Type) throws -> UInt8 {
        do {
            return UInt8(try UInt64(bsonBytes: contents))
        } catch UInt64.Error.sizeMismatch {
            let context = DecodingError.Context(
                codingPath: codingPath, 
                debugDescription: "expected 8 bytes, but found \(contents.count)",
                underlyingError: UInt64.Error.sizeMismatch)
            throw DecodingError.typeMismatch(UInt8.self, context)
        }
    }

    func decode(_ type: UInt16.Type) throws -> UInt16 {
        do {
            return UInt16(try UInt64(bsonBytes: contents))
        } catch UInt64.Error.sizeMismatch {
            let context = DecodingError.Context(
                codingPath: codingPath, 
                debugDescription: "expected 8 bytes, but found \(contents.count)",
                underlyingError: UInt64.Error.sizeMismatch)
            throw DecodingError.typeMismatch(UInt16.self, context)
        }
    }

    func decode(_ type: UInt32.Type) throws -> UInt32 {
        do {
            return UInt32(try UInt64(bsonBytes: contents))
        } catch UInt64.Error.sizeMismatch {
            let context = DecodingError.Context(
                codingPath: codingPath, 
                debugDescription: "expected 8 bytes, but found \(contents.count)",
                underlyingError: UInt64.Error.sizeMismatch)
            throw DecodingError.typeMismatch(UInt32.self, context)
        }
    }

    func decode(_ type: UInt64.Type) throws -> UInt64 {
        do {
            return try type.init(bsonBytes: contents)
        } catch UInt64.Error.sizeMismatch {
            let context = DecodingError.Context(
                codingPath: codingPath, 
                debugDescription: "expected 8 bytes, but found \(contents.count)",
                underlyingError: UInt64.Error.sizeMismatch)
            throw DecodingError.typeMismatch(UInt64.self, context)
        }
    }

    func decode<T>(_ type: T.Type) throws -> T where T : Decodable {
        let decoder = DecodingContainerProvider(encodedValue: contents, codingPath: codingPath)
        return try T(from: decoder)
    }
}
