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
    
    public var bsonEncoded: [UInt8] {
        // Copy the key bytes
        let keyCodeUnits = key.utf8
        var pairBytes: [UInt8] = []
        pairBytes.reserveCapacity(key.count + 2)
        pairBytes.append(contentsOf: value.type)
        pairBytes.append(contentsOf: keyCodeUnits)
        pairBytes.append(0)
        
        // Copy the value bytes
        let valueBytes = value.bsonEncoded
        pairBytes.reserveCapacity(valueBytes.count)
        pairBytes.append(contentsOf: valueBytes)
        
        // Return the encoded pair
        return pairBytes
    }
}

/// An operator used to assign a BSON `String` key to a `ValueProtocol` conforming value.
infix operator => : AssignmentPrecedence

extension String {
    /// Returns a BSON key-value `Pair` using the provided key and value.
    /// 
    /// - Parameters:
    ///     - key: a `String` key
    ///     - value: a `ValueProtocol` conforming value
    /// 
    /// - Returns:
    /// A `Pair` value constructed from the provided key and value.
    public static func => <T: ValueProtocol>(key: String, value: T) -> Pair<T> {
        Pair(key: key, value: value)
    } 
}
