//
//
//
//
//
//

struct Group<T: BinaryConvertible>: BinaryConvertible {
    typealias Encoded = T.Encoded

    let content: T

    init(@DocBuilder content: () -> T) {
        self.content = content()
    }

    func encode() throws -> Encoded {
        try content.encode()
    }
}