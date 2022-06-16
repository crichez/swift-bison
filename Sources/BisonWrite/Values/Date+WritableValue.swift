//
//  Date+WritableValue.swift
//
//
//  Created by Christopher Richez on May 26 2022
//

import Foundation

extension Date: WritableValue {
    public var bsonType: UInt8 { 9 }
    public var bsonBytes: [UInt8] { 
        let seconds = timeIntervalSince1970
        let milliseconds = seconds * 1000
        return Int64(milliseconds).bsonBytes
    }
}