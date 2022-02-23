// Generated using Sourcery 1.6.1 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT


extension Chain10: Collection
where S0 : Collection, S1 : Collection, S2 : Collection, S3 : Collection, S4 : Collection, S5 : Collection, S6 : Collection, S7 : Collection, S8 : Collection, S9 : Collection {
    enum Index: Comparable {
        case s0(S0.Index)
        case s1(S1.Index)
        case s2(S2.Index)
        case s3(S3.Index)
        case s4(S4.Index)
        case s5(S5.Index)
        case s6(S6.Index)
        case s7(S7.Index)
        case s8(S8.Index)
        case s9(S9.Index)

        static func < (lhs: Self, rhs: Self) -> Bool {
            switch (lhs, rhs) {
            case (.s0(_), .s1(_)):
                return true
            case (.s0(_), .s2(_)):
                return true
            case (.s0(_), .s3(_)):
                return true
            case (.s0(_), .s4(_)):
                return true
            case (.s0(_), .s5(_)):
                return true
            case (.s0(_), .s6(_)):
                return true
            case (.s0(_), .s7(_)):
                return true
            case (.s0(_), .s8(_)):
                return true
            case (.s0(_), .s9(_)):
                return true
            case (.s0(let lhs), .s0(let rhs)):
                return lhs < rhs
            case (.s1(_), .s2(_)):
                return true
            case (.s1(_), .s3(_)):
                return true
            case (.s1(_), .s4(_)):
                return true
            case (.s1(_), .s5(_)):
                return true
            case (.s1(_), .s6(_)):
                return true
            case (.s1(_), .s7(_)):
                return true
            case (.s1(_), .s8(_)):
                return true
            case (.s1(_), .s9(_)):
                return true
            case (.s1(_), .s0(_)):
                return false
            case (.s1(let lhs), .s1(let rhs)):
                return lhs < rhs
            case (.s2(_), .s3(_)):
                return true
            case (.s2(_), .s4(_)):
                return true
            case (.s2(_), .s5(_)):
                return true
            case (.s2(_), .s6(_)):
                return true
            case (.s2(_), .s7(_)):
                return true
            case (.s2(_), .s8(_)):
                return true
            case (.s2(_), .s9(_)):
                return true
            case (.s2(_), .s0(_)):
                return false
            case (.s2(_), .s1(_)):
                return false
            case (.s2(let lhs), .s2(let rhs)):
                return lhs < rhs
            case (.s3(_), .s4(_)):
                return true
            case (.s3(_), .s5(_)):
                return true
            case (.s3(_), .s6(_)):
                return true
            case (.s3(_), .s7(_)):
                return true
            case (.s3(_), .s8(_)):
                return true
            case (.s3(_), .s9(_)):
                return true
            case (.s3(_), .s0(_)):
                return false
            case (.s3(_), .s1(_)):
                return false
            case (.s3(_), .s2(_)):
                return false
            case (.s3(let lhs), .s3(let rhs)):
                return lhs < rhs
            case (.s4(_), .s5(_)):
                return true
            case (.s4(_), .s6(_)):
                return true
            case (.s4(_), .s7(_)):
                return true
            case (.s4(_), .s8(_)):
                return true
            case (.s4(_), .s9(_)):
                return true
            case (.s4(_), .s0(_)):
                return false
            case (.s4(_), .s1(_)):
                return false
            case (.s4(_), .s2(_)):
                return false
            case (.s4(_), .s3(_)):
                return false
            case (.s4(let lhs), .s4(let rhs)):
                return lhs < rhs
            case (.s5(_), .s6(_)):
                return true
            case (.s5(_), .s7(_)):
                return true
            case (.s5(_), .s8(_)):
                return true
            case (.s5(_), .s9(_)):
                return true
            case (.s5(_), .s0(_)):
                return false
            case (.s5(_), .s1(_)):
                return false
            case (.s5(_), .s2(_)):
                return false
            case (.s5(_), .s3(_)):
                return false
            case (.s5(_), .s4(_)):
                return false
            case (.s5(let lhs), .s5(let rhs)):
                return lhs < rhs
            case (.s6(_), .s7(_)):
                return true
            case (.s6(_), .s8(_)):
                return true
            case (.s6(_), .s9(_)):
                return true
            case (.s6(_), .s0(_)):
                return false
            case (.s6(_), .s1(_)):
                return false
            case (.s6(_), .s2(_)):
                return false
            case (.s6(_), .s3(_)):
                return false
            case (.s6(_), .s4(_)):
                return false
            case (.s6(_), .s5(_)):
                return false
            case (.s6(let lhs), .s6(let rhs)):
                return lhs < rhs
            case (.s7(_), .s8(_)):
                return true
            case (.s7(_), .s9(_)):
                return true
            case (.s7(_), .s0(_)):
                return false
            case (.s7(_), .s1(_)):
                return false
            case (.s7(_), .s2(_)):
                return false
            case (.s7(_), .s3(_)):
                return false
            case (.s7(_), .s4(_)):
                return false
            case (.s7(_), .s5(_)):
                return false
            case (.s7(_), .s6(_)):
                return false
            case (.s7(let lhs), .s7(let rhs)):
                return lhs < rhs
            case (.s8(_), .s9(_)):
                return true
            case (.s8(_), .s0(_)):
                return false
            case (.s8(_), .s1(_)):
                return false
            case (.s8(_), .s2(_)):
                return false
            case (.s8(_), .s3(_)):
                return false
            case (.s8(_), .s4(_)):
                return false
            case (.s8(_), .s5(_)):
                return false
            case (.s8(_), .s6(_)):
                return false
            case (.s8(_), .s7(_)):
                return false
            case (.s8(let lhs), .s8(let rhs)):
                return lhs < rhs
            case (.s9(_), .s0(_)):
                return false
            case (.s9(_), .s1(_)):
                return false
            case (.s9(_), .s2(_)):
                return false
            case (.s9(_), .s3(_)):
                return false
            case (.s9(_), .s4(_)):
                return false
            case (.s9(_), .s5(_)):
                return false
            case (.s9(_), .s6(_)):
                return false
            case (.s9(_), .s7(_)):
                return false
            case (.s9(_), .s8(_)):
                return false
            case (.s9(let lhs), .s9(let rhs)):
                return lhs < rhs
            }
        }
    }

    var count: Int {
        let sum1 = s0.count + s1.count
        let sum2 = sum1 + s2.count
        let sum3 = sum2 + s3.count
        let sum4 = sum3 + s4.count
        let sum5 = sum4 + s5.count
        let sum6 = sum5 + s6.count
        let sum7 = sum6 + s7.count
        let sum8 = sum7 + s8.count
        let sum9 = sum8 + s9.count
        return sum9
    }

    var startIndex: Index {
        .s0(s0.startIndex)
    }

    var endIndex: Index {
        .s9(s9.endIndex)
    }

    func index(after i: Index) -> Index {
        switch i {
        case .s0(let i):
            return .s0(s0.index(after: i))
        case .s1(let i):
            return .s1(s1.index(after: i))
        case .s2(let i):
            return .s2(s2.index(after: i))
        case .s3(let i):
            return .s3(s3.index(after: i))
        case .s4(let i):
            return .s4(s4.index(after: i))
        case .s5(let i):
            return .s5(s5.index(after: i))
        case .s6(let i):
            return .s6(s6.index(after: i))
        case .s7(let i):
            return .s7(s7.index(after: i))
        case .s8(let i):
            return .s8(s8.index(after: i))
        case .s9(let i):
            return .s9(s9.index(after: i))
        }
    }

    subscript(position: Index) -> S0.Element {
        switch position {
        case .s0(let position):
            return s0[position]
        case .s1(let position):
            return s1[position]
        case .s2(let position):
            return s2[position]
        case .s3(let position):
            return s3[position]
        case .s4(let position):
            return s4[position]
        case .s5(let position):
            return s5[position]
        case .s6(let position):
            return s6[position]
        case .s7(let position):
            return s7[position]
        case .s8(let position):
            return s8[position]
        case .s9(let position):
            return s9[position]
        }
    }
}

extension Chain2: Collection
where S0 : Collection, S1 : Collection {
    enum Index: Comparable {
        case s0(S0.Index)
        case s1(S1.Index)

        static func < (lhs: Self, rhs: Self) -> Bool {
            switch (lhs, rhs) {
            case (.s0(_), .s1(_)):
                return true
            case (.s0(let lhs), .s0(let rhs)):
                return lhs < rhs
            case (.s1(_), .s0(_)):
                return false
            case (.s1(let lhs), .s1(let rhs)):
                return lhs < rhs
            }
        }
    }

    var count: Int {
        let sum1 = s0.count + s1.count
        return sum1
    }

    var startIndex: Index {
        .s0(s0.startIndex)
    }

    var endIndex: Index {
        .s1(s1.endIndex)
    }

    func index(after i: Index) -> Index {
        switch i {
        case .s0(let i):
            return .s0(s0.index(after: i))
        case .s1(let i):
            return .s1(s1.index(after: i))
        }
    }

    subscript(position: Index) -> S0.Element {
        switch position {
        case .s0(let position):
            return s0[position]
        case .s1(let position):
            return s1[position]
        }
    }
}

extension Chain3: Collection
where S0 : Collection, S1 : Collection, S2 : Collection {
    enum Index: Comparable {
        case s0(S0.Index)
        case s1(S1.Index)
        case s2(S2.Index)

        static func < (lhs: Self, rhs: Self) -> Bool {
            switch (lhs, rhs) {
            case (.s0(_), .s1(_)):
                return true
            case (.s0(_), .s2(_)):
                return true
            case (.s0(let lhs), .s0(let rhs)):
                return lhs < rhs
            case (.s1(_), .s2(_)):
                return true
            case (.s1(_), .s0(_)):
                return false
            case (.s1(let lhs), .s1(let rhs)):
                return lhs < rhs
            case (.s2(_), .s0(_)):
                return false
            case (.s2(_), .s1(_)):
                return false
            case (.s2(let lhs), .s2(let rhs)):
                return lhs < rhs
            }
        }
    }

    var count: Int {
        let sum1 = s0.count + s1.count
        let sum2 = sum1 + s2.count
        return sum2
    }

    var startIndex: Index {
        .s0(s0.startIndex)
    }

    var endIndex: Index {
        .s2(s2.endIndex)
    }

    func index(after i: Index) -> Index {
        switch i {
        case .s0(let i):
            return .s0(s0.index(after: i))
        case .s1(let i):
            return .s1(s1.index(after: i))
        case .s2(let i):
            return .s2(s2.index(after: i))
        }
    }

    subscript(position: Index) -> S0.Element {
        switch position {
        case .s0(let position):
            return s0[position]
        case .s1(let position):
            return s1[position]
        case .s2(let position):
            return s2[position]
        }
    }
}

extension Chain4: Collection
where S0 : Collection, S1 : Collection, S2 : Collection, S3 : Collection {
    enum Index: Comparable {
        case s0(S0.Index)
        case s1(S1.Index)
        case s2(S2.Index)
        case s3(S3.Index)

        static func < (lhs: Self, rhs: Self) -> Bool {
            switch (lhs, rhs) {
            case (.s0(_), .s1(_)):
                return true
            case (.s0(_), .s2(_)):
                return true
            case (.s0(_), .s3(_)):
                return true
            case (.s0(let lhs), .s0(let rhs)):
                return lhs < rhs
            case (.s1(_), .s2(_)):
                return true
            case (.s1(_), .s3(_)):
                return true
            case (.s1(_), .s0(_)):
                return false
            case (.s1(let lhs), .s1(let rhs)):
                return lhs < rhs
            case (.s2(_), .s3(_)):
                return true
            case (.s2(_), .s0(_)):
                return false
            case (.s2(_), .s1(_)):
                return false
            case (.s2(let lhs), .s2(let rhs)):
                return lhs < rhs
            case (.s3(_), .s0(_)):
                return false
            case (.s3(_), .s1(_)):
                return false
            case (.s3(_), .s2(_)):
                return false
            case (.s3(let lhs), .s3(let rhs)):
                return lhs < rhs
            }
        }
    }

    var count: Int {
        let sum1 = s0.count + s1.count
        let sum2 = sum1 + s2.count
        let sum3 = sum2 + s3.count
        return sum3
    }

    var startIndex: Index {
        .s0(s0.startIndex)
    }

    var endIndex: Index {
        .s3(s3.endIndex)
    }

    func index(after i: Index) -> Index {
        switch i {
        case .s0(let i):
            return .s0(s0.index(after: i))
        case .s1(let i):
            return .s1(s1.index(after: i))
        case .s2(let i):
            return .s2(s2.index(after: i))
        case .s3(let i):
            return .s3(s3.index(after: i))
        }
    }

    subscript(position: Index) -> S0.Element {
        switch position {
        case .s0(let position):
            return s0[position]
        case .s1(let position):
            return s1[position]
        case .s2(let position):
            return s2[position]
        case .s3(let position):
            return s3[position]
        }
    }
}

extension Chain5: Collection
where S0 : Collection, S1 : Collection, S2 : Collection, S3 : Collection, S4 : Collection {
    enum Index: Comparable {
        case s0(S0.Index)
        case s1(S1.Index)
        case s2(S2.Index)
        case s3(S3.Index)
        case s4(S4.Index)

        static func < (lhs: Self, rhs: Self) -> Bool {
            switch (lhs, rhs) {
            case (.s0(_), .s1(_)):
                return true
            case (.s0(_), .s2(_)):
                return true
            case (.s0(_), .s3(_)):
                return true
            case (.s0(_), .s4(_)):
                return true
            case (.s0(let lhs), .s0(let rhs)):
                return lhs < rhs
            case (.s1(_), .s2(_)):
                return true
            case (.s1(_), .s3(_)):
                return true
            case (.s1(_), .s4(_)):
                return true
            case (.s1(_), .s0(_)):
                return false
            case (.s1(let lhs), .s1(let rhs)):
                return lhs < rhs
            case (.s2(_), .s3(_)):
                return true
            case (.s2(_), .s4(_)):
                return true
            case (.s2(_), .s0(_)):
                return false
            case (.s2(_), .s1(_)):
                return false
            case (.s2(let lhs), .s2(let rhs)):
                return lhs < rhs
            case (.s3(_), .s4(_)):
                return true
            case (.s3(_), .s0(_)):
                return false
            case (.s3(_), .s1(_)):
                return false
            case (.s3(_), .s2(_)):
                return false
            case (.s3(let lhs), .s3(let rhs)):
                return lhs < rhs
            case (.s4(_), .s0(_)):
                return false
            case (.s4(_), .s1(_)):
                return false
            case (.s4(_), .s2(_)):
                return false
            case (.s4(_), .s3(_)):
                return false
            case (.s4(let lhs), .s4(let rhs)):
                return lhs < rhs
            }
        }
    }

    var count: Int {
        let sum1 = s0.count + s1.count
        let sum2 = sum1 + s2.count
        let sum3 = sum2 + s3.count
        let sum4 = sum3 + s4.count
        return sum4
    }

    var startIndex: Index {
        .s0(s0.startIndex)
    }

    var endIndex: Index {
        .s4(s4.endIndex)
    }

    func index(after i: Index) -> Index {
        switch i {
        case .s0(let i):
            return .s0(s0.index(after: i))
        case .s1(let i):
            return .s1(s1.index(after: i))
        case .s2(let i):
            return .s2(s2.index(after: i))
        case .s3(let i):
            return .s3(s3.index(after: i))
        case .s4(let i):
            return .s4(s4.index(after: i))
        }
    }

    subscript(position: Index) -> S0.Element {
        switch position {
        case .s0(let position):
            return s0[position]
        case .s1(let position):
            return s1[position]
        case .s2(let position):
            return s2[position]
        case .s3(let position):
            return s3[position]
        case .s4(let position):
            return s4[position]
        }
    }
}

extension Chain6: Collection
where S0 : Collection, S1 : Collection, S2 : Collection, S3 : Collection, S4 : Collection, S5 : Collection {
    enum Index: Comparable {
        case s0(S0.Index)
        case s1(S1.Index)
        case s2(S2.Index)
        case s3(S3.Index)
        case s4(S4.Index)
        case s5(S5.Index)

        static func < (lhs: Self, rhs: Self) -> Bool {
            switch (lhs, rhs) {
            case (.s0(_), .s1(_)):
                return true
            case (.s0(_), .s2(_)):
                return true
            case (.s0(_), .s3(_)):
                return true
            case (.s0(_), .s4(_)):
                return true
            case (.s0(_), .s5(_)):
                return true
            case (.s0(let lhs), .s0(let rhs)):
                return lhs < rhs
            case (.s1(_), .s2(_)):
                return true
            case (.s1(_), .s3(_)):
                return true
            case (.s1(_), .s4(_)):
                return true
            case (.s1(_), .s5(_)):
                return true
            case (.s1(_), .s0(_)):
                return false
            case (.s1(let lhs), .s1(let rhs)):
                return lhs < rhs
            case (.s2(_), .s3(_)):
                return true
            case (.s2(_), .s4(_)):
                return true
            case (.s2(_), .s5(_)):
                return true
            case (.s2(_), .s0(_)):
                return false
            case (.s2(_), .s1(_)):
                return false
            case (.s2(let lhs), .s2(let rhs)):
                return lhs < rhs
            case (.s3(_), .s4(_)):
                return true
            case (.s3(_), .s5(_)):
                return true
            case (.s3(_), .s0(_)):
                return false
            case (.s3(_), .s1(_)):
                return false
            case (.s3(_), .s2(_)):
                return false
            case (.s3(let lhs), .s3(let rhs)):
                return lhs < rhs
            case (.s4(_), .s5(_)):
                return true
            case (.s4(_), .s0(_)):
                return false
            case (.s4(_), .s1(_)):
                return false
            case (.s4(_), .s2(_)):
                return false
            case (.s4(_), .s3(_)):
                return false
            case (.s4(let lhs), .s4(let rhs)):
                return lhs < rhs
            case (.s5(_), .s0(_)):
                return false
            case (.s5(_), .s1(_)):
                return false
            case (.s5(_), .s2(_)):
                return false
            case (.s5(_), .s3(_)):
                return false
            case (.s5(_), .s4(_)):
                return false
            case (.s5(let lhs), .s5(let rhs)):
                return lhs < rhs
            }
        }
    }

    var count: Int {
        let sum1 = s0.count + s1.count
        let sum2 = sum1 + s2.count
        let sum3 = sum2 + s3.count
        let sum4 = sum3 + s4.count
        let sum5 = sum4 + s5.count
        return sum5
    }

    var startIndex: Index {
        .s0(s0.startIndex)
    }

    var endIndex: Index {
        .s5(s5.endIndex)
    }

    func index(after i: Index) -> Index {
        switch i {
        case .s0(let i):
            return .s0(s0.index(after: i))
        case .s1(let i):
            return .s1(s1.index(after: i))
        case .s2(let i):
            return .s2(s2.index(after: i))
        case .s3(let i):
            return .s3(s3.index(after: i))
        case .s4(let i):
            return .s4(s4.index(after: i))
        case .s5(let i):
            return .s5(s5.index(after: i))
        }
    }

    subscript(position: Index) -> S0.Element {
        switch position {
        case .s0(let position):
            return s0[position]
        case .s1(let position):
            return s1[position]
        case .s2(let position):
            return s2[position]
        case .s3(let position):
            return s3[position]
        case .s4(let position):
            return s4[position]
        case .s5(let position):
            return s5[position]
        }
    }
}

extension Chain7: Collection
where S0 : Collection, S1 : Collection, S2 : Collection, S3 : Collection, S4 : Collection, S5 : Collection, S6 : Collection {
    enum Index: Comparable {
        case s0(S0.Index)
        case s1(S1.Index)
        case s2(S2.Index)
        case s3(S3.Index)
        case s4(S4.Index)
        case s5(S5.Index)
        case s6(S6.Index)

        static func < (lhs: Self, rhs: Self) -> Bool {
            switch (lhs, rhs) {
            case (.s0(_), .s1(_)):
                return true
            case (.s0(_), .s2(_)):
                return true
            case (.s0(_), .s3(_)):
                return true
            case (.s0(_), .s4(_)):
                return true
            case (.s0(_), .s5(_)):
                return true
            case (.s0(_), .s6(_)):
                return true
            case (.s0(let lhs), .s0(let rhs)):
                return lhs < rhs
            case (.s1(_), .s2(_)):
                return true
            case (.s1(_), .s3(_)):
                return true
            case (.s1(_), .s4(_)):
                return true
            case (.s1(_), .s5(_)):
                return true
            case (.s1(_), .s6(_)):
                return true
            case (.s1(_), .s0(_)):
                return false
            case (.s1(let lhs), .s1(let rhs)):
                return lhs < rhs
            case (.s2(_), .s3(_)):
                return true
            case (.s2(_), .s4(_)):
                return true
            case (.s2(_), .s5(_)):
                return true
            case (.s2(_), .s6(_)):
                return true
            case (.s2(_), .s0(_)):
                return false
            case (.s2(_), .s1(_)):
                return false
            case (.s2(let lhs), .s2(let rhs)):
                return lhs < rhs
            case (.s3(_), .s4(_)):
                return true
            case (.s3(_), .s5(_)):
                return true
            case (.s3(_), .s6(_)):
                return true
            case (.s3(_), .s0(_)):
                return false
            case (.s3(_), .s1(_)):
                return false
            case (.s3(_), .s2(_)):
                return false
            case (.s3(let lhs), .s3(let rhs)):
                return lhs < rhs
            case (.s4(_), .s5(_)):
                return true
            case (.s4(_), .s6(_)):
                return true
            case (.s4(_), .s0(_)):
                return false
            case (.s4(_), .s1(_)):
                return false
            case (.s4(_), .s2(_)):
                return false
            case (.s4(_), .s3(_)):
                return false
            case (.s4(let lhs), .s4(let rhs)):
                return lhs < rhs
            case (.s5(_), .s6(_)):
                return true
            case (.s5(_), .s0(_)):
                return false
            case (.s5(_), .s1(_)):
                return false
            case (.s5(_), .s2(_)):
                return false
            case (.s5(_), .s3(_)):
                return false
            case (.s5(_), .s4(_)):
                return false
            case (.s5(let lhs), .s5(let rhs)):
                return lhs < rhs
            case (.s6(_), .s0(_)):
                return false
            case (.s6(_), .s1(_)):
                return false
            case (.s6(_), .s2(_)):
                return false
            case (.s6(_), .s3(_)):
                return false
            case (.s6(_), .s4(_)):
                return false
            case (.s6(_), .s5(_)):
                return false
            case (.s6(let lhs), .s6(let rhs)):
                return lhs < rhs
            }
        }
    }

    var count: Int {
        let sum1 = s0.count + s1.count
        let sum2 = sum1 + s2.count
        let sum3 = sum2 + s3.count
        let sum4 = sum3 + s4.count
        let sum5 = sum4 + s5.count
        let sum6 = sum5 + s6.count
        return sum6
    }

    var startIndex: Index {
        .s0(s0.startIndex)
    }

    var endIndex: Index {
        .s6(s6.endIndex)
    }

    func index(after i: Index) -> Index {
        switch i {
        case .s0(let i):
            return .s0(s0.index(after: i))
        case .s1(let i):
            return .s1(s1.index(after: i))
        case .s2(let i):
            return .s2(s2.index(after: i))
        case .s3(let i):
            return .s3(s3.index(after: i))
        case .s4(let i):
            return .s4(s4.index(after: i))
        case .s5(let i):
            return .s5(s5.index(after: i))
        case .s6(let i):
            return .s6(s6.index(after: i))
        }
    }

    subscript(position: Index) -> S0.Element {
        switch position {
        case .s0(let position):
            return s0[position]
        case .s1(let position):
            return s1[position]
        case .s2(let position):
            return s2[position]
        case .s3(let position):
            return s3[position]
        case .s4(let position):
            return s4[position]
        case .s5(let position):
            return s5[position]
        case .s6(let position):
            return s6[position]
        }
    }
}

extension Chain8: Collection
where S0 : Collection, S1 : Collection, S2 : Collection, S3 : Collection, S4 : Collection, S5 : Collection, S6 : Collection, S7 : Collection {
    enum Index: Comparable {
        case s0(S0.Index)
        case s1(S1.Index)
        case s2(S2.Index)
        case s3(S3.Index)
        case s4(S4.Index)
        case s5(S5.Index)
        case s6(S6.Index)
        case s7(S7.Index)

        static func < (lhs: Self, rhs: Self) -> Bool {
            switch (lhs, rhs) {
            case (.s0(_), .s1(_)):
                return true
            case (.s0(_), .s2(_)):
                return true
            case (.s0(_), .s3(_)):
                return true
            case (.s0(_), .s4(_)):
                return true
            case (.s0(_), .s5(_)):
                return true
            case (.s0(_), .s6(_)):
                return true
            case (.s0(_), .s7(_)):
                return true
            case (.s0(let lhs), .s0(let rhs)):
                return lhs < rhs
            case (.s1(_), .s2(_)):
                return true
            case (.s1(_), .s3(_)):
                return true
            case (.s1(_), .s4(_)):
                return true
            case (.s1(_), .s5(_)):
                return true
            case (.s1(_), .s6(_)):
                return true
            case (.s1(_), .s7(_)):
                return true
            case (.s1(_), .s0(_)):
                return false
            case (.s1(let lhs), .s1(let rhs)):
                return lhs < rhs
            case (.s2(_), .s3(_)):
                return true
            case (.s2(_), .s4(_)):
                return true
            case (.s2(_), .s5(_)):
                return true
            case (.s2(_), .s6(_)):
                return true
            case (.s2(_), .s7(_)):
                return true
            case (.s2(_), .s0(_)):
                return false
            case (.s2(_), .s1(_)):
                return false
            case (.s2(let lhs), .s2(let rhs)):
                return lhs < rhs
            case (.s3(_), .s4(_)):
                return true
            case (.s3(_), .s5(_)):
                return true
            case (.s3(_), .s6(_)):
                return true
            case (.s3(_), .s7(_)):
                return true
            case (.s3(_), .s0(_)):
                return false
            case (.s3(_), .s1(_)):
                return false
            case (.s3(_), .s2(_)):
                return false
            case (.s3(let lhs), .s3(let rhs)):
                return lhs < rhs
            case (.s4(_), .s5(_)):
                return true
            case (.s4(_), .s6(_)):
                return true
            case (.s4(_), .s7(_)):
                return true
            case (.s4(_), .s0(_)):
                return false
            case (.s4(_), .s1(_)):
                return false
            case (.s4(_), .s2(_)):
                return false
            case (.s4(_), .s3(_)):
                return false
            case (.s4(let lhs), .s4(let rhs)):
                return lhs < rhs
            case (.s5(_), .s6(_)):
                return true
            case (.s5(_), .s7(_)):
                return true
            case (.s5(_), .s0(_)):
                return false
            case (.s5(_), .s1(_)):
                return false
            case (.s5(_), .s2(_)):
                return false
            case (.s5(_), .s3(_)):
                return false
            case (.s5(_), .s4(_)):
                return false
            case (.s5(let lhs), .s5(let rhs)):
                return lhs < rhs
            case (.s6(_), .s7(_)):
                return true
            case (.s6(_), .s0(_)):
                return false
            case (.s6(_), .s1(_)):
                return false
            case (.s6(_), .s2(_)):
                return false
            case (.s6(_), .s3(_)):
                return false
            case (.s6(_), .s4(_)):
                return false
            case (.s6(_), .s5(_)):
                return false
            case (.s6(let lhs), .s6(let rhs)):
                return lhs < rhs
            case (.s7(_), .s0(_)):
                return false
            case (.s7(_), .s1(_)):
                return false
            case (.s7(_), .s2(_)):
                return false
            case (.s7(_), .s3(_)):
                return false
            case (.s7(_), .s4(_)):
                return false
            case (.s7(_), .s5(_)):
                return false
            case (.s7(_), .s6(_)):
                return false
            case (.s7(let lhs), .s7(let rhs)):
                return lhs < rhs
            }
        }
    }

    var count: Int {
        let sum1 = s0.count + s1.count
        let sum2 = sum1 + s2.count
        let sum3 = sum2 + s3.count
        let sum4 = sum3 + s4.count
        let sum5 = sum4 + s5.count
        let sum6 = sum5 + s6.count
        let sum7 = sum6 + s7.count
        return sum7
    }

    var startIndex: Index {
        .s0(s0.startIndex)
    }

    var endIndex: Index {
        .s7(s7.endIndex)
    }

    func index(after i: Index) -> Index {
        switch i {
        case .s0(let i):
            return .s0(s0.index(after: i))
        case .s1(let i):
            return .s1(s1.index(after: i))
        case .s2(let i):
            return .s2(s2.index(after: i))
        case .s3(let i):
            return .s3(s3.index(after: i))
        case .s4(let i):
            return .s4(s4.index(after: i))
        case .s5(let i):
            return .s5(s5.index(after: i))
        case .s6(let i):
            return .s6(s6.index(after: i))
        case .s7(let i):
            return .s7(s7.index(after: i))
        }
    }

    subscript(position: Index) -> S0.Element {
        switch position {
        case .s0(let position):
            return s0[position]
        case .s1(let position):
            return s1[position]
        case .s2(let position):
            return s2[position]
        case .s3(let position):
            return s3[position]
        case .s4(let position):
            return s4[position]
        case .s5(let position):
            return s5[position]
        case .s6(let position):
            return s6[position]
        case .s7(let position):
            return s7[position]
        }
    }
}

extension Chain9: Collection
where S0 : Collection, S1 : Collection, S2 : Collection, S3 : Collection, S4 : Collection, S5 : Collection, S6 : Collection, S7 : Collection, S8 : Collection {
    enum Index: Comparable {
        case s0(S0.Index)
        case s1(S1.Index)
        case s2(S2.Index)
        case s3(S3.Index)
        case s4(S4.Index)
        case s5(S5.Index)
        case s6(S6.Index)
        case s7(S7.Index)
        case s8(S8.Index)

        static func < (lhs: Self, rhs: Self) -> Bool {
            switch (lhs, rhs) {
            case (.s0(_), .s1(_)):
                return true
            case (.s0(_), .s2(_)):
                return true
            case (.s0(_), .s3(_)):
                return true
            case (.s0(_), .s4(_)):
                return true
            case (.s0(_), .s5(_)):
                return true
            case (.s0(_), .s6(_)):
                return true
            case (.s0(_), .s7(_)):
                return true
            case (.s0(_), .s8(_)):
                return true
            case (.s0(let lhs), .s0(let rhs)):
                return lhs < rhs
            case (.s1(_), .s2(_)):
                return true
            case (.s1(_), .s3(_)):
                return true
            case (.s1(_), .s4(_)):
                return true
            case (.s1(_), .s5(_)):
                return true
            case (.s1(_), .s6(_)):
                return true
            case (.s1(_), .s7(_)):
                return true
            case (.s1(_), .s8(_)):
                return true
            case (.s1(_), .s0(_)):
                return false
            case (.s1(let lhs), .s1(let rhs)):
                return lhs < rhs
            case (.s2(_), .s3(_)):
                return true
            case (.s2(_), .s4(_)):
                return true
            case (.s2(_), .s5(_)):
                return true
            case (.s2(_), .s6(_)):
                return true
            case (.s2(_), .s7(_)):
                return true
            case (.s2(_), .s8(_)):
                return true
            case (.s2(_), .s0(_)):
                return false
            case (.s2(_), .s1(_)):
                return false
            case (.s2(let lhs), .s2(let rhs)):
                return lhs < rhs
            case (.s3(_), .s4(_)):
                return true
            case (.s3(_), .s5(_)):
                return true
            case (.s3(_), .s6(_)):
                return true
            case (.s3(_), .s7(_)):
                return true
            case (.s3(_), .s8(_)):
                return true
            case (.s3(_), .s0(_)):
                return false
            case (.s3(_), .s1(_)):
                return false
            case (.s3(_), .s2(_)):
                return false
            case (.s3(let lhs), .s3(let rhs)):
                return lhs < rhs
            case (.s4(_), .s5(_)):
                return true
            case (.s4(_), .s6(_)):
                return true
            case (.s4(_), .s7(_)):
                return true
            case (.s4(_), .s8(_)):
                return true
            case (.s4(_), .s0(_)):
                return false
            case (.s4(_), .s1(_)):
                return false
            case (.s4(_), .s2(_)):
                return false
            case (.s4(_), .s3(_)):
                return false
            case (.s4(let lhs), .s4(let rhs)):
                return lhs < rhs
            case (.s5(_), .s6(_)):
                return true
            case (.s5(_), .s7(_)):
                return true
            case (.s5(_), .s8(_)):
                return true
            case (.s5(_), .s0(_)):
                return false
            case (.s5(_), .s1(_)):
                return false
            case (.s5(_), .s2(_)):
                return false
            case (.s5(_), .s3(_)):
                return false
            case (.s5(_), .s4(_)):
                return false
            case (.s5(let lhs), .s5(let rhs)):
                return lhs < rhs
            case (.s6(_), .s7(_)):
                return true
            case (.s6(_), .s8(_)):
                return true
            case (.s6(_), .s0(_)):
                return false
            case (.s6(_), .s1(_)):
                return false
            case (.s6(_), .s2(_)):
                return false
            case (.s6(_), .s3(_)):
                return false
            case (.s6(_), .s4(_)):
                return false
            case (.s6(_), .s5(_)):
                return false
            case (.s6(let lhs), .s6(let rhs)):
                return lhs < rhs
            case (.s7(_), .s8(_)):
                return true
            case (.s7(_), .s0(_)):
                return false
            case (.s7(_), .s1(_)):
                return false
            case (.s7(_), .s2(_)):
                return false
            case (.s7(_), .s3(_)):
                return false
            case (.s7(_), .s4(_)):
                return false
            case (.s7(_), .s5(_)):
                return false
            case (.s7(_), .s6(_)):
                return false
            case (.s7(let lhs), .s7(let rhs)):
                return lhs < rhs
            case (.s8(_), .s0(_)):
                return false
            case (.s8(_), .s1(_)):
                return false
            case (.s8(_), .s2(_)):
                return false
            case (.s8(_), .s3(_)):
                return false
            case (.s8(_), .s4(_)):
                return false
            case (.s8(_), .s5(_)):
                return false
            case (.s8(_), .s6(_)):
                return false
            case (.s8(_), .s7(_)):
                return false
            case (.s8(let lhs), .s8(let rhs)):
                return lhs < rhs
            }
        }
    }

    var count: Int {
        let sum1 = s0.count + s1.count
        let sum2 = sum1 + s2.count
        let sum3 = sum2 + s3.count
        let sum4 = sum3 + s4.count
        let sum5 = sum4 + s5.count
        let sum6 = sum5 + s6.count
        let sum7 = sum6 + s7.count
        let sum8 = sum7 + s8.count
        return sum8
    }

    var startIndex: Index {
        .s0(s0.startIndex)
    }

    var endIndex: Index {
        .s8(s8.endIndex)
    }

    func index(after i: Index) -> Index {
        switch i {
        case .s0(let i):
            return .s0(s0.index(after: i))
        case .s1(let i):
            return .s1(s1.index(after: i))
        case .s2(let i):
            return .s2(s2.index(after: i))
        case .s3(let i):
            return .s3(s3.index(after: i))
        case .s4(let i):
            return .s4(s4.index(after: i))
        case .s5(let i):
            return .s5(s5.index(after: i))
        case .s6(let i):
            return .s6(s6.index(after: i))
        case .s7(let i):
            return .s7(s7.index(after: i))
        case .s8(let i):
            return .s8(s8.index(after: i))
        }
    }

    subscript(position: Index) -> S0.Element {
        switch position {
        case .s0(let position):
            return s0[position]
        case .s1(let position):
            return s1[position]
        case .s2(let position):
            return s2[position]
        case .s3(let position):
            return s3[position]
        case .s4(let position):
            return s4[position]
        case .s5(let position):
            return s5[position]
        case .s6(let position):
            return s6[position]
        case .s7(let position):
            return s7[position]
        case .s8(let position):
            return s8[position]
        }
    }
}
