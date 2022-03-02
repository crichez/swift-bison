//
//  Group.swift
//  Group
//
//  Created by Christopher Richez on March 1 2022
//

/// A group of `DocComponent` values.
/// 
/// Use `Group` when you need to assign more than 10 key-value pairs in a document or
/// `DocBuilder` declaration. Grouping document components does not affect the structure of the
/// encoded document.
public struct Group<T: DocComponent>: DocComponent {
    let content: T

    /// Groups the provided document components into a single document component.
    public init(@DocBuilder content: () throws -> T) rethrows {
        self.content = try content()
    }

    public var bsonEncoded: T.Encoded {
        content.bsonEncoded
    }
}