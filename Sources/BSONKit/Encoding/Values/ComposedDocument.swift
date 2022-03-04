//
//  Document.swift
//  Document
//
//  Created by Christopher Richez on March 1 2022
//

/// A BSON document used exclusively for encoding.
public struct ComposedDocument<Body: DocComponent> {
    /// The contents of this document.
    let body: Body
    
    /// Initializes a `Document` from the provided components.
    public init(@DocBuilder body: () throws -> Body) rethrows {
        self.body = try body()
    }
}

extension ComposedDocument: ValueProtocol {
    public var bsonEncoded: Chain3<Int32.Encoded, Body.Encoded, CollectionOfOne<UInt8>> {
        let encodedBody = body.bsonEncoded
        return Chain3(
            s0: Int32(encodedBody.count + 5).bsonEncoded,
            s1: encodedBody,
            s2: CollectionOfOne(UInt8(0)))
    }

    public var type: CollectionOfOne<UInt8> { 
        CollectionOfOne(3)
    }
}
