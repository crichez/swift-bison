// Generated using Sourcery 1.6.1 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT

@resultBuilder
struct DocBuilder {
    static func buildBlock<T: DocComponent>(_ t: T) -> some DocComponent {
        t
    }

    static func buildBlock<T0, T1> (_ t0: T0, _ t1: T1) -> some DocComponent
    where T0 : DocComponent, T1 : DocComponent {
        Tuple2(t0, t1)
    }

    static func buildBlock<T0, T1, T2> (_ t0: T0, _ t1: T1, _ t2: T2) -> some DocComponent
    where T0 : DocComponent, T1 : DocComponent, T2 : DocComponent {
        Tuple3(t0, t1, t2)
    }

    static func buildBlock<T0, T1, T2, T3> (_ t0: T0, _ t1: T1, _ t2: T2, _ t3: T3) -> some DocComponent
    where T0 : DocComponent, T1 : DocComponent, T2 : DocComponent, T3 : DocComponent {
        Tuple4(t0, t1, t2, t3)
    }

    static func buildBlock<T0, T1, T2, T3, T4> (_ t0: T0, _ t1: T1, _ t2: T2, _ t3: T3, _ t4: T4) -> some DocComponent
    where T0 : DocComponent, T1 : DocComponent, T2 : DocComponent, T3 : DocComponent, T4 : DocComponent {
        Tuple5(t0, t1, t2, t3, t4)
    }

    static func buildBlock<T0, T1, T2, T3, T4, T5> (_ t0: T0, _ t1: T1, _ t2: T2, _ t3: T3, _ t4: T4, _ t5: T5) -> some DocComponent
    where T0 : DocComponent, T1 : DocComponent, T2 : DocComponent, T3 : DocComponent, T4 : DocComponent, T5 : DocComponent {
        Tuple6(t0, t1, t2, t3, t4, t5)
    }

    static func buildBlock<T0, T1, T2, T3, T4, T5, T6> (_ t0: T0, _ t1: T1, _ t2: T2, _ t3: T3, _ t4: T4, _ t5: T5, _ t6: T6) -> some DocComponent
    where T0 : DocComponent, T1 : DocComponent, T2 : DocComponent, T3 : DocComponent, T4 : DocComponent, T5 : DocComponent, T6 : DocComponent {
        Tuple7(t0, t1, t2, t3, t4, t5, t6)
    }

    static func buildBlock<T0, T1, T2, T3, T4, T5, T6, T7> (_ t0: T0, _ t1: T1, _ t2: T2, _ t3: T3, _ t4: T4, _ t5: T5, _ t6: T6, _ t7: T7) -> some DocComponent
    where T0 : DocComponent, T1 : DocComponent, T2 : DocComponent, T3 : DocComponent, T4 : DocComponent, T5 : DocComponent, T6 : DocComponent, T7 : DocComponent {
        Tuple8(t0, t1, t2, t3, t4, t5, t6, t7)
    }

    static func buildBlock<T0, T1, T2, T3, T4, T5, T6, T7, T8> (_ t0: T0, _ t1: T1, _ t2: T2, _ t3: T3, _ t4: T4, _ t5: T5, _ t6: T6, _ t7: T7, _ t8: T8) -> some DocComponent
    where T0 : DocComponent, T1 : DocComponent, T2 : DocComponent, T3 : DocComponent, T4 : DocComponent, T5 : DocComponent, T6 : DocComponent, T7 : DocComponent, T8 : DocComponent {
        Tuple9(t0, t1, t2, t3, t4, t5, t6, t7, t8)
    }

    static func buildBlock<T0, T1, T2, T3, T4, T5, T6, T7, T8, T9> (_ t0: T0, _ t1: T1, _ t2: T2, _ t3: T3, _ t4: T4, _ t5: T5, _ t6: T6, _ t7: T7, _ t8: T8, _ t9: T9) -> some DocComponent
    where T0 : DocComponent, T1 : DocComponent, T2 : DocComponent, T3 : DocComponent, T4 : DocComponent, T5 : DocComponent, T6 : DocComponent, T7 : DocComponent, T8 : DocComponent, T9 : DocComponent {
        Tuple10(t0, t1, t2, t3, t4, t5, t6, t7, t8, t9)
    }

    static func buildEither<T>(first component: T) -> T where T : DocComponent {
        component
    }

    static func buildEither<T>(second component: T) -> T where T : DocComponent {
        component
    }

    static func buildOptional<T>(_ component: T?) -> OptionalValue<T> where T : DocComponent {
        OptionalValue(component)
    }

    static func buildLimitedAvailability<T>(_ component: T) -> T where T : DocComponent {
        component
    }
}