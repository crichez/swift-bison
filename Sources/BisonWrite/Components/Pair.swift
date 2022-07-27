//
//  Pair.swift
//  Pair
//
//  Created by Christopher Richez on March 1 2022
//

/// A key-value pair used to compose a BSON document.
/// 
/// To create a `Pair`, use the `=>` operator on a `String` and a `WritableValue` conforming value:
/// ```swift
/// let doc = WritableDoc {
///     "key" => "value"
/// }
/// ```
public struct Pair<T: WritableValue>: DocComponent {
    let key: String
    let value: T
    
    public func append<Doc>(to document: inout Doc)
    where Doc : RangeReplaceableCollection, Doc.Element == UInt8 {
        document.append(value.bsonType)
        document.append(contentsOf: key.utf8)
        document.append(0)
        value.append(to: &document)
    }
}
