//
//  DocError.swift
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

/// An error that occured while reading a BSON document.
/// 
/// ## Catching Document Parsing Errors
/// 
/// `DocError` is generic over the collection type the document was read from, just like
/// ``ReadableDoc``. This allows select errors to provide partially decoded documents and more
/// detailed debugging information.
/// 
/// To handle a `DocError`, include the document's collection type in your `catch` statement.
/// 
/// ```swift
/// do {
///     // Here the document is read from `Foundation.Data`
///     let encodedDoc = try Data(contentsOf: url)
///     let decodedDoc = try ReadableDoc(bsonBytes: encodedDoc)
/// } catch DocError<Data>.docTooShort {
///     // A trivial error with no partial success
/// } catch DocError<Data>.unknownType(let type, let key, let progress) {
///     // An error that reports achieved progress, perhaps recoverable
/// }
/// ```
public enum DocError<Data: Collection>: Error where Data.Element == UInt8 {
    /// Less than 5 bytes were passed to the initializer.
    /// 
    /// BSON documents will always be 5 or more bytes long to include the size and null-terminator.
    /// In most cases this error means the expected data wasn't loaded into the buffer, or isn't a 
    /// valid BSON document.
    /// 
    /// > Note: This error is triggered before ``notTerminated``, even if the data also isn't
    ///   properly null-terminated.
    case docTooShort

    /// The data passed to the initializer was not null-terminated.
    /// 
    /// Parsing an otherwise valid BSON document that isn't properly null-terminated may cause 
    /// out-of-bounds errors and crashes while reading keys, and isn't supported. In most cases,
    /// this error means the data was corrupted in transit or isn't a valid BSON document.
    case notTerminated

    /// The declared size of the document does not match the size of the data passed to the
    /// initializer.
    /// 
    /// The declared size of the document is attached to the error, and can be compared against
    /// the encoded document's `count` property for debugging. In most cases, this error means
    /// the data was corrupted in transit or isn't a valid BSON document.
    /// 
    /// > Note: In the case of corruption, ``notTerminated`` will usually be triggered first.
    ///   There is a chance that the corrupted data happens to be null-terminated, in whcih case
    ///   this error may be triggered instead.
    case docSizeMismatch(_ expectedExactly: Int)

    /// An unknown or deprecated BSON type byte was found while parsing a key.
    /// 
    /// This error includes a ``Progress`` value. You may check the partially decoded document
    /// within to recover from the error.
    case unknownType(_ type: UInt8, _ key: String, _ progress: Progress<Data>)

    /// There were not enough bytes left in the document to parse the next expected value.
    /// 
    /// This error includes a ``Progress`` value. You may check the partially decoded document
    /// within to recover from the error.
    case valueSizeMismatch(_ needAtLeast: Int, _ key: String, _ progress: Progress<Data>)
}

/// The parsed and un-parsed parts of a document after an error occured.
public struct Progress<Data: Collection> where Data.Element == UInt8 {
    /// A ``ReadableDoc`` that contains all successfully parsed key-value pairs.
    public let parsed: ReadableDoc<Data>

    /// The remaining unparsed data after the error occured.
    public let remaining: Data.SubSequence
}

extension Progress: Equatable where Data.SubSequence : Equatable {
    // This conformance is inherited from `Data.SubSequence`.
}

extension DocError: Equatable where Data.SubSequence : Equatable {
    // This conformance is inherited from `Progress`.
}

extension Progress: Hashable where Data.SubSequence : Hashable {
    // This conformance is inherited from `Data.SubSequence`.
}

extension DocError: Hashable where Data.SubSequence : Hashable {
    // This conformance is inherited from `Progress`.
}

