//
//  ValueTuple.swift
//  
//
//  Created by Christopher Richez on 2/7/22.
//

import Algorithms

struct Tuple2<T1: ValueProtocol, T2: ValueProtocol>: ValueProtocol {
    let one: T1
    let two: T2
    
    typealias Encoded = Chained<T1.Encoded, T2.Encoded>
    
    var type: Byte { fatalError("cannot get a type byte for a tuple") }
    
    func encode() throws -> Encoded {
        chain(try one.encode(), try two.encode())
    }
}

struct Tuple3<T1: ValueProtocol, T2: ValueProtocol, T3: ValueProtocol>: ValueProtocol {
    let one: T1
    let two: T2
    let three: T3
    
    typealias Encoded = Chained<Chained<T1.Encoded, T2.Encoded>, T3.Encoded>
    
    var type: Byte { fatalError("cannot get a type byte for a tuple") }
    
    func encode() throws -> Encoded {
        chain(chain(try one.encode(), try two.encode()), try three.encode())
    }
}
