//
//  Pair.swift
//  Pair
//
//  Created by Christopher Richez on March 1 2022
//

/// A key-value pair used to compose a BSON document.
/// 
/// To create a `Pair`, use the `=>` operator on a `String` and a `ValueProtocol` conforming value:
/// ```swift
/// let doc = ComposedDocument {
///     "key" => "value"
/// }
/// ```
public struct Pair<T: ValueProtocol>: DocComponent {
    let key: String
    let value: T
    
    public var bsonBytes: [UInt8] {
        // Copy the key bytes
        let keyCodeUnits = key.utf8
        var pairBytes: [UInt8] = []
        pairBytes.reserveCapacity(key.count + 2)
        pairBytes.append(value.bsonType)
        pairBytes.append(contentsOf: keyCodeUnits)
        pairBytes.append(0)
        
        // Copy the value bytes
        let valueBytes = value.bsonBytes
        pairBytes.reserveCapacity(valueBytes.count)
        pairBytes.append(contentsOf: valueBytes)
        
        // Return the encoded pair
        return pairBytes
    }
}
