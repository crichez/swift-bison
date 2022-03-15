// Generated using Sourcery 1.6.1 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT


extension Tuple10: DocComponent 
where T0: DocComponent, T1: DocComponent, T2: DocComponent, T3: DocComponent, T4: DocComponent, T5: DocComponent, T6: DocComponent, T7: DocComponent, T8: DocComponent, T9: DocComponent {
    public var bsonEncoded: [UInt8] {
        var sum0 = t0.bsonEncoded + t1.bsonEncoded
        var sum1 = sum0 + t1.bsonEncoded
        var sum2 = sum1 + t2.bsonEncoded
        var sum3 = sum2 + t3.bsonEncoded
        var sum4 = sum3 + t4.bsonEncoded
        var sum5 = sum4 + t5.bsonEncoded
        var sum6 = sum5 + t6.bsonEncoded
        var sum7 = sum6 + t7.bsonEncoded
        var sum8 = sum7 + t8.bsonEncoded
        var sum9 = sum8 + t9.bsonEncoded
        return sum9
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
    public var bsonEncoded: [UInt8] {
        var sum0 = t0.bsonEncoded + t1.bsonEncoded
        var sum1 = sum0 + t1.bsonEncoded
        return sum1
    }

    public init(_ t0: T0,_ t1: T1) {
        self.t0 = t0
        self.t1 = t1
    }
}

extension Tuple3: DocComponent 
where T0: DocComponent, T1: DocComponent, T2: DocComponent {
    public var bsonEncoded: [UInt8] {
        var sum0 = t0.bsonEncoded + t1.bsonEncoded
        var sum1 = sum0 + t1.bsonEncoded
        var sum2 = sum1 + t2.bsonEncoded
        return sum2
    }

    public init(_ t0: T0,_ t1: T1,_ t2: T2) {
        self.t0 = t0
        self.t1 = t1
        self.t2 = t2
    }
}

extension Tuple4: DocComponent 
where T0: DocComponent, T1: DocComponent, T2: DocComponent, T3: DocComponent {
    public var bsonEncoded: [UInt8] {
        var sum0 = t0.bsonEncoded + t1.bsonEncoded
        var sum1 = sum0 + t1.bsonEncoded
        var sum2 = sum1 + t2.bsonEncoded
        var sum3 = sum2 + t3.bsonEncoded
        return sum3
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
    public var bsonEncoded: [UInt8] {
        var sum0 = t0.bsonEncoded + t1.bsonEncoded
        var sum1 = sum0 + t1.bsonEncoded
        var sum2 = sum1 + t2.bsonEncoded
        var sum3 = sum2 + t3.bsonEncoded
        var sum4 = sum3 + t4.bsonEncoded
        return sum4
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
    public var bsonEncoded: [UInt8] {
        var sum0 = t0.bsonEncoded + t1.bsonEncoded
        var sum1 = sum0 + t1.bsonEncoded
        var sum2 = sum1 + t2.bsonEncoded
        var sum3 = sum2 + t3.bsonEncoded
        var sum4 = sum3 + t4.bsonEncoded
        var sum5 = sum4 + t5.bsonEncoded
        return sum5
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
    public var bsonEncoded: [UInt8] {
        var sum0 = t0.bsonEncoded + t1.bsonEncoded
        var sum1 = sum0 + t1.bsonEncoded
        var sum2 = sum1 + t2.bsonEncoded
        var sum3 = sum2 + t3.bsonEncoded
        var sum4 = sum3 + t4.bsonEncoded
        var sum5 = sum4 + t5.bsonEncoded
        var sum6 = sum5 + t6.bsonEncoded
        return sum6
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
    public var bsonEncoded: [UInt8] {
        var sum0 = t0.bsonEncoded + t1.bsonEncoded
        var sum1 = sum0 + t1.bsonEncoded
        var sum2 = sum1 + t2.bsonEncoded
        var sum3 = sum2 + t3.bsonEncoded
        var sum4 = sum3 + t4.bsonEncoded
        var sum5 = sum4 + t5.bsonEncoded
        var sum6 = sum5 + t6.bsonEncoded
        var sum7 = sum6 + t7.bsonEncoded
        return sum7
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
    public var bsonEncoded: [UInt8] {
        var sum0 = t0.bsonEncoded + t1.bsonEncoded
        var sum1 = sum0 + t1.bsonEncoded
        var sum2 = sum1 + t2.bsonEncoded
        var sum3 = sum2 + t3.bsonEncoded
        var sum4 = sum3 + t4.bsonEncoded
        var sum5 = sum4 + t5.bsonEncoded
        var sum6 = sum5 + t6.bsonEncoded
        var sum7 = sum6 + t7.bsonEncoded
        var sum8 = sum7 + t8.bsonEncoded
        return sum8
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

