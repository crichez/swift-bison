//
//  =>.swift
//  
//
//  Created by Christopher Richez on 3/16/22.
//

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
