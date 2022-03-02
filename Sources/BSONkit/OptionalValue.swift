//
//
//
//
//
//

enum OptionalValue<T: DocComponent>: DocComponent {
    case some(T)
    case none

    init(_ value: T?) {
        switch value {
        case .some(let value):
            self = .some(value)
        case .none:
            self = .none
        }
    }

    enum Encoded: Collection {
        case some(T.Encoded)
        case none

        init(_ value: OptionalValue) {
            switch value {
            case .some(let value):
                self = .some(value.bsonEncoded)
            case .none:
                self = .none
            }
        }
        
        struct Iterator: IteratorProtocol {
            var iterator: T.Encoded.Iterator?

            init(_ encoded: OptionalValue.Encoded) {
                switch encoded {
                case .some(let encoded):
                    iterator = encoded.makeIterator()
                case .none:
                    iterator = nil
                }
            }

            mutating func next() -> UInt8? {
                iterator?.next()
            }
        }

        func makeIterator() -> Iterator {
            Iterator(self)
        }

        enum Index: Comparable {
            case some(T.Encoded.Index)
            case none

            static func < (lhs: Self, rhs: Self) -> Bool {
                switch (lhs, rhs) {
                case (.some(let lhs), .some(let rhs)):
                    return lhs < rhs
                case (.none, .some(_)):
                    return true
                case (.some(_), .none):
                    return false
                case (.none, .none):
                    return false
                }
            }
        }

        func index(after i: Index) -> Index {
            switch i {
            case .some(let i):
                switch self {
                case .some(let encoded):
                    return .some(encoded.index(after: i))
                case .none:
                    return .none
                }
            case .none:
                return .none
            }
        }

        var startIndex: Index {
            switch self {
            case .some(let encoded):
                return .some(encoded.startIndex)
            case .none:
                return .none
            }
        }

        var endIndex: Index {
            switch self {
            case .some(let encoded):
                return .some(encoded.endIndex)
            case .none:
                return .none
            }
        }

        var count: Int {
            switch self {
            case .some(let encoded):
                return encoded.count
            case .none:
                return 0
            }
        }

        subscript(position: Index) -> UInt8 {
            switch position {
            case .some(let position):
                switch self {
                case .some(let encoded):
                    return encoded[position]
                case .none:
                    fatalError("requested an index from a nil collection")
                }
            case .none:
                fatalError("requested a nil index")
            }
        }
    }

    var bsonEncoded: Encoded {
        Encoded(self)
    }
}