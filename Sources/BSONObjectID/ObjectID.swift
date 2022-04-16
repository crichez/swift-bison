//
//  ObjectID.swift
//
//
//  Created by Christopher Richez on April 14 2022
//

import Foundation

extension UInt8 {
    fileprivate static var random: UInt8 { .random(in: .min ... .max) }
}

/// An object identifier that features a timestamp and increment for change tracking.
/// 
/// [Documentation from MongoDB](https://www.mongodb.com/docs/manual/reference/method/ObjectId/)
public struct ObjectID {
    /// The number of seconds since the Unix epoch this ID was initialized.
    /// 
    /// - Note:
    /// This property stores the timestamp bytes as a big-endian `Int32`.
    private let secondsSince1970: Int32

    /// The date this ID was created.
    public var timestamp: Date {
        Date(timeIntervalSince1970: Double(secondsSince1970.bigEndian))
    }

    /// The 5 random bytes of this ID, represented as a tuple of unsigned integers.
    /// 
    /// - Note:
    /// The numerical value of these integers does not have significant meaning, and therefore
    /// their endianness is irrelevant and should not be manipulated.
    private let randomBytes: (UInt8, UInt8, UInt8, UInt8, UInt8)

    /// The 3 increment bytes of this ID, represented as a tuple of unsigned integers.
    /// 
    /// The increment is a three-byte big-endian signed integer.
    private var incrementBytes: (UInt8, UInt8, UInt8)

    /// The increment value of this `ObjectID`.
    /// 
    /// Increments are randomized at initialization unless read from BSON or hexadecimal data.
    /// The numerical value of an increment is usually meaningless, but a comparison of two
    /// `ObjectID` values via their increment can be useful depending on your data model.
    public private(set) var increment: Int {
        get {
            let signum = Int8(truncatingIfNeeded: incrementBytes.2).bigEndian.signum()
            switch MemoryLayout<Int>.size {
            case 4:
                let copyBuffer = UnsafeMutableRawBufferPointer.allocate(byteCount: 4, alignment: 1)
                let padding: UInt8 = signum == 0 || signum == 1 ? .min : .max
                withUnsafeBytes(of: (padding, incrementBytes)) { paddedIncrementBytes in 
                    copyBuffer.copyMemory(from: paddedIncrementBytes)
                }
                return copyBuffer.load(as: Int.self).bigEndian
            case 8:
                let copyBuffer = UnsafeMutableRawBufferPointer.allocate(byteCount: 8, alignment: 1)
                let padding: (UInt32, UInt8) = signum == 0 || signum == 1 ? (.min, .min) : (.max, .max)
                withUnsafeBytes(of: (padding, incrementBytes)) { paddedIncrementBytes in 
                    copyBuffer.copyMemory(from: paddedIncrementBytes)
                }
                return copyBuffer.load(as: Int.self).bigEndian
            default:
                fatalError("arch must be 32 or 64 bit")
            }
        }
        set {
            incrementBytes = withUnsafeBytes(of: newValue.bigEndian) { newValueBytes in 
                (newValueBytes[5], newValueBytes[6], newValueBytes[7])
            }
        }
    }

    /// Increments this ID by one.
    public mutating func incrementByOne() {
        increment &+= 1
    }

    /// Initializes a random `ObjectID`.
    public init() {
        self.secondsSince1970 = Int32(Date().timeIntervalSince1970).bigEndian
        self.randomBytes = (.random, .random, .random, .random, .random)
        self.incrementBytes = (.random, .random, .random)
    }
}

extension ObjectID: LosslessStringConvertible {
    public init?(_ description: String) {
        // Constants
        let hexCharacters = Array("0123456789abcdef".utf8)
        let hexStringCodeUnits = Array(description.utf8)

        // Iterator
        var stringCursor = 0
        var bytes: [UInt8] = []
        bytes.reserveCapacity(12)
        while stringCursor < 24 {
            guard let firstHexCharacterIndex = hexCharacters.firstIndex(of: hexStringCodeUnits[stringCursor]),
                  let nextHexCharacterIndex = hexCharacters.firstIndex(of: hexStringCodeUnits[stringCursor + 1]) else {
                return nil
            }
            bytes.append(UInt8(firstHexCharacterIndex * 16 + nextHexCharacterIndex))
            stringCursor += 2
        }

        // Timestamp read and conversion
        let timestampBuffer = UnsafeMutableRawBufferPointer.allocate(byteCount: 4, alignment: 1)
        timestampBuffer.copyBytes(from: bytes[0..<4])
        self.secondsSince1970 = timestampBuffer.load(as: Int32.self)

        // Read the random bytes
        let randomBuffer = UnsafeMutableRawBufferPointer.allocate(byteCount: 5, alignment: 1)
        randomBuffer.copyBytes(from: bytes[4..<9])
        self.randomBytes = randomBuffer.load(as: (UInt8, UInt8, UInt8, UInt8, UInt8).self)

        // Read the increment bytes
        let incrementBuffer = UnsafeMutableRawBufferPointer.allocate(byteCount: 3, alignment: 1)
        incrementBuffer.copyBytes(from: bytes[9..<12])
        self.incrementBytes = incrementBuffer.load(as: (UInt8, UInt8, UInt8).self)
    }
    
    public var description: String {
        var bytes = withUnsafeBytes(of: secondsSince1970) { timestampBytes in
            Array(timestampBytes)
        }
        withUnsafeBytes(of: (randomBytes, incrementBytes)) { otherBytes in 
            bytes.append(contentsOf: otherBytes)
        }
        let hexCharacters = Array("0123456789abcdef".utf8)
        var hexStringCodeUnits: [UInt8] = []
        hexStringCodeUnits.reserveCapacity(24)
        for byte in bytes {
            hexStringCodeUnits.append(hexCharacters[Int(byte / 16)])
            hexStringCodeUnits.append(hexCharacters[Int(byte % 16)])
        }
        return String(decoding: hexStringCodeUnits, as: UTF8.self)
    }
}

extension ObjectID: ExpressibleByStringLiteral {
    public init(stringLiteral: String) {
        self.init(stringLiteral)!
    }
}

extension ObjectID: Equatable {
    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.secondsSince1970 == rhs.secondsSince1970 &&
        lhs.randomBytes == rhs.randomBytes &&
        lhs.incrementBytes == rhs.incrementBytes
    }
}

extension ObjectID: Hashable {
    public func hash(into hasher: inout Hasher) {
        withUnsafeBytes(of: self) { hasher.combine(bytes: $0) }
    }
}
