//
//
//
//
//
//

struct Tuple3<T1, T2, T3>: BinaryConvertible
where T1 : BinaryConvertible, T2 : BinaryConvertible, T3 : BinaryConvertible {
    let one: T1
    let two: T2
    let three: T3

    typealias Encoded = Chain3<T1.Encoded, T2.Encoded, T3.Encoded>

    func encode() throws -> Encoded {
        Chain3(one: try one.encode(), two: try two.encode(), three: try three.encode())
    }
}
