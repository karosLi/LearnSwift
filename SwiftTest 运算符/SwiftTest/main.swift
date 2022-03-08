//
//  main.swift
//  SwiftTest
//
//  Created by karos li on 2021/7/23.
//

import Foundation

// 0 255
print(UInt8.min, UInt8.max)

/// 溢出运算符，溢出就会循环
// 255
var i: UInt8 = UInt8.max
i = i &+ 1
// 0
print(i)

// 0
i = UInt8.min
i = i &- 1
// 255
print(i)


/// 运算符重载
struct Point {
    var x = 0
    var y = 0
    
    /// a + b
    static func + (p1: Point, p2: Point) -> Point {
        return Point(x: p1.x + p2.x, y: p1.y + p2.y)
    }
    
    /// a - b
    static func - (p1: Point, p2: Point) -> Point {
        return Point(x: p1.x - p2.x, y: p1.y - p2.y)
    }
    
    /// -a
    static prefix func - (p: Point) -> Point {
        return Point(x: -p.x, y: -p.y)
    }
    
    /// a += b
    static func += (p1: inout Point, p2: Point) {
        p1 = p1 + p2
    }
    
    /// ++a
    static prefix func ++ (p: inout Point) -> Point  {
        p += Point(x: 1, y: 1)
        return p
    }
    
    /// a++
    static postfix func ++ (p: inout Point) -> Point  {
        let temp = p
        p += Point(x: 1, y: 1)
        return temp
    }
    
    /// a == b
    static func == (p1: Point, p2: Point) -> Bool {
        return p1.x == p2.x && p1.y == p2.y
    }
    
    /// a != b
    static func != (p1: Point, p2: Point) -> Bool {
        return p1.x != p2.x || p1.y != p2.y
    }
}

var p1 = Point(x: 10, y: 20)
var p2 = Point(x: 30, y: 40)
var p3 = p1 + p2
var p4 = p1 - p2
var p5 = -p1
p1 += p2
var p6 = ++p1
var p7 = p1++
var bPoint = p1 == p2
var bPoint1 = p1 != p2


/// Equatable : 同时实现了 == 和 !=
class Person: Equatable {
    var name = ""
    var age = 10
    
    init(name: String, age: Int) {
        self.name = name
        self.age = age
    }
    
    static func == (lhs: Person, rhs: Person) -> Bool {
        return lhs.name == rhs.name && lhs.age == rhs.age
    }
}

var person1 = Person(name: "kk", age: 13)
var person2 = Person(name: "kk", age: 13)
print("person equals", person1 == person2)


/// 枚举类型，如果没有关联值，编译器会自动实现 Equatable 协议，可以使用 == 和 !=
enum Type {
    case type1
    case type2
}

var type1 = Type.type1
var type2 = Type.type2
print("Type enum", type1 == type2)
print("Type enum", type1 != type2)


/// 枚举类型，如果有关联值，并且关联值有遵守 Equatable，那么只需要声明 Equatable 协议， 编译器也会自动实现 Equatable，就可以使用 == 和 !=
enum Type1: Equatable {
    case type1(Int)
    case type2
}

var type11 = Type1.type1(10)
var type22 = Type1.type2
print("Type1 enum", type11 == type22)
print("Type1 enum", type11 != type22)


/// 恒等 ===，用于比较引用类型变量存储的地址是否相等
var person3 = Person(name: "kk", age: 13)
var person4 = Person(name: "kk", age: 13)
print("person refrence equals", person3 === person4)
print("person refrence equals", person3 !== person4)


/// Comparable 协议，规则：weight 大的比较大，如果 weight 相等，age 小的比较大
class Dog: Comparable {
    var weight = 0
    var age = 0
    
    static func == (lhs: Dog, rhs: Dog) -> Bool {
        lhs.weight == rhs.weight && lhs.age == rhs.age
    }
    
    static func < (lhs: Dog, rhs: Dog) -> Bool {
        lhs.weight < rhs.weight || (lhs.weight == rhs.weight && lhs.age > rhs.age)
    }
    
    static func > (lhs: Dog, rhs: Dog) -> Bool {
        lhs.weight > rhs.weight || (lhs.weight == rhs.weight && lhs.age < rhs.age)
    }

    static func <= (lhs: Dog, rhs: Dog) -> Bool {
        !(lhs > rhs)
    }

    static func >= (lhs: Dog, rhs: Dog) -> Bool {
        !(lhs < rhs)
    }
}


/// 自定义运算符
/*
 
 prefix operator +++ // 前缀运算符
 postfix operator +++ // 后缀运算符
 infix operator +- : PlusMinusPrecedence// 中缀运算符: 优先级组

 precedencegroup PlusMinusPrecedence // 优先级组
 {
     associativity: none // 结合性 (left,right,none)
     higherThan: AdditionPrecedence // 比谁的优先级高
     lowerThan: MultiplicationPrecedence // 比谁的优先级低
     assignment: true // 代表可以在可选链操作中拥有跟赋值运算符一样的优先级
 }
 
 https://developer.apple.com/documentation/swift/swift_standard_library/operator_declarations
 https://docs.swift.org/swift-book/ReferenceManual/Declarations.html#ID380
 
 */
prefix operator +++ // 前缀运算符
postfix operator +++ // 后缀运算符
infix operator +- : PlusMinusPrecedence// 中缀运算符: 优先级组

precedencegroup PlusMinusPrecedence // 优先级组
{
    associativity: none // 结合性 (left,right,none)
    higherThan: AdditionPrecedence // 比谁的优先级高
    lowerThan: MultiplicationPrecedence // 比谁的优先级低
    assignment: true // 代表可以在可选链操作中拥有跟赋值运算符一样的优先级
}

prefix func +++ (_ i: inout Int) {
    i += 2
}

var weight = 2
+++weight

struct Size {
    var width = 0
    var height = 0
    
    static func +- (s1: Size, s2: Size) -> Size {
        Size(width: s1.width + s2.width, height: s1.height - s2.height)
    }
}

var size1 = Size(width: 10, height: 5)
var size2 = Size(width: 10, height: 5)
var size3 = size1 +- size2
print("自定义运算符 +-", size3)


class Cat {
    var weight = 0
    var size: Size = Size()
}

func getWeight() -> Int {
    20
}
var cat: Cat? = nil
/// 如果左边cat是nil，那么 = 好右边的方法不会调用
cat?.weight = getWeight()

/// 如果左边cat是nil，那么 +- 右边的 Size 是不会初始化的，所以 assignment 代表的是，是否与 = 号有相同的作用
cat?.size +- Size(width: 10, height: 2)


