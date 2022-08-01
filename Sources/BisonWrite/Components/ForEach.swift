//
//  ForEach.swift
//  Copyright 2022 Christopher Richez
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

/// Declares a component of a BSON document from the contents of a `Sequence`.
/// 
/// Use ``init(_:transform:)`` to quickly convert any sequence to a series of key-value pairs.
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
    /// > Note: The closure can return anything conforming to ``DocComponent``. This includes
    ///   ``Pair``, ``Group``, or another ``ForEach`` declaration. 
    /// 
    /// - Parameters:
    ///   - base: a `Sequence` of arbitrary type to use as input
    ///   - transform: a closure that takes a `base` element and returns a ``DocComponent``
    public init(_ base: Base, @DocBuilder transform: @escaping (Base.Element) -> Element) {
        self.elements = base.lazy.map(transform)
    }
    
    public func append<Doc>(to document: inout Doc)
    where Doc : RangeReplaceableCollection, Doc.Element == UInt8 {
        for transformedElement in elements {
            transformedElement.append(to: &document)
        }
    }
}
