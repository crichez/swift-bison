//
//  Data+WritableValue.swift
//
//
//  Created by Christopher Richez on April 14 2022
//

import Foundation

extension Data: WritableValue {
    public var bsonType: UInt8 {
        0x05
    }

    public func append<Doc>(to document: inout Doc) 
    where Doc : RangeReplaceableCollection, Doc.Element == UInt8 {
        guard let size = Int32(exactly: count) else { fatalError("data too long") }
        document.reserveCapacity(count + 5)
        size.append(to: &document)
        document.append(0)
        document.append(contentsOf: self)
    }
}