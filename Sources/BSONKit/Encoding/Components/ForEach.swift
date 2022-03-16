//
//  ForEach.swift
//  ForEach
//
//  Created by Christopher Richez on March 1 2022
//

/// Encodes a sequence into a document using the provided closure.
public struct ForEach<Base: Sequence, Element: DocComponent>: DocComponent {
    /// The transformed elements of this loop.
    let elements: LazyMapSequence<Base, Element>

    /// Encodes a sequence of elements by returning a `DocComponent` for each element.
    ///
    /// The following example encodes ten key value pairs from the `Int64` sequence 0 to 9.
    /// ```swift
    /// ForEach(Int64(0)..<10) { number in
    ///     "\(number)" => number
    /// }
    /// ```
    /// 
    /// - Parameters:
    ///   - base: a `Sequence` of arbitrary type to which to return a document component
    ///   - transform: a closure that takes a `base` element and returns a document component.
    public init(_ base: Base, @DocBuilder transform: @escaping (Base.Element) -> Element) {
        self.elements = base.lazy.map(transform)
    }
    
    public var bsonBytes: [UInt8] {
        elements.flatMap { $0.bsonBytes }
    }
}
