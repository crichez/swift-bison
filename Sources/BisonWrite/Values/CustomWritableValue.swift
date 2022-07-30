//
//  CustomWritableValue.swift
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

/// A BSON value that declares the `binary` type (5).
/// 
/// `CustomWritableValue` is a convenience protocol that calculates and writes the size
/// of the value for you.
public protocol CustomWritableValue: WritableValue {
    /// The subtype byte to declare.
    var bsonSubtype: UInt8 { get }

    /// Appends the value's bytes to end of a document, not including the size and subtype.
    func appendValue<Doc>(to document: inout Doc) 
    where Doc : RangeReplaceableCollection, Doc.Element == UInt8
}

extension CustomWritableValue {
    public var bsonType: UInt8 {
        5
    }

    public func append<Doc>(to document: inout Doc)
    where Doc : RangeReplaceableCollection, Doc.Element == UInt8 {
        let sizeStartIndex = document.endIndex
        Int32(0).append(to: &document)
        let sizeEndIndex = document.index(sizeStartIndex, offsetBy: 4)
        document.append(bsonSubtype)
        let valueStartIndex = document.endIndex
        appendValue(to: &document)
        let valueEndIndex = document.endIndex
        let longSize = document.distance(from: valueStartIndex, to: valueEndIndex)
        guard let size = Int32(exactly: longSize) else { fatalError("value too long") }
        withUnsafeBytes(of: size) { sizeBytes in
            document.replaceSubrange(sizeStartIndex..<sizeEndIndex, with: sizeBytes)
        }
    }
}
