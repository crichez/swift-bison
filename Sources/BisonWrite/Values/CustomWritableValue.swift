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

/// A protocol that describes how a custom type is encoded into a BSON document.
/// 
/// ## Conforming to CustomWritableValue
/// 
/// Conform to this protocol to encode types that do not exist in 
/// [the BSON specification](https://bsonspec.org/spec.html). `CustomWritableValue` refines 
/// ``WritableValue`` and provides default implementations to that protocol's requirements by 
/// automatically calculating and writing size metadata. All you need to do is: 
/// * Declare a subtype byte (or subtype number)
/// * Append your encoded value to the document
/// 
/// ### Subtype Byte
/// 
/// The specification reserves subtypes 128-255 for custom user-defined types. Just make sure
/// the recipient of your document knows how to decode your type. The following example declares
/// subtype byte 128 for `Foundation.Date` to use its value as a number of seconds since
/// the reference date of January 1st 2001.
/// 
/// ```swift
/// extension Date: CustomWritableValue {
///     public var bsonSubtype: UInt8 { 128 }
///     ...  
/// }
/// ```
/// 
/// ### Value Data
/// 
/// Implement the ``appendValue(to:)`` method by calling the `append(contentsOf:)` method of 
/// `document` and passing in your encoded value as a sequence of bytes. The `Doc` type conforms
/// to `RangeReplaceableCollection`, and can generally be thought of as an `Array` or `Data` 
/// buffer.
/// 
/// > Note: The `Doc.Index` type is unconstrained, which can make operations other than 
///   `append(_:)` and `append(contentsOf:)` cumbersome. You can use `Collection` methods to 
///   calculate indices and replace sections of the document using the `replaceSubrange(_:with:)` 
///   method.
/// 
/// ```swift
/// extension Date: CustomWritableValue {
///     ...
///     public func appendValue<Doc>(to document: inout Doc)
///     where Doc : RangeReplaceableCollection, Doc.Element == UInt8 {
///         withUnsafeBytes(of: self.timeIntervalSinceReferenceDate) { bytes in 
///             document.append(contentsOf: bytes)
///         }
///     }
/// }
/// ```
/// 
/// ## Size & Metadata
/// 
/// Given an `Int64` value and a custom subtype of `255`, the full value would be encoded
/// into the document as follows:
/// 
/// ```
/// "binary" type byte                         value bytes
///         |         value size                    |
///         v              v                        v
///        [5, Key...]    [0, 0, 0, 8]    [255]    [Value...]
///            ^                           ^
///       string key                 custom subtype
///        
/// ```
/// 
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
