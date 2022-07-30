//
//  BisonError.swift
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