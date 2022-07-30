//
//  OptionalComponent.swift
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

/// A wrapper type for an optional component used exclusively by ``DocBuilder/buildOptional(_:)``.
enum OptionalComponent<T: DocComponent>: DocComponent {
    /// A non-nil component.
    case some(T)
    
    /// A nil component.
    case none
    
    /// Initializes an `OptionalComponent` from the provided `Optional` document component.
    init(_ component: T?) {
        switch component {
        case .some(let component):
            self = .some(component)
        case .none:
            self = .none
        }
    }

    func append<Doc>(to document: inout Doc)
    where Doc : RangeReplaceableCollection, Doc.Element == UInt8 {
        switch self {
        case .some(let component):
            return component.append(to: &document)
        case .none:
            return
        }
    }
}
