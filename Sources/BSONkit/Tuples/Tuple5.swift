//
//
//
//
//
//

struct Tuple5<T1, T2, T3, T4, T5>: BinaryConvertible
where T1 : BinaryConvertible, T2 : BinaryConvertible, T3 : BinaryConvertible, 
      T4 : BinaryConvertible, T5 : BinaryConvertible {
    let one: T1
    let two: T2
    let three: T3
    let four: T4
    let five: T5

    typealias Encoded = Chain5<T1.Encoded, T2.Encoded, T3.Encoded, T4.Encoded, T5.Encoded>

    func encode() throws -> Encoded {
        Chain5(
            one: try one.encode(), 
            two: try two.encode(), 
            three: try three.encode(),
            four: try four.encode(),
            five: try five.encode())
    }
}
