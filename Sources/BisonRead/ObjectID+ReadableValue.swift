//
//  ObjectID+ReadableValue.swift
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

import ObjectID

extension ObjectID: ReadableValue {
    public init<Data>(bsonBytes data: Data) throws where Data : Collection, Data.Element == UInt8 {
        guard data.count == 12 else { 
            throw ValueError.sizeMismatch(expected: 12, have: data.count) 
        }
        let copyBuffer = UnsafeMutableRawBufferPointer.allocate(byteCount: 12, alignment: 1)
        copyBuffer.copyBytes(from: data)
        self = copyBuffer.load(as: ObjectID.self)
    }
}
