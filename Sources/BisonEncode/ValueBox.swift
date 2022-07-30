//
//  ValueBox.swift
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

import BisonWrite

/// A box around a value conforming to `WritableValue`.
struct ValueBox {
    /// The value in this box.
    let value: WritableValue

    /// Boxes the provided value.
    init<T: WritableValue>(_ value: T) {
        self.value = value
    }

    /// Boxes the provided existential value.
    init(_ value: WritableValue) {
        self.value = value
    }
}

extension ValueBox: WritableValue {
    func append<Doc>(to document: inout Doc)
    where Doc : RangeReplaceableCollection, Doc.Element == UInt8 {
        value.append(to: &document)
    }

    var bsonType: UInt8 {
        value.bsonType
    }
}
