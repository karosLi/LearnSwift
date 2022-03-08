//
//  main.swift
//  SwiftTest
//
//  Created by karos li on 2021/7/23.
//

import Foundation

/// 面向协议编程的原则
/*
 1、优先使用协议去扩展功能，而非基类
 2、优先使用 struct 而非 class
 */

/// 基于前缀扩展功能
/// 添加前缀类型
struct KK<Base> {
    var base: Base
    init(_ base: Base) {
        self.base = base
    }
}

/// 利用协议扩展前缀属性
protocol KKCompatible {}
extension KKCompatible {
    /// 计算属性
    var kk: KK<Self> {
        set {}
        get {
            return KK(self)
        }
    }
    
    static var kk: KK<Self>.Type {
        set {}
        get {
            return KK.self
        }
    }
}

/// 给字符串扩展功能
// 添加 kk 属性
extension String: KKCompatible {}
extension NSString: KKCompatible {}
// 扩展方法
extension KK where Base: ExpressibleByStringLiteral {
    var numberCount: Int {
        var count = 0
        for c in base as! String where ("0"..."9").contains(c) {
            count += 1
        }
        
        return count
    }
    
    mutating func run() {
        
    }
    
    static func outputString() {
        print("outputString")
    }
}

class Person {
    var age = 0
}
/// 给Person扩展功能
extension Person: KKCompatible {}
extension KK where Base: Person {
    var tag: String {
        if base.age >= 16 {
            return "青少年"
        }
        
        return "儿童"
    }
    
    static func outputPerson() {
        print("outputPerson")
    }
}

var str = "123dddd456"
print(str.kk.numberCount)
String.kk.outputString()
str.kk.run()

var person = Person()
person.age = 17
print(person.kk.tag)
Person.kk.outputPerson()


/// 利用协议判断类型
protocol ArrayType {}
extension Array: ArrayType {}
extension NSArray: ArrayType {}
func isArrayType(_ value: Any.Type) -> Bool {
    value is ArrayType.Type
}
func isArray(_ value: Any) -> Bool {
    value is [Any]
}

public protocol KKBifrostServiceProtocol {}
public protocol AModuleProtocol: KKBifrostServiceProtocol {
    func print()
}
func registerService(_ serviceProtocol: Any.Type) {
    print(String(describing: serviceProtocol))
}
registerService(AModuleProtocol.self)

