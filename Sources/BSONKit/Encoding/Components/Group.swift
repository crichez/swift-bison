//
//  Group.swift
//  Group
//
//  Created by Christopher Richez on March 1 2022
//

/// A group of document components values.
/// 
/// Use a `Group` when you need to declare more than 10 components in a document.
/// Grouping document components does not affect the structure of the final document.
public struct Group<Body: DocComponent>: DocComponent {
    /// The components in this `Group`.
    let body: Body

    /// Groups the provided document components into a single document component.
    ///
    /// Use a `Group` when you need to declare more than 10 components in a document.
    /// Grouping document components does not affect the structure of the final document.
    ///
    /// - Throws:
    /// Rethrows any errors thrown in ``body``.
    ///
    /// - Parameter body: the document components to group
    public init(@DocBuilder body: @escaping () throws -> Body) rethrows {
        self.body = try body()
    }

    public var bsonBytes: [UInt8] {
        body.bsonBytes
    }
}
