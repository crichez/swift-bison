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

/// A BSON document used exclusively for encoding.
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
