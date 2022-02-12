//
//  Chain5.swift
//
//
//  Created by Christopher Richez on February 11 2022
//

struct Chain5<S0, S1, S2, S3, S4>: Sequence 
where S0 : Sequence, S1 : Sequence, S2 : Sequence, 
      S3 : Sequence, S4 : Sequence,
      S0.Element == UInt8, S1.Element == UInt8, S2.Element == UInt8, 
      S3.Element == UInt8, S4.Element == UInt8 {
    let s0: S0
    let s1: S1
    let s2: S2
    let s3: S3
    let s4: S4

    init(_ s0: S0, _ s1: S1, _ s2: S2, _ s3: S3, _ s4: S4) {
        self.s0 = s0
        self.s1 = s1
        self.s2 = s2
        self.s3 = s3
        self.s4 = s4
    }

    init<T0, T1, T2, T3, T4>(_ t0: T0, _ t1: T1, _ t2: T2, _ t3: T3, _ t4: T4) throws 
    where T0 : BinaryConvertible, T1 : BinaryConvertible, T2 : BinaryConvertible, 
          T3 : BinaryConvertible, T4 : BinaryConvertible, T0.Encoded == S0, T1.Encoded == S1, 
          T2.Encoded == S2, T3.Encoded == S3, T4.Encoded == S4 {
        s0 = try t0.encode()
        s1 = try t1.encode()
        s2 = try t2.encode()
        s3 = try t3.encode()
        s4 = try t4.encode()
    }

    struct Iterator: IteratorProtocol {
        var i0: S0.Iterator
        var i1: S1.Iterator
        var i2: S2.Iterator
        var i3: S3.Iterator
        var i4: S4.Iterator

        init(_ s0: S0, _ s1: S1, _ s2: S2, _ s3: S3, _ s4: S4) {
            i0 = s0.makeIterator()
            i1 = s1.makeIterator()
            i2 = s2.makeIterator()
            i3 = s3.makeIterator()
            i4 = s4.makeIterator()
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
            } else {
                return nil
            }
        }
    }

    func makeIterator() -> Iterator {
        Iterator(s0, s1, s2, s3, s4)
    }
}
