// Generated using Sourcery 1.6.1 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT


extension Tuple10: DocComponent 
where T0: DocComponent, T1: DocComponent, T2: DocComponent, T3: DocComponent, T4: DocComponent, T5: DocComponent, T6: DocComponent, T7: DocComponent, T8: DocComponent, T9: DocComponent {
    public typealias Encoded = Chain10<T0.Encoded, T1.Encoded, T2.Encoded, T3.Encoded, T4.Encoded, T5.Encoded, T6.Encoded, T7.Encoded, T8.Encoded, T9.Encoded>

    public var bsonEncoded: Encoded {
        Chain10(s0: t0.bsonEncoded, s1: t1.bsonEncoded, s2: t2.bsonEncoded, s3: t3.bsonEncoded, s4: t4.bsonEncoded, s5: t5.bsonEncoded, s6: t6.bsonEncoded, s7: t7.bsonEncoded, s8: t8.bsonEncoded, s9: t9.bsonEncoded)
    }

    public init(_ t0: T0,_ t1: T1,_ t2: T2,_ t3: T3,_ t4: T4,_ t5: T5,_ t6: T6,_ t7: T7,_ t8: T8,_ t9: T9) {
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

extension Tuple2: DocComponent 
where T0: DocComponent, T1: DocComponent {
    public typealias Encoded = Chain2<T0.Encoded, T1.Encoded>

    public var bsonEncoded: Encoded {
        Chain2(s0: t0.bsonEncoded, s1: t1.bsonEncoded)
    }

    public init(_ t0: T0,_ t1: T1) {
        self.t0 = t0
        self.t1 = t1
    }
}

extension Tuple3: DocComponent 
where T0: DocComponent, T1: DocComponent, T2: DocComponent {
    public typealias Encoded = Chain3<T0.Encoded, T1.Encoded, T2.Encoded>

    public var bsonEncoded: Encoded {
        Chain3(s0: t0.bsonEncoded, s1: t1.bsonEncoded, s2: t2.bsonEncoded)
    }

    public init(_ t0: T0,_ t1: T1,_ t2: T2) {
        self.t0 = t0
        self.t1 = t1
        self.t2 = t2
    }
}

extension Tuple4: DocComponent 
where T0: DocComponent, T1: DocComponent, T2: DocComponent, T3: DocComponent {
    public typealias Encoded = Chain4<T0.Encoded, T1.Encoded, T2.Encoded, T3.Encoded>

    public var bsonEncoded: Encoded {
        Chain4(s0: t0.bsonEncoded, s1: t1.bsonEncoded, s2: t2.bsonEncoded, s3: t3.bsonEncoded)
    }

    public init(_ t0: T0,_ t1: T1,_ t2: T2,_ t3: T3) {
        self.t0 = t0
        self.t1 = t1
        self.t2 = t2
        self.t3 = t3
    }
}

extension Tuple5: DocComponent 
where T0: DocComponent, T1: DocComponent, T2: DocComponent, T3: DocComponent, T4: DocComponent {
    public typealias Encoded = Chain5<T0.Encoded, T1.Encoded, T2.Encoded, T3.Encoded, T4.Encoded>

    public var bsonEncoded: Encoded {
        Chain5(s0: t0.bsonEncoded, s1: t1.bsonEncoded, s2: t2.bsonEncoded, s3: t3.bsonEncoded, s4: t4.bsonEncoded)
    }

    public init(_ t0: T0,_ t1: T1,_ t2: T2,_ t3: T3,_ t4: T4) {
        self.t0 = t0
        self.t1 = t1
        self.t2 = t2
        self.t3 = t3
        self.t4 = t4
    }
}

extension Tuple6: DocComponent 
where T0: DocComponent, T1: DocComponent, T2: DocComponent, T3: DocComponent, T4: DocComponent, T5: DocComponent {
    public typealias Encoded = Chain6<T0.Encoded, T1.Encoded, T2.Encoded, T3.Encoded, T4.Encoded, T5.Encoded>

    public var bsonEncoded: Encoded {
        Chain6(s0: t0.bsonEncoded, s1: t1.bsonEncoded, s2: t2.bsonEncoded, s3: t3.bsonEncoded, s4: t4.bsonEncoded, s5: t5.bsonEncoded)
    }

    public init(_ t0: T0,_ t1: T1,_ t2: T2,_ t3: T3,_ t4: T4,_ t5: T5) {
        self.t0 = t0
        self.t1 = t1
        self.t2 = t2
        self.t3 = t3
        self.t4 = t4
        self.t5 = t5
    }
}

extension Tuple7: DocComponent 
where T0: DocComponent, T1: DocComponent, T2: DocComponent, T3: DocComponent, T4: DocComponent, T5: DocComponent, T6: DocComponent {
    public typealias Encoded = Chain7<T0.Encoded, T1.Encoded, T2.Encoded, T3.Encoded, T4.Encoded, T5.Encoded, T6.Encoded>

    public var bsonEncoded: Encoded {
        Chain7(s0: t0.bsonEncoded, s1: t1.bsonEncoded, s2: t2.bsonEncoded, s3: t3.bsonEncoded, s4: t4.bsonEncoded, s5: t5.bsonEncoded, s6: t6.bsonEncoded)
    }

    public init(_ t0: T0,_ t1: T1,_ t2: T2,_ t3: T3,_ t4: T4,_ t5: T5,_ t6: T6) {
        self.t0 = t0
        self.t1 = t1
        self.t2 = t2
        self.t3 = t3
        self.t4 = t4
        self.t5 = t5
        self.t6 = t6
    }
}

extension Tuple8: DocComponent 
where T0: DocComponent, T1: DocComponent, T2: DocComponent, T3: DocComponent, T4: DocComponent, T5: DocComponent, T6: DocComponent, T7: DocComponent {
    public typealias Encoded = Chain8<T0.Encoded, T1.Encoded, T2.Encoded, T3.Encoded, T4.Encoded, T5.Encoded, T6.Encoded, T7.Encoded>

    public var bsonEncoded: Encoded {
        Chain8(s0: t0.bsonEncoded, s1: t1.bsonEncoded, s2: t2.bsonEncoded, s3: t3.bsonEncoded, s4: t4.bsonEncoded, s5: t5.bsonEncoded, s6: t6.bsonEncoded, s7: t7.bsonEncoded)
    }

    public init(_ t0: T0,_ t1: T1,_ t2: T2,_ t3: T3,_ t4: T4,_ t5: T5,_ t6: T6,_ t7: T7) {
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

extension Tuple9: DocComponent 
where T0: DocComponent, T1: DocComponent, T2: DocComponent, T3: DocComponent, T4: DocComponent, T5: DocComponent, T6: DocComponent, T7: DocComponent, T8: DocComponent {
    public typealias Encoded = Chain9<T0.Encoded, T1.Encoded, T2.Encoded, T3.Encoded, T4.Encoded, T5.Encoded, T6.Encoded, T7.Encoded, T8.Encoded>

    public var bsonEncoded: Encoded {
        Chain9(s0: t0.bsonEncoded, s1: t1.bsonEncoded, s2: t2.bsonEncoded, s3: t3.bsonEncoded, s4: t4.bsonEncoded, s5: t5.bsonEncoded, s6: t6.bsonEncoded, s7: t7.bsonEncoded, s8: t8.bsonEncoded)
    }

    public init(_ t0: T0,_ t1: T1,_ t2: T2,_ t3: T3,_ t4: T4,_ t5: T5,_ t6: T6,_ t7: T7,_ t8: T8) {
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

