//
//  Tuples.swift
//
//
//  Created by Christopher Richez on February 11 2022
//

struct Tuple2<T0: BinaryConvertible, T1: BinaryConvertible>: BinaryConvertible {
    let t0: T0
    let t1: T1

    init(_ t0: T0, _ t1: T1) {
        self.t0 = t0
        self.t1 = t1
    }

    typealias Encoded = Chain2<T0.Encoded, T1.Encoded>

    func encode() throws -> Encoded {
        try Chain2(t0, t1)
    }
}
