//
//  BisonError.swift
//
//
//  Created by Christopher Richez on April 16 2022
//

/// An error that occured while parsing a BSON value.
public enum BisonError: Error, Equatable {
    /// The data passed to the initializer was shorter than the required metadata for this value.
    /// 
    /// This case provides the expected and actual size of the data passed to the initializer.
    case dataTooShort(_ needAtLeast: Int, _ found: Int)

    /// The data passed to the initializer was not the expected size for this type.
    /// 
    /// This case provides the expected and actual size of the data passed to the initializer.
    case sizeMismatch(_ expected: Int, _ have: Int)
}