//
//  ForEach.swift
//  ForEach
//
//  Created by Christopher Richez on March 1 2022
//

/// Encodes a `Sequence` of arbitrary type into a BSON document by applying the provided transform.
public struct ForEach<Source: Sequence, Element: DocComponent> {
    /// The sequence to which to apply the provided `transform` for each element.
    let source: Source

    /// A closure that takes a `source` element and returns a `DocComponent` conforming value.
    /// 
    /// This closure will be applied to each element in the `source` sequence 
    /// when `encode()` is called.
    let transform: (Source.Element) -> Element

    /// Encodes a sequence of elements by providing a `DocComponent` value for each element.
    /// 
    /// - Parameters:
    ///   - source: a `Sequence` of arbitrary type to which to apply a transformation
    ///   - transform: a closure that takes a `source` element 
    ///     and returns a `DocComponent` value.
    ///
    /// - Usage:
    /// ```swift
    /// ForEach(0..<10) { number in 
    ///     String(describing: number) => number
    /// }
    /// ```
    public init(_ source: Source, @DocBuilder transform: @escaping (Source.Element) -> Element) {
        self.source = source
        self.transform = transform
    }
}

extension ForEach: Sequence {
    /// An iterator that applies a transform to each `Source` element before returning it.
    public struct Iterator: IteratorProtocol {
        /// The iterator of the `Source` sequence.
        var source: Source.Iterator
        
        /// The transforming closure to apply to each `source` element.
        let transform: (Source.Element) -> Element

        /// Initializes an iterator from the provided `ForEach` value.
        init(_ loop: ForEach) {
            self.source = loop.source.makeIterator()
            self.transform = loop.transform
        }

        public mutating func next() -> Element? {
            guard let nextSourceElement = source.next() else { return nil }
            return transform(nextSourceElement)
        }
    }

    public func makeIterator() -> Iterator {
        Iterator(self)
    }
}

extension ForEach: DocComponent {
    public var bsonEncoded: [UInt8] {
        flatMap { $0.bsonEncoded }
    }
}
