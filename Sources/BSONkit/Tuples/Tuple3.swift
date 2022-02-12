//
//
//
//
//
//

struct Tuple3<T0, T1, T2>: BinaryConvertible
where T0 : BinaryConvertible, T1 : BinaryConvertible, T2 : BinaryConvertible {
    let t0: T0
    let t1: T1
    let t2: T2

    init(_ t0: T0, _ t1: T1, _ t2: T2) {
        self.t0 = t0
        self.t1 = t1
        self.t2 = t2
    }

    typealias Encoded = Chain3<T0.Encoded, T1.Encoded, T2.Encoded>

    func encode() throws -> Encoded {
        try Chain3(t0, t1, t2)
    }
}
