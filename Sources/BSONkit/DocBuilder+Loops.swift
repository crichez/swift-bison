//
//
//
//
//
//

/// Encodes a `Sequence` of arbitrary type into a BSON document using the provided closure.
struct ForEach<Source: Sequence, Element: BinaryConvertible> {
    /// The sequence to which to apply the provided `transform` for each element.
    let source: Source

    /// A closure that takes a `source` element and returns a `BinaryConvertible` value.
    /// 
    /// This closure will be applied to each element in the `source` sequence 
    /// when `encode()` is called.
    let transform: (Source.Element) -> Element

    /// Encodes a sequence of elements by providing a `BinaryConvertible` value for each element.
    /// 
    /// - Parameters:
    ///   - source: a `Sequence` of arbitrary type to which to apply a transformation
    ///   - transform: a closure that takes a `source` element 
    ///     and returns a `BinaryConvertible` value.
    ///
    /// - Usage:
    /// ```swift
    /// ForEach(0..<10) { number in 
    ///     String(describing: number) => number
    /// }
    /// ```
    init(_ source: Source, @DocBuilder transform: @escaping (Source.Element) -> Element) {
        self.source = source
        self.transform = transform
    }
}

extension ForEach: Sequence {
    /// An iterator that applies a transform to each `Source` element before returning it.
    struct Iterator: IteratorProtocol {
        /// The iterator of the `Source` sequence.
        var source: Source.Iterator
        
        /// The transforming closure to apply to each `source` element.
        let transform: (Source.Element) -> Element

        /// Initializes an iterator from the provided `ForEach` value.
        init(_ loop: ForEach) {
            self.source = loop.source.makeIterator()
            self.transform = loop.transform
        }

        mutating func next() -> Element? {
            guard let nextSourceElement = source.next() else { return nil }
            return transform(nextSourceElement)
        }
    }

    func makeIterator() -> Iterator {
        Iterator(self)
    }
}

extension ForEach: BinaryConvertible {
    /// A collection type that returns the encoded bytes of each element of a `ForEach` loop.
    struct Encoded {
        /// The encoded elements of the declared `ForEach` loop.
        let encodedElements: [Element.Encoded]
        
        /// Encodes each transformed element of the `ForEach` loop.
        init(_ loop: ForEach) throws {
            self.encodedElements = try loop.lazy.map { element in
                try element.encode()
            }
        }
    }
    
    func encode() throws -> Encoded {
        try Encoded(self)
    }
}

extension ForEach.Encoded: Sequence {
    /// An iterator that returns the individual bytes of each encoded transformed element.
    struct Iterator: IteratorProtocol {
        /// The iterator for the declared `ForEach` loop.
        var source: Array<ForEach.Element.Encoded>.Iterator

        /// The iterator for the current element in `source` for which bytes are being returned.
        var currentIterator: ForEach.Iterator.Element.Encoded.Iterator?

        init(_ encodedElements: [ForEach.Element.Encoded]) {
            self.source = encodedElements.makeIterator()
            self.currentIterator = source.next()?.makeIterator()
        }

        mutating func next() -> UInt8? {
            // Check if we have a non-exhausted iterator to work with
            if currentIterator != nil {
                // If so, get the next byte from that iterator
                if let next = currentIterator?.next() {
                    // If there is a byte left, return it
                    return next
                } else {
                    // If there are no bytes left, remove the current iterator and try again
                    currentIterator = nil
                    return next()
                }
            } else {
                // If there is no current iterator, check if we can get a new one
                if let nextIterator = source.next()?.makeIterator() {
                    // If so, assign it and try again
                    currentIterator = nextIterator
                    return next()
                } else {
                    // If there is no next iterator, we have exhausted the loop
                    return nil
                }
            }
        }
    }

    func makeIterator() -> Iterator {
        Iterator(encodedElements)
    }
}

extension ForEach.Encoded: Collection {
    var count: Int {
        var accumulatedCount = 0
        for encodedElement in encodedElements {
            accumulatedCount += encodedElement.count
        }
        return accumulatedCount
    }
    
    struct Index: Comparable {
        let element: Array<Element.Encoded>.Index
        let byte: Element.Encoded.Index?
        
        static func < (lhs: Index, rhs: Index) -> Bool {
            if lhs.element == rhs.element {
                switch (lhs.byte, rhs.byte) {
                case (.none, .none):
                    return false
                case (.none, .some(_)):
                    return true
                case (.some(_), .none):
                    return false
                case (.some(let lhs), .some(let rhs)):
                    return lhs < rhs
                }
            } else if lhs.element < rhs.element {
                return true
            } else {
                return false
            }
        }
        
        init(_ element: Array<Element.Encoded>.Index, _ byte: Element.Encoded.Index?) {
            self.element = element
            self.byte = byte
        }
    }
    
    var startIndex: Index {
        Index(encodedElements.startIndex, encodedElements.first?.startIndex)
    }
    
    var endIndex: Index {
        Index(encodedElements.endIndex, encodedElements.last?.endIndex)
    }
    
    func index(after i: Index) -> Index {
        Index(i.element + 1, nil)
    }
    
    subscript(position: Index) -> UInt8 {
        encodedElements[position.element][position.byte!]
    }
}
