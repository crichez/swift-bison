//
//
//
//
//
//

protocol BinaryConvertible {
    associatedtype Encoded: Collection where Encoded.Element == UInt8

    func encode() throws -> Encoded
}
