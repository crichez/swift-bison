//
//  ArrayDocBuilder.swift
//
//
//  Created by Christopher Richez on July 29th 2022.
//

extension Array: DocComponent where Element == WritableValue {
    public func append<Doc>(to document: inout Doc) 
    where Doc : RangeReplaceableCollection, Doc.Element == UInt8 {
        for (index, value) in self.enumerated() {
            document.append(value.bsonType)
            document.append(contentsOf: String(index).utf8)
            document.append(0)
            value.append(to: &document)
        }
    }
}

/// A result builder used to declare the structure of an integer-keyed BSON document.
/// 
/// > Note: You won't usually interact with the `ArrayDocBuilder` type directly. You do so 
///   implicitly when initializing a ``WritableArray``. See that documentation for more details.
/// 
@resultBuilder public struct ArrayDocBuilder {
    public static func buildExpression(_ expression: WritableValue) -> Array<WritableValue> {
        [expression]
    }

    public static func buildBlock(_ components: [WritableValue]...) -> [WritableValue] {
        Array(components.joined())
    }

    public static func buildEither<S: Sequence>(first component: S) -> S
    where S.Element == WritableValue {
        component
    }

    public static func buildEither<S: Sequence>(second component: S) -> S 
    where S.Element == WritableValue {
        component
    }

    public static func buildLimitedAvailability(_ component: [WritableValue]) -> [WritableValue] {
        component
    }

    public static func buildArray(_ components: [[WritableValue]]) -> [WritableValue] {
        Array(components.joined())
    }
}