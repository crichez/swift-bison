//
//  Chain10.swift
//
//
//  Created by Christopher Richez on February 11 2022
//

struct Chain10<S1, S2, S3, S4, S5, S6, S7, S8, S9, S10>: Sequence 
where S1 : Sequence, S2 : Sequence, S3 : Sequence, S4 : Sequence, 
      S5 : Sequence, S6 : Sequence, S7 : Sequence, S8 : Sequence,
      S9 : Sequence, S10 : Sequence,
      S1.Element == UInt8, S2.Element == UInt8, S3.Element == UInt8, S4.Element == UInt8, 
      S5.Element == UInt8, S6.Element == UInt8, S7.Element == UInt8, S8.Element == UInt8,
      S9.Element == UInt8, S10.Element == UInt8 {
    let one: S1
    let two: S2
    let three: S3
    let four: S4
    let five: S5
    let six: S6
    let seven: S7
    let eight: S8
    let nine: S9
    let ten: S10

    struct Iterator: IteratorProtocol {
        var one: S1.Iterator
        var two: S2.Iterator
        var three: S3.Iterator
        var four: S4.Iterator
        var five: S5.Iterator
        var six: S6.Iterator
        var seven: S7.Iterator
        var eight: S8.Iterator
        var nine: S9.Iterator
        var ten: S10.Iterator

        mutating func next() -> UInt8? {
            if let next = one.next() {
                return next
            } else if let next = two.next() {
                return next
            } else if let next = three.next() {
                return next
            } else if let next = four.next() {
                return next
            } else if let next = five.next() {
                return next
            } else if let next = six.next() {
                return next
            } else if let next = seven.next() {
                return next
            } else if let next = eight.next() {
                return next
            } else if let next = nine.next() {
                return next
            } else if let next = ten.next() {
                return next
            } else {
                return nil
            }
        }
    }

    func makeIterator() -> Iterator {
        Iterator(
            one: one.makeIterator(), 
            two: two.makeIterator(), 
            three: three.makeIterator(),
            four: four.makeIterator(),
            five: five.makeIterator(),
            six: six.makeIterator(),
            seven: seven.makeIterator(),
            eight: eight.makeIterator(),
            nine: nine.makeIterator(),
            ten: ten.makeIterator())
    }
}
