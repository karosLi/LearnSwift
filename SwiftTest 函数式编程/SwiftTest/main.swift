//
//  main.swift
//  SwiftTest
//
//  Created by karos li on 2021/7/23.
//

import Foundation

/// 高阶函数（满足一个条件即可）：1、接受一个或多个函数作为输入 2、返回一个函数

/// 函数合成
var num = 1
func add(_ v: Int) -> (Int) -> Int {
    return {
        $0 + v
    }
}

func sub(_ v: Int) -> (Int) -> Int {
    return {
        $0 - v
    }
}

func mutiple(_ v: Int) -> (Int) -> Int {
    return {
        $0 * v
    }
}

func divide(_ v: Int) -> (Int) -> Int {
    return {
        $0 / v
    }
}

func mod(_ v: Int) -> (Int) -> Int {
    return {
        $0 % v
    }
}

infix operator >>>: AdditionPrecedence
func >>> <A, B, C>(_ fn1: @escaping (A) -> B, _ fn2: @escaping (B) -> C) -> (A) -> C {
    return {
        fn2(fn1($0))
    }
}
func composite(_ fn1: @escaping (Int) -> Int, _ fn2: @escaping (Int) -> Int) -> (Int) -> Int {
    return {
        fn2(fn1($0))
    }
}

let mixFn = add(3) >>> mutiple(5) >>> sub(1) >>> mod(10) >>> divide(2)
print("mixFn", mixFn(num))


/// 柯里化：将一个接受多参数的函数变换为一系列接受单个参数的函数

func add1(_ v1: Int, _ v2: Int) -> Int {
    return v1 + v2
}

func add2(_ v1: Int, _ v2: Int, _ v3: Int) -> Int {
    return v1 + v2 + v3
}

func curring<A, B, C>(_ fn: @escaping (A, B) -> C) -> (B) -> ((A) -> C) {
    return { b in
        return { a in
            return fn(a, b)
        }
    }
}

func curring<A, B, C, D>(_ fn: @escaping (A, B, C) -> D) -> (C) -> ((B) -> ((A) -> D)) {
    return { c in
        return { b in
            return { a in
                return fn(a, b, c)
            }
        }
    }
}

prefix func ~ <A, B, C>(_ fn: @escaping (A, B) -> C) -> (B) -> ((A) -> C) {
    return curring(fn)
}
prefix func ~ <A, B, C, D>(_ fn: @escaping (A, B, C) -> D) -> (C) -> ((B) -> ((A) -> D)) {
    return curring(fn)
}

let add1Value = curring(add1)(20)(10)
let add1Value1 = (~add1)(20)(10)
print("curring", add1Value, add1Value1)

let add2Value = curring(add2)(30)(20)(10)
let add2Value1 = (~add2)(30)(20)(10)
print("curring1", add2Value, add2Value1)


/// 函子
/*
 实现了这种 map 样式的类型，就称为函子，比如 Array 或者 Optional
 func map<T>(_ fn: (Inner) -> T) -> Type<T>
 */

var arr = [1, 2, 3, 4]// [Element]
// @inlinable public func map<T>(_ transform: (Element) throws -> T) rethrows -> [T]
var arr1 = arr.map { $0 * 2}
var number: Int? = 10// Optional<Wrapped>
// @inlinable public func map<U>(_ transform: (Wrapped) throws -> U) rethrows -> U?
var number1 = number.map { $0 * 2 }

/// 适用函子
/*
 对于一个任意函子F，如果能支持以下运算，该函子就是一个适用函子。Optional 和 Array 可以称为适用函子 F
 func pure<A>(_ value: A) -> F<A>
 func <*><A, B>(fn: F<(A) -> B>, value: F<A>) -> F<B>
 */

func pure<A>(_ value: A) -> A? {
    value
}

infix operator <*> : AdditionPrecedence
func <*><A, B>(fn: ((A) -> B)?, value: A?) -> B? {
    guard let f = fn, let v = value else {
        return nil
    }
    
    return f(v)
}


/// 单子
/*
 对于任意一个类型 F， 如果能支持以下运算，那么就可以称为一个单子 (Monad)。 Optional 和 Array 可以称为适用单子
 func pure<A>(_ value: A) -> F<A>
 func flatMap<A, B>(_ value: F<A>, _ fn: (A) -> F<B> ) -> F<B>
 */

var arr3 = [1, 2, 3, 4]// [Element]
// public func flatMap<ElementOfResult>(_ transform: (Element) throws -> ElementOfResult?) rethrows -> [ElementOfResult]
var arr4 = arr3.flatMap { $0 * 2 }

var number2: Int? = 10// Optional<Wrapped>
// @inlinable public func flatMap<U>(_ transform: (Wrapped) throws -> U?) rethrows -> U?
var number3 = number2.flatMap { $0 * 2 }

