//
//  OptionalComponent.swift
//  OptionalComponent
//
//  Created by Christopher Richez on March 16 2022
//

/// A wrapper type for an optional component used exclusively by ``DocBuilder/buildOptional(_:)``.
enum OptionalComponent<T: DocComponent>: DocComponent {
    /// A non-nil component.
    case some(T)
    
    /// A nil component.
    case none
    
    /// Initializes an `OptionalComponent` from the provided `Optional` document component.
    init(_ component: T?) {
        switch component {
        case .some(let component):
            self = .some(component)
        case .none:
            self = .none
        }
    }

    var bsonBytes: [UInt8] {
        switch self {
        case .some(let component):
            return component.bsonBytes
        case .none:
            return []
        }
    }
}
