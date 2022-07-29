//
//  UUID+WritableValue.swift
//
//
//  Created by Christopher Richez on April 14 2022
//

import Foundation

extension UUID: WritableValue {
    public var bsonType: UInt8 {
        0x05
    }

    public func append<Doc>(to document: inout Doc)
    where Doc : RangeReplaceableCollection, Doc.Element == UInt8 {
        Int32(16).append(to: &document)
        document.append(0x04)
        withUnsafeBytes(of: self) { bytes in 
            document.append(contentsOf: bytes)
        }
    }
}