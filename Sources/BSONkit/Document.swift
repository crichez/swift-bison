//
//
//
//
//
//

/// A BSON document that can be encoded into its binary representation.
struct Document<T: BinaryConvertible>: ValueProtocol {
    /// The contents of this document.
    let body: T
    
    /// Initializes a `Document` from a `DocBuilder` declaration.
    init(@DocBuilder body: () -> T) {
        self.body = body()
    }
    
    func encode() throws -> Chain3<Int32.Encoded, T.Encoded, CollectionOfOne<UInt8>> {
        let encodedBody = try body.encode()
        return Chain3(
            s0: try Int32(encodedBody.count + 5).encode(),
            s1: encodedBody,
            s2: CollectionOfOne(UInt8(0)))
    }

    var type: CollectionOfOne<UInt8> { 
        CollectionOfOne(3)
    }
}
