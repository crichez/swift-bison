//
//  WritableArray.swift
//
//
//  Created by Christopher Richez on March 31 2022
//

/// A BSON document used exclusively for encoding.
public struct WritableArray<Body: DocComponent> {
    /// The contents of this document.
    let body: Body
    
    /// Initializes a `Document` from the provided components.
    public init(@DocBuilder body: @escaping () throws -> Body) rethrows {
        self.body = try body()
    }

    /// Encodes this BSON array document as the specified buffer type.
    /// 
    /// - Parameter type: a `RangeReplaceableCollection` to encode this document as
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
        0x04
    }
}
