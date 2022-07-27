//
//  DocComponent.swift
//  DocComponent
//
//  Created by Christopher Richez on March 1 2022
//

/// A basic building block of a BSON document.
public protocol DocComponent {
    /// Appends this components BSON bytes to the end of a document.
    func append<Doc>(to document: inout Doc)
    where Doc : RangeReplaceableCollection, Doc.Element == UInt8
}
