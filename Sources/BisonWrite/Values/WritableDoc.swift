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
/// Declare the structure of a BSON document as follows:
///     
///     // Pass a trailing closure to the initializer.
///     let doc = WritableDoc {
///         // Assign String keys and WritableValues using the => operator
///         "zero" => Int32(0)
///         "one" => Int64(1)
///         // Use conditionals
///         if !skipTwo {
///             "two" => 2.0
///         }
///         // And loops
///         ForEach(Int64(3)..<100) { number in
///             String(number) => number
///         }
///     }
/// 
/// When ready to encode the composed document, call its `encode(as:)` method. You can provide
/// any `RangeReplaceableCollection` of `UInt8` bytes. The example below encodes the document
/// as `Data`, then writes it to a URL.
/// 
///     let encodedDoc = doc.encode(as: Data.self)
///     try encodedDoc.write(to: path)
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
