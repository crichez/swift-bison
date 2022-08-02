//
//  WritableDoc.swift
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

/// A BSON document that can be written to a buffer.
/// 
/// You can declare the structure of your document using a ``DocBuilder`` result builder closure.
/// 
/// ## Declaring Values
/// 
/// Each value in a `WritableDoc` must be assigned to a `String`. Use the `=>` operator
/// to make key-value assignment look natural. The following document declares three
/// key-value pairs consecutively.
/// 
/// ```swift
/// let doc = WritableDoc {
///     "zero" => 0.0
///     "one" => 1.0
///     "two" => 2.0
/// }
/// ```
/// 
/// It can be helpful to think of BSON documents using their human readable JSON counterpart. The
/// declaration above resembles the following JSON document:
/// 
/// ```json
/// {
///     "zero": 0.0,
///     "one": 1.0,
///     "two": 2.0  
/// }
/// ```
/// 
/// Declarations contained in `if-else` or `do-catch` statements are handled the same way, and
/// are always stitched into the final document at the declared position. 
/// 
/// ```swift
/// let doc = WritableDoc {
///     do {
///         "zero" => try zeroAsDouble()
///         "one" => 1.0
///         if !skipTwo {
///             "two" => 2.0    
///         }
///     } catch {
///         "error" => "Zero couldn't be converted to a Double."
///     }
/// }
/// ```
/// 
/// An important limitation of the current ``DocBuilder`` implementation is the 10 key-value pair
/// limit per block. A block here can be thought of as a level of indentation in the closure. To
/// get around this limit, you can use the ``Group`` document component to turn up to 20 pairs
/// into two components. These will all appear at the same depth level in the resulting document.
/// 
/// ```swift
/// let doc = WritableDoc {
///     Group {
///         "zero" => 0
///         "one" => 1
///         "two" => 2
///     }
///     Group {
///         "three" => 3
///         "four" => 4
///     }
/// }
/// ```
/// 
/// When composing large documents from the contents of another sequence, a ``ForEach`` declaration
/// is not subject to this limitation. The following declaration declares 10,000 key-value pairs.
/// 
/// ```swift
/// let doc = WritableDoc {
///     ForEach(Int64(0)..<10_000) { number in 
///         String(number) => number
///     }
/// }
/// ```
/// 
/// You can declare any value conforming to ``WritableValue``, but not the existential type itself.
/// Since `WritableDoc` conforms to that protocol, you can nest documents as normal values.
/// 
/// ```swift
/// let doc = WritableDoc {
///     "deeper?" => WritableDoc {
///         "deeper??" => WritableDoc {
///             "even deeper!?" => true        
///         }
///     }
/// }
/// ```
/// 
/// ## Writing Documents
///     
/// When ready to encode the composed document, call its ``encode(as:)`` method. You can provide
/// any `RangeReplaceableCollection` of `UInt8` bytes. The example below encodes the document
/// as `Data`, then writes it to a URL.
/// 
/// ```swift
/// let encodedDoc = doc.encode(as: Data.self)
/// try encodedDoc.write(to: path)
/// ```
///
public struct WritableDoc<Body: DocComponent> {
    /// The contents of this document.
    let body: Body
    
    /// Initializes a `Document` from the provided components.
    public init(@DocBuilder body: @escaping () throws -> Body) rethrows {
        self.body = try body()
    }

    /// Encodes this BSON document as the specified buffer type.
    /// 
    /// - Parameter type: a `RangeReplaceableCollection` to encode this document as
    public func encode<Buffer>(as type: Buffer.Type) -> Buffer
    where Buffer : RangeReplaceableCollection, Buffer.Element == UInt8 {
        var buffer = Buffer()
        append(to: &buffer)
        return buffer
    }
}

extension WritableDoc: WritableValue {
    public func append<Doc>(to document: inout Doc)
    where Doc : RangeReplaceableCollection, Doc.Element == UInt8 {
        let startIndex = document.endIndex
        Int32(0).append(to: &document)
        let sizeEndIndex = document.endIndex
        body.append(to: &document)
        document.append(0)
        let endIndex = document.endIndex
        let longSize = document.distance(from: startIndex, to: endIndex)
        guard let size = Int32(exactly: longSize) else { fatalError("array too long") }
        withUnsafeBytes(of: size) { sizeBytes in 
            document.replaceSubrange(startIndex..<sizeEndIndex, with: sizeBytes)
        }
    }

    public var bsonType: UInt8 {
        0x03
    }
}
