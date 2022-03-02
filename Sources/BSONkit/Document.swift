//
//
//
//
//
//

/// A BSON document that can be encoded into its binary representation.
struct Document<T: DocComponent>: ValueProtocol {
    /// The contents of this document.
    let body: T
    
    /// Initializes a `Document` from a `DocBuilder` declaration.
    init(@DocBuilder body: () throws -> T) rethrows {
        self.body = try body()
    }
    
    var bsonEncoded: Chain3<Int32.Encoded, T.Encoded, CollectionOfOne<UInt8>> {
        let encodedBody = body.bsonEncoded
        return Chain3(
            s0: Int32(encodedBody.count + 5).bsonEncoded,
            s1: encodedBody,
            s2: CollectionOfOne(UInt8(0)))
    }

    var type: CollectionOfOne<UInt8> { 
        CollectionOfOne(3)
    }
}
