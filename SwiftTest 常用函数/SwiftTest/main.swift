//
//  main.swift
//  SwiftTest
//
//  Created by karos li on 2021/7/23.
//

import Foundation

var arr = [1, 2, 3, 4]
var arr1 = arr.map { $0 * 2 }// [2, 4, 6, 8]
var arr2 = arr.filter { $0 % 2 == 0 } // [2, 4]
var sum = arr.reduce(0) { sum, element in
    sum + element
}// 10
var sum1 = arr.reduce(0) { $0 + $1 }// 10
var sum2 = arr.reduce(0, +)// 10

var arr3 = arr.map { Array(repeating: $0, count: $0) } // [[1], [2, 2], [3, 3, 3], [4, 4, 4, 4]]
var arr4 = arr.flatMap { Array(repeating: $0, count: $0) }// [1, 2, 2, 3, 3, 3, 4, 4, 4, 4]


var arrr = ["123", "test", "jack", "-30"]
var arrr1 = arrr.map { Int($0) }// [Optional(123), nil, nil, Optional(-30)]
var arrr2 = arrr.compactMap { Int($0) }// [123, -30]
print(arrr2)

/// 延迟 mapping
var arrrr = [1, 2, 3, 4, 5]
var arrrr1 = arrrr.lazy.map { i -> Int in
    let value = i * 2
    print("mapping", value)
    return value
}
 
/*
 map begin
 mapping 2
 mapped 2
 mapping 4
 mapped 4
 mapping 6
 mapped 6
 map end
 */
print("map begin")
print("mapped", arrrr1[0])
print("mapped", arrrr1[1])
print("mapped", arrrr1[2])
print("map end")


var num1: Int? = 10
// Optional(20)
var num2 = num1.map { num -> Int in
    print("optional map")
    return num * 2
}

num1 = nil
var num3 = num1.map { num -> Int in
    // 因为 num1 是空的，这个闭包表达式不会调用
    print("optional map1")
    return num * 2
}

print(num2 as Any)
print(num3 as Any)


