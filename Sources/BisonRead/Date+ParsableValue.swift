//
//  Date+ParsableValue.swift
//
//
//  Created by Christopher Richez on May 26, 2022
//

import Foundation

extension Date: ParsableValue {
    public init<Data: Collection>(bsonBytes data: Data) throws where Data.Element == UInt8 {
        self = Date(timeIntervalSince1970: Double(try Int64(bsonBytes: data)) / 1000)
    }
}