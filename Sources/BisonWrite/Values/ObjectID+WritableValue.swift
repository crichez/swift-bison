//
//  ObjectID+WritableValue.swift
//
//
//  Created by Christopher Richez on April 16 2022
//

import ObjectID

extension ObjectID: WritableValue {
    public var bsonType: UInt8 { 
        0x07 
    }

    public func append<Doc>(to document: inout Doc)
    where Doc : RangeReplaceableCollection, Doc.Element == UInt8 { 
        withUnsafeBytes(of: self) { bytes in
            document.append(contentsOf: bytes)
        }
    }
}
