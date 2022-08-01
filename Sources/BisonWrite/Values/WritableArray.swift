//
//  WritableArray.swift
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

/// A BSON array document that can be written to a buffer.
/// 
/// You can declare the structure of your array document using an ``ArrayDocBuilder`` result 
/// builder closure.
/// 
/// ## Declaring Values
/// 
/// Values are encoded in the order they are listed in the declaration, and their index is
/// determined by their position when the ``append(to:)`` method is called. The following example
/// declares three `String` values consecutively.
/// 
/// ```swift
/// let doc = WritableArray {
///     "zero"
///     "one"
///     "two"
/// }
/// ```
/// 
/// It can be helpful to think of BSON documents using their human-readable counterpart, JSON.
/// The declaration above resembles the following JSON document.
/// 
/// ```json
/// {
///     "0": "zero",
///     "1": "one",
///     "2": "two"
/// }
/// ```
/// 
/// Declarations contained in `if-else` or `do-catch` statements are handled the same way, and
/// are always stitched into the final document with the appropriate indices.
/// 
/// ```swift
/// let doc = WritableArray {
///     do {
///         try zeroAsString()
///         "one"
///         if !skipTwo {
///             "two"
///         }
///     } catch {
///         "error"
///     }
/// }
/// ```
/// 
/// You can use Swift `for-in` loops to declare large documents based on the contents of 
/// another sequence.
/// 
/// ```swift
/// let doc = WritableArray {
///     for evenNumber in ((0..<10_000).filter { $0.isEven }) {
///         evenNumber
///     }
/// }
/// ```
/// 
/// You can declare any value conforming to ``WritableValue``, or a type-erased ``WritableValue``
/// itself. Since `WritableArray` conforms to that protocol, you can nest documents too.
/// 
/// ```swift
/// let doc = WritableArray {
///     "shallow"
///     WritableArray {
///         "deep"
///         WritableArray {
///             "very deep!"
///         }
///     }   
/// }
/// ```
/// 
/// ## Writing the Document
/// 
/// When ready to encode the composed document, call its `encode(as:)` method. You can provide
/// any `RangeReplaceableCollection` of `UInt8` bytes. The example below encodes the document
/// as `Data`, then writes it to a URL.
/// 
/// ```swift
/// let encodedArrayDoc = arrayDoc.encode(as: Data.self)
/// try encodedArrayDoc.write(to: path)
/// ```
/// 
public struct WritableArray<Body: Sequence> where Body.Element == WritableValue {
    /// The contents of this array, a sequence of type-erased writable values.
    let body: Body
    
    /// Initializes an array document from the provided declaration.
    /// 
    /// - Parameter body: an `ArrayDocBuilder` closure declaring the structure of the array.
    /// 
    /// - Throws: Re-throws any errors thrown in the `body` closure.
    public init(@ArrayDocBuilder body: @escaping () throws -> Body) rethrows {
        self.body = try body()
    }

    /// Encodes this BSON array document as the specified buffer type.
    /// 
    /// - Parameter type: a `RangeReplaceableCollection` to encode this document as
    /// 
    /// - Returns: An instance of the requested buffer type that contains the declared document.
    public func encode<Buffer>(as type: Buffer.Type) -> Buffer
    where Buffer : RangeReplaceableCollection, Buffer.Element == UInt8 {
        var buffer = Buffer()
        append(to: &buffer)
        return buffer
    }
}

extension WritableArray: WritableValue {
    public func append<Doc>(to document: inout Doc) 
    where Doc : RangeReplaceableCollection, Doc.Element == UInt8 {
        let startIndex = document.endIndex
        Int32(0).append(to: &document)
        let sizeEndIndex = document.endIndex
        for (key, value) in body.enumerated() {
            document.append(value.bsonType)
            document.append(contentsOf: String(key).utf8)
            document.append(0)
            value.append(to: &document)
        }
        document.append(0)
        let endIndex = document.endIndex
        let longSize = document.distance(from: startIndex, to: endIndex)
        guard let size = Int32(exactly: longSize) else { fatalError("array too long") }
        withUnsafeBytes(of: size) { sizeBytes in 
            document.replaceSubrange(startIndex..<sizeEndIndex, with: sizeBytes)
        }
    }

    public var bsonType: UInt8 {
        0x04
    }
}
