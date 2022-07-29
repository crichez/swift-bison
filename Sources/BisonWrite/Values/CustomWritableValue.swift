//
//  CustomWritableValue.swift
//
//
//  Created by Christopher Richez on April 14 2022
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
