//
//  ObjectID+ParsableValue.swift
//
//
//  Created by Christopher Richez on April 16 2022
//

import BSONObjectID

extension ObjectID: ParsableValue {
    public enum Error: Swift.Error {
        /// The data passed to `init(bsonBytes:)` was not exactly 12 bytes long.
        case sizeMismatch
    }

    public init<Data>(bsonBytes data: Data) throws where Data : Collection, Data.Element == UInt8 {
        guard data.count == 12 else { throw Error.sizeMismatch }
        let copyBuffer = UnsafeMutableRawBufferPointer.allocate(byteCount: 12, alignment: 1)
        copyBuffer.copyBytes(from: data)
        self = copyBuffer.load(as: ObjectID.self)
    }
}
