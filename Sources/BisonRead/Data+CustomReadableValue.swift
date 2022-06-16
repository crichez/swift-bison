//
//  Data+ReadableValue.swift
//  
//
//  Created by Christopher Richez on 4/28/22.
//

import Foundation

extension Data: CustomReadableValue {
    public init<Data: Collection>(bsonValueBytes: Data) throws where Data.Element == UInt8 {
        self.init(bsonValueBytes)
    }
}
