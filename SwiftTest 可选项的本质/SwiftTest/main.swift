//
//  main.swift
//  SwiftTest
//
//  Created by karos li on 2021/7/23.
//

import Foundation

/**
 可选项本质就是枚举
 
 public enum Optional<Wrapped> : ExpressibleByNilLiteral {

     /// The absence of a value.
     ///
     /// In code, the absence of a value is typically written using the `nil`
     /// literal rather than the explicit `.none` enumeration case.
     case none

     /// The presence of a value, stored as `Wrapped`.
     case some(Wrapped)

     /// Creates an instance that stores the given value.
     public init(_ some: Wrapped)
 }
 */

// age 和 age1 的代码是等价的，Int? 是语法糖
var age: Int? = 10
age = nil

var age1: Optional<Int> = .some(10)
//var age1: Optional<Int> = Optional(10)
age1 = .none


var age2: Int? = .some(10)
age2 = nil
age2 = .none


var age3: Int? = 10
switch age3 {
case let v?:
    // v? 表示 age3 可解包并绑定到 v，v 是 Int 类型
    print(v)
case nil:
    // 不能解包，就说明 age3 是 nil
    print("nil")
}

switch age3 {
case .some(let v):
    print(v)
case .none:
    print("nil")
}


var age41: Int? = 10
var age42: Int?? = age41
age42 = nil

var age51: Optional<Int> = .some(10)
var age52: Optional<Optional<Int>> = age51
age52 = .none

