//
//  Pair.swift
//  Pair
//
//  Created by Christopher Richez on March 1 2022
//

/// Use `Pair` to assign a key to a value that conforms to `ValueProtocol`.
/// 
/// To create a `Pair`, use the `=>` operator on a `String` and `ValueProtocol` value:
/// ```swift
/// let doc = Document {
///     "key" => "value"
/// }
/// ```
public struct Pair<T> where T : ValueProtocol {
    /// The name of the key to assigned to `value`.
    public let name: String

    /// The value to assign to the key named `name`.
    public let value: T
}

extension Pair: DocComponent {
    public typealias Encoded = Chain4<
        CollectionOfOne<UInt8>, 
        String.UTF8View, 
        CollectionOfOne<UInt8>, 
        T.Encoded
    >

    public var bsonEncoded: Encoded {
        Chain4(s0: value.type, s1: name.utf8, s2: CollectionOfOne(0), s3: value.bsonEncoded)
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
        Pair(name: key, value: value)
    } 
}