//
//  AssignmentOperator.swift
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

/// An operator used to assign a BSON `String` key to a `WritableValue` conforming value.
infix operator => : AssignmentPrecedence

extension String {
    /// Returns a BSON key-value `Pair` using the provided key and value.
    ///
    /// - Parameters:
    ///     - key: a `String` key
    ///     - value: a `WritableValue` conforming value
    ///
    /// - Returns:
    /// A `Pair` value constructed from the provided key and value.
    public static func => <T: WritableValue>(key: String, value: T) -> Pair<T> {
        Pair(key: key, value: value)
    }
}
