// Generated using Sourcery 1.6.1 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT


extension Tuple10: BinaryConvertible 
where T0: BinaryConvertible, T1: BinaryConvertible, T2: BinaryConvertible, T3: BinaryConvertible, T4: BinaryConvertible, T5: BinaryConvertible, T6: BinaryConvertible, T7: BinaryConvertible, T8: BinaryConvertible, T9: BinaryConvertible {
    typealias Encoded = Chain10<T0.Encoded, T1.Encoded, T2.Encoded, T3.Encoded, T4.Encoded, T5.Encoded, T6.Encoded, T7.Encoded, T8.Encoded, T9.Encoded>

    func encode() throws -> Encoded {
        Chain10(s0: try t0.encode(), s1: try t1.encode(), s2: try t2.encode(), s3: try t3.encode(), s4: try t4.encode(), s5: try t5.encode(), s6: try t6.encode(), s7: try t7.encode(), s8: try t8.encode(), s9: try t9.encode())
    }

    init(_ t0: T0,_ t1: T1,_ t2: T2,_ t3: T3,_ t4: T4,_ t5: T5,_ t6: T6,_ t7: T7,_ t8: T8,_ t9: T9) {
        self.t0 = t0
        self.t1 = t1
        self.t2 = t2
        self.t3 = t3
        self.t4 = t4
        self.t5 = t5
        self.t6 = t6
        self.t7 = t7
        self.t8 = t8
        self.t9 = t9
    }
}

extension Tuple2: BinaryConvertible 
where T0: BinaryConvertible, T1: BinaryConvertible {
    typealias Encoded = Chain2<T0.Encoded, T1.Encoded>

    func encode() throws -> Encoded {
        Chain2(s0: try t0.encode(), s1: try t1.encode())
    }

    init(_ t0: T0,_ t1: T1) {
        self.t0 = t0
        self.t1 = t1
    }
}

extension Tuple3: BinaryConvertible 
where T0: BinaryConvertible, T1: BinaryConvertible, T2: BinaryConvertible {
    typealias Encoded = Chain3<T0.Encoded, T1.Encoded, T2.Encoded>

    func encode() throws -> Encoded {
        Chain3(s0: try t0.encode(), s1: try t1.encode(), s2: try t2.encode())
    }

    init(_ t0: T0,_ t1: T1,_ t2: T2) {
        self.t0 = t0
        self.t1 = t1
        self.t2 = t2
    }
}

extension Tuple4: BinaryConvertible 
where T0: BinaryConvertible, T1: BinaryConvertible, T2: BinaryConvertible, T3: BinaryConvertible {
    typealias Encoded = Chain4<T0.Encoded, T1.Encoded, T2.Encoded, T3.Encoded>

    func encode() throws -> Encoded {
        Chain4(s0: try t0.encode(), s1: try t1.encode(), s2: try t2.encode(), s3: try t3.encode())
    }

    init(_ t0: T0,_ t1: T1,_ t2: T2,_ t3: T3) {
        self.t0 = t0
        self.t1 = t1
        self.t2 = t2
        self.t3 = t3
    }
}

extension Tuple5: BinaryConvertible 
where T0: BinaryConvertible, T1: BinaryConvertible, T2: BinaryConvertible, T3: BinaryConvertible, T4: BinaryConvertible {
    typealias Encoded = Chain5<T0.Encoded, T1.Encoded, T2.Encoded, T3.Encoded, T4.Encoded>

    func encode() throws -> Encoded {
        Chain5(s0: try t0.encode(), s1: try t1.encode(), s2: try t2.encode(), s3: try t3.encode(), s4: try t4.encode())
    }

    init(_ t0: T0,_ t1: T1,_ t2: T2,_ t3: T3,_ t4: T4) {
        self.t0 = t0
        self.t1 = t1
        self.t2 = t2
        self.t3 = t3
        self.t4 = t4
    }
}

extension Tuple6: BinaryConvertible 
where T0: BinaryConvertible, T1: BinaryConvertible, T2: BinaryConvertible, T3: BinaryConvertible, T4: BinaryConvertible, T5: BinaryConvertible {
    typealias Encoded = Chain6<T0.Encoded, T1.Encoded, T2.Encoded, T3.Encoded, T4.Encoded, T5.Encoded>

    func encode() throws -> Encoded {
        Chain6(s0: try t0.encode(), s1: try t1.encode(), s2: try t2.encode(), s3: try t3.encode(), s4: try t4.encode(), s5: try t5.encode())
    }

    init(_ t0: T0,_ t1: T1,_ t2: T2,_ t3: T3,_ t4: T4,_ t5: T5) {
        self.t0 = t0
        self.t1 = t1
        self.t2 = t2
        self.t3 = t3
        self.t4 = t4
        self.t5 = t5
    }
}

extension Tuple7: BinaryConvertible 
where T0: BinaryConvertible, T1: BinaryConvertible, T2: BinaryConvertible, T3: BinaryConvertible, T4: BinaryConvertible, T5: BinaryConvertible, T6: BinaryConvertible {
    typealias Encoded = Chain7<T0.Encoded, T1.Encoded, T2.Encoded, T3.Encoded, T4.Encoded, T5.Encoded, T6.Encoded>

    func encode() throws -> Encoded {
        Chain7(s0: try t0.encode(), s1: try t1.encode(), s2: try t2.encode(), s3: try t3.encode(), s4: try t4.encode(), s5: try t5.encode(), s6: try t6.encode())
    }

    init(_ t0: T0,_ t1: T1,_ t2: T2,_ t3: T3,_ t4: T4,_ t5: T5,_ t6: T6) {
        self.t0 = t0
        self.t1 = t1
        self.t2 = t2
        self.t3 = t3
        self.t4 = t4
        self.t5 = t5
        self.t6 = t6
    }
}

extension Tuple8: BinaryConvertible 
where T0: BinaryConvertible, T1: BinaryConvertible, T2: BinaryConvertible, T3: BinaryConvertible, T4: BinaryConvertible, T5: BinaryConvertible, T6: BinaryConvertible, T7: BinaryConvertible {
    typealias Encoded = Chain8<T0.Encoded, T1.Encoded, T2.Encoded, T3.Encoded, T4.Encoded, T5.Encoded, T6.Encoded, T7.Encoded>

    func encode() throws -> Encoded {
        Chain8(s0: try t0.encode(), s1: try t1.encode(), s2: try t2.encode(), s3: try t3.encode(), s4: try t4.encode(), s5: try t5.encode(), s6: try t6.encode(), s7: try t7.encode())
    }

    init(_ t0: T0,_ t1: T1,_ t2: T2,_ t3: T3,_ t4: T4,_ t5: T5,_ t6: T6,_ t7: T7) {
        self.t0 = t0
        self.t1 = t1
        self.t2 = t2
        self.t3 = t3
        self.t4 = t4
        self.t5 = t5
        self.t6 = t6
        self.t7 = t7
    }
}

extension Tuple9: BinaryConvertible 
where T0: BinaryConvertible, T1: BinaryConvertible, T2: BinaryConvertible, T3: BinaryConvertible, T4: BinaryConvertible, T5: BinaryConvertible, T6: BinaryConvertible, T7: BinaryConvertible, T8: BinaryConvertible {
    typealias Encoded = Chain9<T0.Encoded, T1.Encoded, T2.Encoded, T3.Encoded, T4.Encoded, T5.Encoded, T6.Encoded, T7.Encoded, T8.Encoded>

    func encode() throws -> Encoded {
        Chain9(s0: try t0.encode(), s1: try t1.encode(), s2: try t2.encode(), s3: try t3.encode(), s4: try t4.encode(), s5: try t5.encode(), s6: try t6.encode(), s7: try t7.encode(), s8: try t8.encode())
    }

    init(_ t0: T0,_ t1: T1,_ t2: T2,_ t3: T3,_ t4: T4,_ t5: T5,_ t6: T6,_ t7: T7,_ t8: T8) {
        self.t0 = t0
        self.t1 = t1
        self.t2 = t2
        self.t3 = t3
        self.t4 = t4
        self.t5 = t5
        self.t6 = t6
        self.t7 = t7
        self.t8 = t8
    }
}

