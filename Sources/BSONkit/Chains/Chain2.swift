//
//  Chains.swift
//
//
//  Created by Christopher Richez on February 11 2022
//

struct Chain2<S1, S2>: Sequence 
where S1 : Sequence, S2 : Sequence, S1.Element == UInt8, S2.Element == UInt8 {
    let one: S1
    let two: S2

    struct Iterator: IteratorProtocol {
        var one: S1.Iterator
        var two: S2.Iterator

        mutating func next() -> UInt8? {
            if let next = one.next() {
                return next
            } else if let next = two.next() {
                return next
            } else {
                return nil
            }
        }
    }

    func makeIterator() -> Iterator {
        Iterator(one: one.makeIterator(), two: two.makeIterator())
    }
}
