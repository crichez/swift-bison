// Generated using Sourcery 1.6.1 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT

extension Chain10: Sequence {
    public struct Iterator: IteratorProtocol {
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

        public mutating func next() -> S0.Element? {
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

    public func makeIterator() -> Iterator {
        Iterator(
            i0: s0.makeIterator(),
            i1: s1.makeIterator(),
            i2: s2.makeIterator(),
            i3: s3.makeIterator(),
            i4: s4.makeIterator(),
            i5: s5.makeIterator(),
            i6: s6.makeIterator(),
            i7: s7.makeIterator(),
            i8: s8.makeIterator(),
            i9: s9.makeIterator()
        )
    }
}

extension Chain2: Sequence {
    public struct Iterator: IteratorProtocol {
        var i0: S0.Iterator
        var i1: S1.Iterator

        public mutating func next() -> S0.Element? {
            if let next = i0.next() {
                return next
            } else if let next = i1.next() {
                return next
            } else {
                return nil
            }
        }
    }

    public func makeIterator() -> Iterator {
        Iterator(
            i0: s0.makeIterator(),
            i1: s1.makeIterator()
        )
    }
}

extension Chain3: Sequence {
    public struct Iterator: IteratorProtocol {
        var i0: S0.Iterator
        var i1: S1.Iterator
        var i2: S2.Iterator

        public mutating func next() -> S0.Element? {
            if let next = i0.next() {
                return next
            } else if let next = i1.next() {
                return next
            } else if let next = i2.next() {
                return next
            } else {
                return nil
            }
        }
    }

    public func makeIterator() -> Iterator {
        Iterator(
            i0: s0.makeIterator(),
            i1: s1.makeIterator(),
            i2: s2.makeIterator()
        )
    }
}

extension Chain4: Sequence {
    public struct Iterator: IteratorProtocol {
        var i0: S0.Iterator
        var i1: S1.Iterator
        var i2: S2.Iterator
        var i3: S3.Iterator

        public mutating func next() -> S0.Element? {
            if let next = i0.next() {
                return next
            } else if let next = i1.next() {
                return next
            } else if let next = i2.next() {
                return next
            } else if let next = i3.next() {
                return next
            } else {
                return nil
            }
        }
    }

    public func makeIterator() -> Iterator {
        Iterator(
            i0: s0.makeIterator(),
            i1: s1.makeIterator(),
            i2: s2.makeIterator(),
            i3: s3.makeIterator()
        )
    }
}

extension Chain5: Sequence {
    public struct Iterator: IteratorProtocol {
        var i0: S0.Iterator
        var i1: S1.Iterator
        var i2: S2.Iterator
        var i3: S3.Iterator
        var i4: S4.Iterator

        public mutating func next() -> S0.Element? {
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

    public func makeIterator() -> Iterator {
        Iterator(
            i0: s0.makeIterator(),
            i1: s1.makeIterator(),
            i2: s2.makeIterator(),
            i3: s3.makeIterator(),
            i4: s4.makeIterator()
        )
    }
}

extension Chain6: Sequence {
    public struct Iterator: IteratorProtocol {
        var i0: S0.Iterator
        var i1: S1.Iterator
        var i2: S2.Iterator
        var i3: S3.Iterator
        var i4: S4.Iterator
        var i5: S5.Iterator

        public mutating func next() -> S0.Element? {
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
            } else {
                return nil
            }
        }
    }

    public func makeIterator() -> Iterator {
        Iterator(
            i0: s0.makeIterator(),
            i1: s1.makeIterator(),
            i2: s2.makeIterator(),
            i3: s3.makeIterator(),
            i4: s4.makeIterator(),
            i5: s5.makeIterator()
        )
    }
}

extension Chain7: Sequence {
    public struct Iterator: IteratorProtocol {
        var i0: S0.Iterator
        var i1: S1.Iterator
        var i2: S2.Iterator
        var i3: S3.Iterator
        var i4: S4.Iterator
        var i5: S5.Iterator
        var i6: S6.Iterator

        public mutating func next() -> S0.Element? {
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
            } else {
                return nil
            }
        }
    }

    public func makeIterator() -> Iterator {
        Iterator(
            i0: s0.makeIterator(),
            i1: s1.makeIterator(),
            i2: s2.makeIterator(),
            i3: s3.makeIterator(),
            i4: s4.makeIterator(),
            i5: s5.makeIterator(),
            i6: s6.makeIterator()
        )
    }
}

extension Chain8: Sequence {
    public struct Iterator: IteratorProtocol {
        var i0: S0.Iterator
        var i1: S1.Iterator
        var i2: S2.Iterator
        var i3: S3.Iterator
        var i4: S4.Iterator
        var i5: S5.Iterator
        var i6: S6.Iterator
        var i7: S7.Iterator

        public mutating func next() -> S0.Element? {
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
            } else {
                return nil
            }
        }
    }

    public func makeIterator() -> Iterator {
        Iterator(
            i0: s0.makeIterator(),
            i1: s1.makeIterator(),
            i2: s2.makeIterator(),
            i3: s3.makeIterator(),
            i4: s4.makeIterator(),
            i5: s5.makeIterator(),
            i6: s6.makeIterator(),
            i7: s7.makeIterator()
        )
    }
}

extension Chain9: Sequence {
    public struct Iterator: IteratorProtocol {
        var i0: S0.Iterator
        var i1: S1.Iterator
        var i2: S2.Iterator
        var i3: S3.Iterator
        var i4: S4.Iterator
        var i5: S5.Iterator
        var i6: S6.Iterator
        var i7: S7.Iterator
        var i8: S8.Iterator

        public mutating func next() -> S0.Element? {
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
            } else {
                return nil
            }
        }
    }

    public func makeIterator() -> Iterator {
        Iterator(
            i0: s0.makeIterator(),
            i1: s1.makeIterator(),
            i2: s2.makeIterator(),
            i3: s3.makeIterator(),
            i4: s4.makeIterator(),
            i5: s5.makeIterator(),
            i6: s6.makeIterator(),
            i7: s7.makeIterator(),
            i8: s8.makeIterator()
        )
    }
}

