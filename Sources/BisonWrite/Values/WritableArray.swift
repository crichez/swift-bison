//
//  WritableArray.swift
//
//
//  Created by Christopher Richez on March 31 2022
//

/// A BSON document used exclusively for encoding.
public struct WritableArray<Body: DocComponent> {
    /// The contents of this document.
    let body: Body
    
    /// Initializes a `Document` from the provided components.
    public init(@DocBuilder body: @escaping () throws -> Body) rethrows {
        self.body = try body()
    }
}

extension WritableArray: WritableValue {
    public var bsonBytes: [UInt8] {
        let encodedBody = body.bsonBytes + [0]
        let encodedSize = Int32(encodedBody.count + 4).bsonBytes
        return encodedSize + encodedBody
    }

    public var bsonType: UInt8 {
        0x04
    }
}
