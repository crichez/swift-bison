//
//
//
//
//
//

protocol BinaryConvertible {
    associatedtype Encoded: Sequence where Encoded.Element == UInt8

    func encode() throws -> Encoded
}
