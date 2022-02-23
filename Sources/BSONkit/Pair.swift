//
//
//
//
//
//

struct Pair<T>: BinaryConvertible where T : ValueProtocol {
    let name: String
    let value: T

    typealias Encoded = Chain4<
        CollectionOfOne<UInt8>, 
        String.UTF8View, 
        CollectionOfOne<UInt8>, 
        T.Encoded
    >

    func encode() throws -> Encoded {
        Chain4(
            s0: value.type, 
            s1: name.utf8, 
            s2: CollectionOfOne<UInt8>(0x00), 
            s3: try value.encode()
        )
    }
}

infix operator => : AssignmentPrecedence

extension String {
    static func => <T: ValueProtocol>(key: String, value: T) -> Pair<T> {
        Pair(name: key, value: value)
    } 
}