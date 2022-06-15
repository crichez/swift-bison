//
//  Tuple+DocComponent.swift
//
//
//  Created by Christopher Richez on March 15 2022
//

extension Tuple2: DocComponent where T0: DocComponent, T1: DocComponent {
    var bsonBytes: [UInt8] {
        var concatenatedComponents = t0.bsonBytes
        concatenatedComponents.append(contentsOf: t1.bsonBytes)
        return concatenatedComponents
    }

    init(_ t0: T0,_ t1: T1) {
        self.t0 = t0
        self.t1 = t1
    }
}

extension Tuple3: DocComponent where T0: DocComponent, T1: DocComponent, T2: DocComponent {
    var bsonBytes: [UInt8] {
        var concatenatedComponents = t0.bsonBytes
        concatenatedComponents.append(contentsOf: t1.bsonBytes)
        concatenatedComponents.append(contentsOf: t2.bsonBytes)
        return concatenatedComponents
    }

    init(_ t0: T0,_ t1: T1,_ t2: T2) {
        self.t0 = t0
        self.t1 = t1
        self.t2 = t2
    }
}

extension Tuple4: DocComponent where T0: DocComponent, T1: DocComponent, T2: DocComponent, 
  T3: DocComponent {
    var bsonBytes: [UInt8] {
        var concatenatedComponents = t0.bsonBytes
        concatenatedComponents.append(contentsOf: t1.bsonBytes)
        concatenatedComponents.append(contentsOf: t2.bsonBytes)
        concatenatedComponents.append(contentsOf: t3.bsonBytes)
        return concatenatedComponents
    }

    init(_ t0: T0,_ t1: T1,_ t2: T2,_ t3: T3) {
        self.t0 = t0
        self.t1 = t1
        self.t2 = t2
        self.t3 = t3
    }
}

extension Tuple5: DocComponent where T0: DocComponent, T1: DocComponent, T2: DocComponent, 
  T3: DocComponent, T4: DocComponent {
    var bsonBytes: [UInt8] {
        var concatenatedComponents = t0.bsonBytes
        concatenatedComponents.append(contentsOf: t1.bsonBytes)
        concatenatedComponents.append(contentsOf: t2.bsonBytes)
        concatenatedComponents.append(contentsOf: t3.bsonBytes)
        concatenatedComponents.append(contentsOf: t4.bsonBytes)
        return concatenatedComponents
    }

    init(_ t0: T0,_ t1: T1,_ t2: T2,_ t3: T3,_ t4: T4) {
        self.t0 = t0
        self.t1 = t1
        self.t2 = t2
        self.t3 = t3
        self.t4 = t4
    }
}

extension Tuple6: DocComponent where T0: DocComponent, T1: DocComponent, T2: DocComponent, 
  T3: DocComponent, T4: DocComponent, T5: DocComponent {
    var bsonBytes: [UInt8] {
        var concatenatedComponents = t0.bsonBytes
        concatenatedComponents.append(contentsOf: t1.bsonBytes)
        concatenatedComponents.append(contentsOf: t2.bsonBytes)
        concatenatedComponents.append(contentsOf: t3.bsonBytes)
        concatenatedComponents.append(contentsOf: t4.bsonBytes)
        concatenatedComponents.append(contentsOf: t5.bsonBytes)
        return concatenatedComponents
    }

    init(_ t0: T0,_ t1: T1,_ t2: T2,_ t3: T3,_ t4: T4,_ t5: T5) {
        self.t0 = t0
        self.t1 = t1
        self.t2 = t2
        self.t3 = t3
        self.t4 = t4
        self.t5 = t5
    }
}

extension Tuple7: DocComponent where T0: DocComponent, T1: DocComponent, T2: DocComponent, 
  T3: DocComponent, T4: DocComponent, T5: DocComponent, T6: DocComponent {
    var bsonBytes: [UInt8] {
        var concatenatedComponents = t0.bsonBytes
        concatenatedComponents.append(contentsOf: t1.bsonBytes)
        concatenatedComponents.append(contentsOf: t2.bsonBytes)
        concatenatedComponents.append(contentsOf: t3.bsonBytes)
        concatenatedComponents.append(contentsOf: t4.bsonBytes)
        concatenatedComponents.append(contentsOf: t5.bsonBytes)
        concatenatedComponents.append(contentsOf: t6.bsonBytes)
        return concatenatedComponents
    }

    init(_ t0: T0,_ t1: T1,_ t2: T2,_ t3: T3,_ t4: T4,_ t5: T5,_ t6: T6) {
        self.t0 = t0
        self.t1 = t1
        self.t2 = t2
        self.t3 = t3
        self.t4 = t4
        self.t5 = t5
        self.t6 = t6
    }
}

extension Tuple8: DocComponent where T0: DocComponent, T1: DocComponent, T2: DocComponent, 
  T3: DocComponent, T4: DocComponent, T5: DocComponent, T6: DocComponent, T7: DocComponent {
    var bsonBytes: [UInt8] {
        var concatenatedComponents = t0.bsonBytes
        concatenatedComponents.append(contentsOf: t1.bsonBytes)
        concatenatedComponents.append(contentsOf: t2.bsonBytes)
        concatenatedComponents.append(contentsOf: t3.bsonBytes)
        concatenatedComponents.append(contentsOf: t4.bsonBytes)
        concatenatedComponents.append(contentsOf: t5.bsonBytes)
        concatenatedComponents.append(contentsOf: t6.bsonBytes)
        concatenatedComponents.append(contentsOf: t7.bsonBytes)
        return concatenatedComponents
    }

    init(_ t0: T0,_ t1: T1,_ t2: T2,_ t3: T3,_ t4: T4,_ t5: T5,_ t6: T6,_ t7: T7) {
        self.t0 = t0
        self.t1 = t1
        self.t2 = t2
        self.t3 = t3
        self.t4 = t4
        self.t5 = t5
        self.t6 = t6
        self.t7 = t7
    }
}

extension Tuple9: DocComponent where T0: DocComponent, T1: DocComponent, T2: DocComponent, 
  T3: DocComponent, T4: DocComponent, T5: DocComponent, T6: DocComponent, T7: DocComponent, 
  T8: DocComponent {
    var bsonBytes: [UInt8] {
        var concatenatedComponents = t0.bsonBytes
        concatenatedComponents.append(contentsOf: t1.bsonBytes)
        concatenatedComponents.append(contentsOf: t2.bsonBytes)
        concatenatedComponents.append(contentsOf: t3.bsonBytes)
        concatenatedComponents.append(contentsOf: t4.bsonBytes)
        concatenatedComponents.append(contentsOf: t5.bsonBytes)
        concatenatedComponents.append(contentsOf: t6.bsonBytes)
        concatenatedComponents.append(contentsOf: t7.bsonBytes)
        concatenatedComponents.append(contentsOf: t8.bsonBytes)
        return concatenatedComponents
    }

    init(_ t0: T0,_ t1: T1,_ t2: T2,_ t3: T3,_ t4: T4,_ t5: T5,_ t6: T6,_ t7: T7,_ t8: T8) {
        self.t0 = t0
        self.t1 = t1
        self.t2 = t2
        self.t3 = t3
        self.t4 = t4
        self.t5 = t5
        self.t6 = t6
        self.t7 = t7
        self.t8 = t8
    }
}

extension Tuple10: DocComponent where T0: DocComponent, T1: DocComponent, T2: DocComponent,
  T3: DocComponent, T4: DocComponent, T5: DocComponent, T6: DocComponent, T7: DocComponent,
  T8: DocComponent, T9: DocComponent {
    var bsonBytes: [UInt8] {
        var concatenatedComponents = t0.bsonBytes
        concatenatedComponents.append(contentsOf: t1.bsonBytes)
        concatenatedComponents.append(contentsOf: t2.bsonBytes)
        concatenatedComponents.append(contentsOf: t3.bsonBytes)
        concatenatedComponents.append(contentsOf: t4.bsonBytes)
        concatenatedComponents.append(contentsOf: t5.bsonBytes)
        concatenatedComponents.append(contentsOf: t6.bsonBytes)
        concatenatedComponents.append(contentsOf: t7.bsonBytes)
        concatenatedComponents.append(contentsOf: t8.bsonBytes)
        concatenatedComponents.append(contentsOf: t9.bsonBytes)
        return concatenatedComponents
    }

    init(
        _ t0: T0,
        _ t1: T1,
        _ t2: T2,
        _ t3: T3,
        _ t4: T4,
        _ t5: T5,
        _ t6: T6,
        _ t7: T7,
        _ t8: T8,
        _ t9: T9
    ) {
        self.t0 = t0
        self.t1 = t1
        self.t2 = t2
        self.t3 = t3
        self.t4 = t4
        self.t5 = t5
        self.t6 = t6
        self.t7 = t7
        self.t8 = t8
        self.t9 = t9
    }
}
