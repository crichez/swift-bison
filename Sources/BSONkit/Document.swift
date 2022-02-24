//
//
//
//
//
//

struct Document<T: BinaryConvertible>: BinaryConvertible {
    typealias Encoded = Chain3<Int32.Encoded, T.Encoded, CollectionOfOne<UInt8>>

    let body: T

    init(@DocBuilder body: () -> T) {
        self.body = body()
    }

    func encode() throws -> Encoded {
        let encodedBody = try body.encode()
        let size = Int32(encodedBody.count + 5)
        return Chain3(s0: try size.encode(), s1: encodedBody, s2: CollectionOfOne<UInt8>(0))
    }
}