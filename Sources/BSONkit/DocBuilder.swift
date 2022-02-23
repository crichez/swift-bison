// Generated using Sourcery 1.6.1 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT

@resultBuilder
struct DocBuilder {
    static func buildBlock<T: BinaryConvertible>(_ t: T) -> some BinaryConvertible {
        t
    }

    static func buildBlock<T0, T1> (t0: T0, t1: T1) -> some BinaryConvertible
    where T0 : BinaryConvertible, T1 : BinaryConvertible {
        Tuple2(t0, t1)
    }

    static func buildBlock<T0, T1, T2> (t0: T0, t1: T1, t2: T2) -> some BinaryConvertible
    where T0 : BinaryConvertible, T1 : BinaryConvertible, T2 : BinaryConvertible {
        Tuple3(t0, t1, t2)
    }

    static func buildBlock<T0, T1, T2, T3> (t0: T0, t1: T1, t2: T2, t3: T3) -> some BinaryConvertible
    where T0 : BinaryConvertible, T1 : BinaryConvertible, T2 : BinaryConvertible, T3 : BinaryConvertible {
        Tuple4(t0, t1, t2, t3)
    }

    static func buildBlock<T0, T1, T2, T3, T4> (t0: T0, t1: T1, t2: T2, t3: T3, t4: T4) -> some BinaryConvertible
    where T0 : BinaryConvertible, T1 : BinaryConvertible, T2 : BinaryConvertible, T3 : BinaryConvertible, T4 : BinaryConvertible {
        Tuple5(t0, t1, t2, t3, t4)
    }

    static func buildBlock<T0, T1, T2, T3, T4, T5> (t0: T0, t1: T1, t2: T2, t3: T3, t4: T4, t5: T5) -> some BinaryConvertible
    where T0 : BinaryConvertible, T1 : BinaryConvertible, T2 : BinaryConvertible, T3 : BinaryConvertible, T4 : BinaryConvertible, T5 : BinaryConvertible {
        Tuple6(t0, t1, t2, t3, t4, t5)
    }

    static func buildBlock<T0, T1, T2, T3, T4, T5, T6> (t0: T0, t1: T1, t2: T2, t3: T3, t4: T4, t5: T5, t6: T6) -> some BinaryConvertible
    where T0 : BinaryConvertible, T1 : BinaryConvertible, T2 : BinaryConvertible, T3 : BinaryConvertible, T4 : BinaryConvertible, T5 : BinaryConvertible, T6 : BinaryConvertible {
        Tuple7(t0, t1, t2, t3, t4, t5, t6)
    }

    static func buildBlock<T0, T1, T2, T3, T4, T5, T6, T7> (t0: T0, t1: T1, t2: T2, t3: T3, t4: T4, t5: T5, t6: T6, t7: T7) -> some BinaryConvertible
    where T0 : BinaryConvertible, T1 : BinaryConvertible, T2 : BinaryConvertible, T3 : BinaryConvertible, T4 : BinaryConvertible, T5 : BinaryConvertible, T6 : BinaryConvertible, T7 : BinaryConvertible {
        Tuple8(t0, t1, t2, t3, t4, t5, t6, t7)
    }

    static func buildBlock<T0, T1, T2, T3, T4, T5, T6, T7, T8> (t0: T0, t1: T1, t2: T2, t3: T3, t4: T4, t5: T5, t6: T6, t7: T7, t8: T8) -> some BinaryConvertible
    where T0 : BinaryConvertible, T1 : BinaryConvertible, T2 : BinaryConvertible, T3 : BinaryConvertible, T4 : BinaryConvertible, T5 : BinaryConvertible, T6 : BinaryConvertible, T7 : BinaryConvertible, T8 : BinaryConvertible {
        Tuple9(t0, t1, t2, t3, t4, t5, t6, t7, t8)
    }

    static func buildBlock<T0, T1, T2, T3, T4, T5, T6, T7, T8, T9> (t0: T0, t1: T1, t2: T2, t3: T3, t4: T4, t5: T5, t6: T6, t7: T7, t8: T8, t9: T9) -> some BinaryConvertible
    where T0 : BinaryConvertible, T1 : BinaryConvertible, T2 : BinaryConvertible, T3 : BinaryConvertible, T4 : BinaryConvertible, T5 : BinaryConvertible, T6 : BinaryConvertible, T7 : BinaryConvertible, T8 : BinaryConvertible, T9 : BinaryConvertible {
        Tuple10(t0, t1, t2, t3, t4, t5, t6, t7, t8, t9)
    }
}