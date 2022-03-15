//
//
//
//
//
//

enum OptionalComponent<T: DocComponent>: DocComponent {
    case some(T)
    case none

    init(_ component: T?) {
        switch component {
        case .some(let component):
            self = .some(component)
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
