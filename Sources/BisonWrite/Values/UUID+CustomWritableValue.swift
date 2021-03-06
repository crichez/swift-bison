//
//  UUID+CustomWritableValue.swift
//
//
//  Created by Christopher Richez on April 14 2022
//

import Foundation

extension UUID: CustomWritableValue {
    public var bsonSubtype: UInt8 {
        4
    }

    public var bsonValueBytes: [UInt8] {
        withUnsafeBytes(of: self) { bytes in 
            Array(bytes)
        }
    }
}