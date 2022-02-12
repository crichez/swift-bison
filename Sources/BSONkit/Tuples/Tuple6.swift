//
//
//
//
//
//

struct Tuple6<T0, T1, T2, T3, T4, T5>: BinaryConvertible
where T0 : BinaryConvertible, T1 : BinaryConvertible, T2 : BinaryConvertible, 
      T3 : BinaryConvertible, T4 : BinaryConvertible, T5 : BinaryConvertible {
    let t0: T0
    let t1: T1
    let t2: T2
    let t3: T3
    let t4: T4
    let t5: T5

    init(_ t0: T0, _ t1: T1, _ t2: T2, _ t3: T3, _ t4: T4, _ t5: T5) {
        self.t0 = t0
        self.t1 = t1
        self.t2 = t2
        self.t3 = t3
        self.t4 = t4
        self.t5 = t5
    }

    typealias Encoded = Chain6<T0.Encoded, T1.Encoded, T2.Encoded, T3.Encoded, T4.Encoded, T5.Encoded>

    func encode() throws -> Encoded {
        try Chain6(t0, t1, t2, t3, t4, t5)
    }
}
