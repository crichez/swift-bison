//
//  DocComponent.swift
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

/// A basic building block of a BSON document.
public protocol DocComponent {
    /// Appends this components BSON bytes to the end of a document.
    func append<Doc>(to document: inout Doc)
    where Doc : RangeReplaceableCollection, Doc.Element == UInt8
}
