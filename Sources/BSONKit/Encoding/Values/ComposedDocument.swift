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
    public init(@DocBuilder body: @escaping () throws -> Body) rethrows {
        self.body = try body()
    }
}

extension ComposedDocument: ValueProtocol {
    public var bsonBytes: [UInt8] {
        let encodedBody = body.bsonBytes + [0]
        let encodedSize = Int32(encodedBody.count + 4).bsonBytes
        return encodedSize + encodedBody
    }

    public var bsonType: UInt8 {
        0x03
    }
}
