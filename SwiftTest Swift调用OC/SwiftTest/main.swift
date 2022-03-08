//
//  main.swift
//  SwiftTest
//
//  Created by karos li on 2021/7/23.
//

import Foundation

/// Swift 调用 OC
func sum(_ a: Int32, _ b: Int32) -> Int32 {
    a - b
}

/// 重命名 c 函数的名字，把 sum 重命名到 swift_sum。用于防止自己写的函数覆盖了 c 的函数
@_silgen_name("sum")
func swift_sum(_ a: Int32, _ b: Int32) -> Int32

var p = MyPerson(age: 10, name: "Jack")
p.age = 15
p.name = "Rose"
p.run()
p.eat("fish", other: "water")

MyPerson.run()
MyPerson.eat("pizza", other: "milk")

print(swift_sum(3, 4))
print(sum(3, 4))

/// OC 调用 Swift
@objc(MyCar)
@objcMembers class Car: NSObject {
    var price: Double
    @objc(name)
    var band: String
    init(price: Double, band: String) {
        self.price = price
        self.band = band
    }
    
    /// dynamic 会走runtime流程，msg_send。OC 里调用 Swift 文件里定义的方法时，本身是走runtime流程的，这里加上 dynamic 主要是为了让 swift 文件里调用继承OC类的方法才有用，不然默认是走虚表的方案
    @objc(drive)
    dynamic func run() {
        print(price, band, "run")
    }
    
    @objc(drive)
    static func run() {
        print("Car run")
    }
}
extension Car {
    func test() {
        print(price, band, "test")
    }
}

testOCInvokeSwift()


/// String, SubString
var str = "1_2_3_4_5"
let range = str.startIndex..<str.index(str.startIndex, offsetBy: 3)

/// SubString 类型，实际上字符串还是存在 str 里， str1 只是保存了开始和结束指针
var str1 = str[range]
/// 一旦修改了 str1，就会进行深度拷贝，遵循了 copy on write 原则
str1.append("6")
print("str1", str1)// str1 1_26
print("str", str)// str 1_2_3_4_5
