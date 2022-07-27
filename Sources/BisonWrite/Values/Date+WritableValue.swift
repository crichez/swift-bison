//
//  Date+WritableValue.swift
//
//
//  Created by Christopher Richez on May 26 2022
//

import Foundation

extension Date: WritableValue {
    public var bsonType: UInt8 { 
        0x09 
    }

    public func append<Doc>(to document: inout Doc)
    where Doc : RangeReplaceableCollection, Doc.Element == UInt8 { 
        let seconds = timeIntervalSince1970
        let milliseconds = seconds * 1000
        Int64(milliseconds).append(to: &document)
    }
}