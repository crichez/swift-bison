//
//  Tuples.swift
//
//
//  Created by Christopher Richez on February 11 2022
//

struct Tuple2<T1: BinaryConvertible, T2: BinaryConvertible>: BinaryConvertible {
    let one: T1
    let two: T2

    typealias Encoded = Chain2<T1.Encoded, T2.Encoded>

    func encode() throws -> Encoded {
        Chain2(one: try one.encode(), two: try two.encode())
    }
}
