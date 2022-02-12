//
//
//
//
//
//

struct Tuple4<T0, T1, T2, T3>: BinaryConvertible
where T0 : BinaryConvertible, T1 : BinaryConvertible, 
      T2 : BinaryConvertible, T3 : BinaryConvertible {
    let t0: T0
    let t1: T1
    let t2: T2
    let t3: T3

    init(_ t0: T0, _ t1: T1, _ t2: T2, _ t3: T3) {
        self.t0 = t0
        self.t1 = t1
        self.t2 = t2
        self.t3 = t3
    }

    typealias Encoded = Chain4<T0.Encoded, T1.Encoded, T2.Encoded, T3.Encoded>

    func encode() throws -> Encoded {
        try Chain4(t0, t1, t2, t3)
    }
}
