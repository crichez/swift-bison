//
//  ObjectID+ValueProtocol.swift
//
//
//  Created by Christopher Richez on April 16 2022
//

import ObjectID

extension ObjectID: ValueProtocol {
    public var bsonType: UInt8 { 7 }
    public var bsonBytes: [UInt8] { withUnsafeBytes(of: self) { Array($0) } }
}
