//
//  Chain10.swift
//
//
//  Created by Christopher Richez on February 11 2022
//

struct Chain10<S0, S1, S2, S3, S4, S5, S6, S7, S8, S9>: Sequence 
where S0 : Sequence, S1 : Sequence, S2 : Sequence, S3 : Sequence, S4 : Sequence, 
      S5 : Sequence, S6 : Sequence, S7 : Sequence, S8 : Sequence, S9 : Sequence,
      S0.Element == UInt8, S1.Element == UInt8, S2.Element == UInt8, 
      S3.Element == UInt8, S4.Element == UInt8, S5.Element == UInt8,
      S6.Element == UInt8, S7.Element == UInt8, S8.Element == UInt8,
      S9.Element == UInt8 {
    let s0: S0
    let s1: S1
    let s2: S2
    let s3: S3
    let s4: S4
    let s5: S5
    let s6: S6
    let s7: S7
    let s8: S8
    let s9: S9

    init(
        _ s0: S0, 
        _ s1: S1, 
        _ s2: S2, 
        _ s3: S3, 
        _ s4: S4, 
        _ s5: S5, 
        _ s6: S6, 
        _ s7: S7, 
        _ s8: S8,
        _ s9: S9
    ) {
        self.s0 = s0
        self.s1 = s1
        self.s2 = s2
        self.s3 = s3
        self.s4 = s4
        self.s5 = s5
        self.s6 = s6
        self.s7 = s7
        self.s8 = s8
        self.s9 = s9
    }

    init<T0, T1, T2, T3, T4, T5, T6, T7, T8, T9>(
        _ t0: T0, 
        _ t1: T1, 
        _ t2: T2, 
        _ t3: T3, 
        _ t4: T4, 
        _ t5: T5,
        _ t6: T6,
        _ t7: T7,
        _ t8: T8,
        _ t9: T9
    ) throws where 
        T0 : BinaryConvertible, T1 : BinaryConvertible, T2 : BinaryConvertible, 
        T3 : BinaryConvertible, T4 : BinaryConvertible, T5 : BinaryConvertible, 
        T6 : BinaryConvertible, T7 : BinaryConvertible, T8 : BinaryConvertible,
        T9 : BinaryConvertible, T0.Encoded == S0, T1.Encoded == S1, T2.Encoded == S2, 
        T3.Encoded == S3, T4.Encoded == S4, T5.Encoded == S5, T6.Encoded == S6, T7.Encoded == S7,
        T8.Encoded == S8, T9.Encoded == S9 {
            s0 = try t0.encode()
            s1 = try t1.encode()
            s2 = try t2.encode()
            s3 = try t3.encode()
            s4 = try t4.encode()
            s5 = try t5.encode()
            s6 = try t6.encode()
            s7 = try t7.encode()
            s8 = try t8.encode()
            s9 = try t9.encode()
    }

    struct Iterator: IteratorProtocol {
        var i0: S0.Iterator
        var i1: S1.Iterator
        var i2: S2.Iterator
        var i3: S3.Iterator
        var i4: S4.Iterator
        var i5: S5.Iterator
        var i6: S6.Iterator
        var i7: S7.Iterator
        var i8: S8.Iterator
        var i9: S9.Iterator

        init(
            _ s0: S0, 
            _ s1: S1, 
            _ s2: S2, 
            _ s3: S3, 
            _ s4: S4, 
            _ s5: S5, 
            _ s6: S6, 
            _ s7: S7,
            _ s8: S8,
            _ s9: S9
        ) {
            i0 = s0.makeIterator()
            i1 = s1.makeIterator()
            i2 = s2.makeIterator()
            i3 = s3.makeIterator()
            i4 = s4.makeIterator()
            i5 = s5.makeIterator()
            i6 = s6.makeIterator()
            i7 = s7.makeIterator()
            i8 = s8.makeIterator()
            i9 = s9.makeIterator()
        }

        mutating func next() -> UInt8? {
            if let next = i0.next() {
                return next
            } else if let next = i1.next() {
                return next
            } else if let next = i2.next() {
                return next
            } else if let next = i3.next() {
                return next
            } else if let next = i4.next() {
                return next
            } else if let next = i5.next() {
                return next
            } else if let next = i6.next() {
                return next
            } else if let next = i7.next() {
                return next
            } else if let next = i8.next() {
                return next
            } else if let next = i9.next() {
                return next
            } else {
                return nil
            }
        }
    }

    func makeIterator() -> Iterator {
        Iterator(s0, s1, s2, s3, s4, s5, s6, s7, s8, s9)
    }
}
