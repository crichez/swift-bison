//
//  ObjectID+WritableValue.swift
//
//
//  Created by Christopher Richez on April 16 2022
//

import ObjectID
import Foundation

extension ObjectID: WritableValue {
    public var bsonType: UInt8 { 7 }
    public var bsonBytes: Data { withUnsafeBytes(of: self) { Data($0) } }
}
