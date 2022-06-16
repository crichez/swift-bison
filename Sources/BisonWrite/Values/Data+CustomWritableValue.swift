//
//  Data+CustomWritableValue.swift
//
//
//  Created by Christopher Richez on April 14 2022
//

import Foundation

extension Data: CustomWritableValue {
    public var bsonSubtype: UInt8 {
        0
    }

    public var bsonValueBytes: [UInt8] {
        Array(self)
    }
}