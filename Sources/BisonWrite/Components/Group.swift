//
//  Group.swift
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

/// A group of document components.
/// 
/// Use a `Group` when you need to declare more than 10 components in a document.
/// Grouping document components does not affect the structure of the final document.
public struct Group<Body: DocComponent>: DocComponent {
    /// The components in this `Group`.
    let body: Body

    /// Groups the provided document components into a single document component.
    ///
    /// Use a `Group` when you need to declare more than 10 components in a document.
    /// Grouping document components does not affect the structure of the final document.
    ///
    /// - Throws:
    /// Rethrows any errors thrown in ``body``.
    ///
    /// - Parameter body: the document components to group
    public init(@DocBuilder body: @escaping () throws -> Body) rethrows {
        self.body = try body()
    }

    public func append<Doc>(to document: inout Doc)
    where Doc : RangeReplaceableCollection, Doc.Element == UInt8 {
        body.append(to: &document)
    }
}
