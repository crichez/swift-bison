//
//  WritableArray.swift
//
//
//  Created by Christopher Richez on March 31 2022
//

/// A BSON array document that can be written to a buffer.
/// 
/// Declare the structure of an array document as follows:
///     
///     // Pass a trailing closure to the initializer.
///     let arrayDoc = WritableArray {
///         // Declare values in the order they should appear.
///         "zero"
///         "one"
///         // You can declare a value of any type conforming to `WritableValue`.
///         2.0
///         Int64(3)
///         // Use conditionals.
///         if !skipFour {
///             4.0
///         }
///         // And loops.
///         for number in Int32(5)..<100 {
///             number
///         }
///     }
/// 
/// When ready to encode the composed document, call its `encode(as:)` method. You can provide
/// any `RangeReplaceableCollection` of `UInt8` bytes. The example below encodes the document
/// as `Data`, then writes it to a URL.
/// 
///     let encodedArrayDoc = arrayDoc.encode(as: Data.self)
///     try encodedArrayDoc.write(to: path)
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
