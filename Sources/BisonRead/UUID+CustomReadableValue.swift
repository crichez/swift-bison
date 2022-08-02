//
//  UUID+CustomReadableValue.swift
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

import Foundation

extension UUID: CustomReadableValue {
    public init<Data: Collection>(bsonValueBytes: Data) throws where Data.Element == UInt8 {
        guard bsonValueBytes.count == 16 else {
            throw ValueError.sizeMismatch(expected: 16, have: bsonValueBytes.count)
        }
        let copyBuffer = UnsafeMutableRawBufferPointer.allocate(byteCount: 16, alignment: 1)
        copyBuffer.copyBytes(from: bsonValueBytes)
        self = copyBuffer.load(as: UUID.self)
    }
}
