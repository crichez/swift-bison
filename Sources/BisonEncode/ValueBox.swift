//
//  ValueBox.swift
//
//
//  Created by Christopher Richez on March 31 2022
//

import BisonWrite
import Foundation

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
    var bsonBytes: Data {
        value.bsonBytes
    }

    var bsonType: UInt8 {
        value.bsonType
    }
}
