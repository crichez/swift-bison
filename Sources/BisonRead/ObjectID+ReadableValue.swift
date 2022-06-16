//
//  ObjectID+ReadableValue.swift
//
//
//  Created by Christopher Richez on April 16 2022
//

import ObjectID

extension ObjectID: ReadableValue {
    public init<Data>(bsonBytes data: Data) throws where Data : Collection, Data.Element == UInt8 {
        guard data.count == 12 else { throw ValueParseError.sizeMismatch(12, data.count) }
        let copyBuffer = UnsafeMutableRawBufferPointer.allocate(byteCount: 12, alignment: 1)
        copyBuffer.copyBytes(from: data)
        self = copyBuffer.load(as: ObjectID.self)
    }
}
