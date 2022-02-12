//
//
//
//
//
//

@resultBuilder
struct DocBuilder {
    static func buildBlock<T: BinaryConvertible>(_ value: T) -> some BinaryConvertible {
        value
    }

    static func buildBlock<T0, T1>(_ t0: T0, _ t1: T1) -> some BinaryConvertible
    where T0 : BinaryConvertible, T1 : BinaryConvertible {
        Tuple2(t0, t1)
    }

    static func buildBlock<T0, T1, T2>(_ t0: T0, _ t1: T1, _ t2: T2) -> some BinaryConvertible
    where T0 : BinaryConvertible, T1 : BinaryConvertible, T2 : BinaryConvertible {
        Tuple3(t0, t1, t2)
    }
}