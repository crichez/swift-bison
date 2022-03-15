//
//
//
//
//
//

enum OptionalComponent<T: DocComponent>: DocComponent {
    case some(T)
    case none

    init(_ value: T?) {
        switch value {
        case .some(let value):
            self = .some(value)
        case .none:
            self = .none
        }
    }

    var bsonEncoded: [UInt8] {
        switch self {
        case .some(let component):
            return component.bsonEncoded
        case .none:
            return []
        }
    }
}