//
//  File.swift
//  
//
//  Created by Christopher Richez on 4/28/22.
//

import Foundation

extension UUID: CustomReadableValue {
    public init<Data: Collection>(bsonValueBytes: Data) throws where Data.Element == UInt8 {
        guard bsonValueBytes.count == 16 else {
            throw ValueParseError.sizeMismatch(16, bsonValueBytes.count)
        }
        let copyBuffer = UnsafeMutableRawBufferPointer.allocate(byteCount: 16, alignment: 1)
        copyBuffer.copyBytes(from: bsonValueBytes)
        self = copyBuffer.load(as: UUID.self)
    }
}
