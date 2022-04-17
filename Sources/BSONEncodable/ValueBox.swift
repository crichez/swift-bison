//
//  ValueBox.swift
//
//
//  Created by Christopher Richez on March 31 2022
//

import BSONCompose

/// A box around a value conforming to `ValueProtocol`.
struct ValueBox {
    /// The value in this box.
    let value: ValueProtocol

    /// Boxes the provided value.
    init<T: ValueProtocol>(_ value: T) {
        self.value = value
    }

    /// Boxes the provided existential value.
    init(_ value: ValueProtocol) {
        self.value = value
    }
}

extension ValueBox: ValueProtocol {
    var bsonBytes: [UInt8] {
        value.bsonBytes
    }

    var bsonType: UInt8 {
        value.bsonType
    }
}
