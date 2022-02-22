//
//  Chains.swift
//
//
//  Created by Christopher Richez on February 11 2022
//

struct Chain2<S0, S1> where 
  S0 : Sequence,
  S1 : Sequence,
  S0.Element == S1.Element {
    let s0: S0
    let s1: S1
}

struct Chain3<S0: Sequence, S1: Sequence, S2: Sequence> 
where S0.Element == S1.Element, S1.Element == S2.Element {
    let s0: S0
    let s1: S1
    let s2: S2
}

struct Chain4<S0: Sequence, S1: Sequence, S2: Sequence, S3: Sequence> 
where S0.Element == S1.Element, S1.Element == S2.Element, S2.Element == S3.Element {
    let s0: S0
    let s1: S1
    let s2: S2
    let s3: S3
}

struct Chain5<S0: Sequence, S1: Sequence, S2: Sequence, S3: Sequence, S4: Sequence> where 
  S0.Element == S1.Element, S1.Element == S2.Element, S2.Element == S3.Element, 
  S3.Element == S4.Element {
    let s0: S0
    let s1: S1
    let s2: S2
    let s3: S3
    let s4: S4
}

struct Chain6<
  S0: Sequence, S1: Sequence, S2: Sequence, S3: Sequence, S4: Sequence, S5: Sequence
> where S0.Element == S1.Element, S1.Element == S2.Element, S2.Element == S3.Element, 
  S3.Element == S4.Element, S4.Element == S5.Element {
    let s0: S0
    let s1: S1
    let s2: S2
    let s3: S3
    let s4: S4
    let s5: S5
}

struct Chain7<
  S0: Sequence, S1: Sequence, S2: Sequence, S3: Sequence, S4: Sequence, S5: Sequence, S6: Sequence
> where S0.Element == S1.Element, S1.Element == S2.Element, S2.Element == S3.Element, 
  S3.Element == S4.Element, S4.Element == S5.Element, S5.Element == S6.Element {
    let s0: S0
    let s1: S1
    let s2: S2
    let s3: S3
    let s4: S4
    let s5: S5
    let s6: S6
}

struct Chain8<
  S0: Sequence, 
  S1: Sequence, 
  S2: Sequence, 
  S3: Sequence, 
  S4: Sequence, 
  S5: Sequence, 
  S6: Sequence,
  S7: Sequence
> where S0.Element == S1.Element, S1.Element == S2.Element, S2.Element == S3.Element, 
  S3.Element == S4.Element, S4.Element == S5.Element, S5.Element == S6.Element, 
  S6.Element == S7.Element {
    let s0: S0
    let s1: S1
    let s2: S2
    let s3: S3
    let s4: S4
    let s5: S5
    let s6: S6
    let s7: S7
}

struct Chain9<
  S0: Sequence, 
  S1: Sequence, 
  S2: Sequence, 
  S3: Sequence, 
  S4: Sequence, 
  S5: Sequence, 
  S6: Sequence,
  S7: Sequence,
  S8: Sequence
> where S0.Element == S1.Element, S1.Element == S2.Element, S2.Element == S3.Element, 
  S3.Element == S4.Element, S4.Element == S5.Element, S5.Element == S6.Element, 
  S6.Element == S7.Element, S7.Element == S8.Element {
    let s0: S0
    let s1: S1
    let s2: S2
    let s3: S3
    let s4: S4
    let s5: S5
    let s6: S6
    let s7: S7
    let s8: S8
}

struct Chain10<
  S0: Sequence, 
  S1: Sequence, 
  S2: Sequence, 
  S3: Sequence, 
  S4: Sequence, 
  S5: Sequence, 
  S6: Sequence,
  S7: Sequence,
  S8: Sequence,
  S9: Sequence
> where S0.Element == S1.Element, S1.Element == S2.Element, S2.Element == S3.Element, 
  S3.Element == S4.Element, S4.Element == S5.Element, S5.Element == S6.Element, 
  S6.Element == S7.Element, S7.Element == S8.Element, S8.Element == S9.Element {
    let s0: S0
    let s1: S1
    let s2: S2
    let s3: S3
    let s4: S4
    let s5: S5
    let s6: S6
    let s7: S7
    let s8: S8
    let s9: S9
}
