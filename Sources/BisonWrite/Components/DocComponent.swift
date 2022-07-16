//
//  DocComponent.swift
//  DocComponent
//
//  Created by Christopher Richez on March 1 2022
//

import Foundation

/// A basic building block of a BSON document.
public protocol DocComponent {
    /// This component's BSON-encoded bytes.
    var bsonBytes: Data { get }
}
