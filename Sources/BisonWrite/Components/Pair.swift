//
//  Pair.swift
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

/// A key-value pair used to compose a BSON document.
/// 
/// To create a `Pair`, use the `=>` operator on a `String` and a `WritableValue`.
/// ```swift
/// let doc = WritableDoc {
///     "key" => "value"
/// }
/// ```
public struct Pair<T: WritableValue>: DocComponent {
    let key: String
    let value: T
    
    public func append<Doc>(to document: inout Doc)
    where Doc : RangeReplaceableCollection, Doc.Element == UInt8 {
        document.append(value.bsonType)
        document.append(contentsOf: key.utf8)
        document.append(0)
        value.append(to: &document)
    }
}
