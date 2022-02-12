//
//
//
//
//
//


struct Tuple10<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10>: BinaryConvertible
where T1 : BinaryConvertible, T2 : BinaryConvertible, T3 : BinaryConvertible, 
      T4 : BinaryConvertible, T5 : BinaryConvertible, T6 : BinaryConvertible,
      T7 : BinaryConvertible, T8 : BinaryConvertible, T9 : BinaryConvertible,
      T10 : BinaryConvertible {
    let one: T1
    let two: T2
    let three: T3
    let four: T4
    let five: T5
    let six: T6
    let seven: T7
    let eight: T8
    let nine: T9
    let ten: T10

    typealias Encoded = Chain10<T1.Encoded, T2.Encoded, T3.Encoded, T4.Encoded, T5.Encoded, T6.Encoded, T7.Encoded, T8.Encoded, T9.Encoded, T10.Encoded>

    func encode() throws -> Encoded {
        Chain10(
            one: try one.encode(), 
            two: try two.encode(), 
            three: try three.encode(),
            four: try four.encode(),
            five: try five.encode(),
            six: try six.encode(),
            seven: try seven.encode(),
            eight: try eight.encode(),
            nine: try nine.encode(),
            ten: try ten.encode())
    }
}
