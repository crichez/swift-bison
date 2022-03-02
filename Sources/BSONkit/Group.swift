//
//
//
//
//
//

struct Group<T: DocComponent>: DocComponent {
    typealias Encoded = T.Encoded

    let content: T

    init(@DocBuilder content: () -> T) {
        self.content = content()
    }

    var bsonEncoded: Encoded {
        content.bsonEncoded
    }
}