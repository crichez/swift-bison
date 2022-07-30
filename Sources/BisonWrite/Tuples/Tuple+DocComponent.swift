//
//  Tuple+DocComponent.swift
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

extension Tuple2: DocComponent where T0: DocComponent, T1: DocComponent {
    func append<Doc>(to document: inout Doc)
    where Doc : RangeReplaceableCollection, Doc.Element == UInt8 {
        t0.append(to: &document)
        t1.append(to: &document)
    }

    init(_ t0: T0,_ t1: T1) {
        self.t0 = t0
        self.t1 = t1
    }
}

extension Tuple3: DocComponent where T0: DocComponent, T1: DocComponent, T2: DocComponent {
    func append<Doc>(to document: inout Doc)
    where Doc : RangeReplaceableCollection, Doc.Element == UInt8 {
        t0.append(to: &document)
        t1.append(to: &document)
        t2.append(to: &document)
    }

    init(_ t0: T0,_ t1: T1,_ t2: T2) {
        self.t0 = t0
        self.t1 = t1
        self.t2 = t2
    }
}

extension Tuple4: DocComponent where T0: DocComponent, T1: DocComponent, T2: DocComponent, 
  T3: DocComponent {
    func append<Doc>(to document: inout Doc)
    where Doc : RangeReplaceableCollection, Doc.Element == UInt8 {
        t0.append(to: &document)
        t1.append(to: &document)
        t2.append(to: &document)
        t3.append(to: &document)
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
    func append<Doc>(to document: inout Doc)
    where Doc : RangeReplaceableCollection, Doc.Element == UInt8 {
        t0.append(to: &document)
        t1.append(to: &document)
        t2.append(to: &document)
        t3.append(to: &document)
        t4.append(to: &document)
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
    func append<Doc>(to document: inout Doc)
    where Doc : RangeReplaceableCollection, Doc.Element == UInt8 {
        t0.append(to: &document)
        t1.append(to: &document)
        t2.append(to: &document)
        t3.append(to: &document)
        t4.append(to: &document)
        t5.append(to: &document)
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
    func append<Doc>(to document: inout Doc)
    where Doc : RangeReplaceableCollection, Doc.Element == UInt8 {
        t0.append(to: &document)
        t1.append(to: &document)
        t2.append(to: &document)
        t3.append(to: &document)
        t4.append(to: &document)
        t5.append(to: &document)
        t6.append(to: &document)
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
    func append<Doc>(to document: inout Doc)
    where Doc : RangeReplaceableCollection, Doc.Element == UInt8 {
        t0.append(to: &document)
        t1.append(to: &document)
        t2.append(to: &document)
        t3.append(to: &document)
        t4.append(to: &document)
        t5.append(to: &document)
        t6.append(to: &document)
        t7.append(to: &document)
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
    func append<Doc>(to document: inout Doc)
    where Doc : RangeReplaceableCollection, Doc.Element == UInt8 {
        t0.append(to: &document)
        t1.append(to: &document)
        t2.append(to: &document)
        t3.append(to: &document)
        t4.append(to: &document)
        t5.append(to: &document)
        t6.append(to: &document)
        t7.append(to: &document)
        t8.append(to: &document)
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
    func append<Doc>(to document: inout Doc)
    where Doc : RangeReplaceableCollection, Doc.Element == UInt8 {
        t0.append(to: &document)
        t1.append(to: &document)
        t2.append(to: &document)
        t3.append(to: &document)
        t4.append(to: &document)
        t5.append(to: &document)
        t6.append(to: &document)
        t7.append(to: &document)
        t8.append(to: &document)
        t9.append(to: &document)
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
