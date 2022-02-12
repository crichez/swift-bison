//
//
//
//
//
//

struct Tuple8<T0, T1, T2, T3, T4, T5, T6, T7>: BinaryConvertible
where T0 : BinaryConvertible, T1 : BinaryConvertible, T2 : BinaryConvertible, 
      T3 : BinaryConvertible, T4 : BinaryConvertible, T5 : BinaryConvertible,
      T6 : BinaryConvertible, T7 : BinaryConvertible {
    let t0: T0
    let t1: T1
    let t2: T2
    let t3: T3
    let t4: T4
    let t5: T5
    let t6: T6
    let t7: T7

    init(_ t0: T0, _ t1: T1, _ t2: T2, _ t3: T3, _ t4: T4, _ t5: T5, _ t6: T6, _ t7: T7) {
        self.t0 = t0
        self.t1 = t1
        self.t2 = t2
        self.t3 = t3
        self.t4 = t4
        self.t5 = t5
        self.t6 = t6
        self.t7 = t7
    }

    typealias Encoded = Chain8<
        T0.Encoded, 
        T1.Encoded, 
        T2.Encoded, 
        T3.Encoded, 
        T4.Encoded, 
        T5.Encoded, 
        T6.Encoded,
        T7.Encoded
    >

    func encode() throws -> Encoded {
        try Chain8(t0, t1, t2, t3, t4, t5, t6, t7)
    }
}
