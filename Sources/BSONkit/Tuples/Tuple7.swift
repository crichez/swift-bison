//
//  Tuple7.swift
//
//
//  Created by Christopher Richez on February 11 2022
//

struct Tuple7<T1, T2, T3, T4, T5, T6, T7>: BinaryConvertible
where T1 : BinaryConvertible, T2 : BinaryConvertible, T3 : BinaryConvertible, 
      T4 : BinaryConvertible, T5 : BinaryConvertible, T6 : BinaryConvertible,
      T7 : BinaryConvertible {
    let one: T1
    let two: T2
    let three: T3
    let four: T4
    let five: T5
    let six: T6
    let seven: T7

    typealias Encoded = Chain7<T1.Encoded, T2.Encoded, T3.Encoded, T4.Encoded, T5.Encoded, T6.Encoded, T7.Encoded>

    func encode() throws -> Encoded {
        Chain7(
            one: try one.encode(), 
            two: try two.encode(), 
            three: try three.encode(),
            four: try four.encode(),
            five: try five.encode(),
            six: try six.encode(),
            seven: try seven.encode())
    }
}
