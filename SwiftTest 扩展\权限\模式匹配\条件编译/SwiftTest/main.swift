//
//  main.swift
//  SwiftTest
//
//  Created by karos li on 2021/7/23.
//

import Foundation

var i: Int = 0

extension BinaryInteger {
    /// 是否是奇数
    func isOdd() -> Bool {
        self % 2 != 0
    }
}

/// 方法变量
struct Person {
    var age: Int
    func run(_ v: Int) {
        print("func run", age, v)
    }
}

// fn: (Person) -> ((Int) -> ())
var fn = Person.run
// fn1: (Int) -> ()
var fn1 = fn(Person(age: 10))
fn1(20)

/// 访问控制

/**
 open: 允许在定义实体的模块和其他模块中访问，允许其他模块进行继承，重写（open只作用于类和类成员上）
 public: 允许在定义实体的模块和其他模块中访问，不允许其他模块进行继承，重写
 internal: 只允许在定义实体的模块中访问，不允许其他模块访问
 fileprivate: 只允许在定义实体的源文件中访问
 private: 只允许在定义实体的封闭声明中访问
 */


// 默认不声明都是 internal
protocol Runable {
    func run()
}

class Dog: Runable {
    func run() {
         
    }
}

// 也可以显示声明 internal
internal protocol Runable1 {
    func run()
}

internal class Dog1: Runable1 {
    func run() {
         
    }
}

// 声明成 public
public protocol Runable2 {
    // 协议方法的访问权限来自于协议声明，所以这里也是 public
    func run()
}

public class Dog2: Runable2 {
    // 当类被声明成 public 时，类里的方法默认访问权限是 internal，但是实现类的方法的访问权限必须要 大于等于协议方法的访问权限 或者 大于等于自己类声明的访问权限，所以之类必须声明成 public 或者 open
    public func run() {
         
    }
}


/// 字面量协议
extension Int : ExpressibleByBooleanLiteral {
    public init(booleanLiteral value: BooleanLiteralType) {
        self = value ? 1 : 0
    }
}

var num: Int = true
print("num ExpressibleByBooleanLiteral", num)


/// 模式匹配
/// 枚举case模式
let age = 2
// 原来写法
if age >= 0 && age <= 9 {
    print("[0, 9]")
}

if case 0...9 = age {
    print("枚举case模式", "[0, 9]")
}

var intarray: [Int?] = [2, 3, nil, 5]
for case nil in intarray {
    print("枚举case模式", "含有nil值")
}
for case let x? in intarray {// x 非空，才能匹配上
    print("枚举case模式", x)
}

var points: [(Int, Int)] = [(1, 0), (3, 0), (4, 6)]
for case let (x, 0) in points {
    print("枚举case模式", "x为\(x), y为0的点")
}

/// 可选模式
let age1: Int? = 1
if case .some(let x) = age1 {
    print("可选模式", "x", x)
}
if case let x? = age1 {// age1 为非空，就匹配成功
    print("可选模式", "x", x)
}

/// 类型转换模式
var age2: Any = 6
switch age2 {
case let x as Int:// 强转成功才会给 x 赋值
    print(x + 1)
default:
    break
}


/// 自定义表达式模式
struct Student {
    var score = 0, name = ""
    static func ~=(pattern: Int, value: Student) -> Bool {
        value.score >= pattern
    }
    
    static func ~=(pattern: ClosedRange<Int>, value: Student) -> Bool {
        pattern.contains(value.score)
    }
    
    static func ~=(pattern: Range<Int>, value: Student) -> Bool {
        pattern.contains(value.score)
    }
}

var stu = Student(score: 75, name: "Jack")
switch stu {
case 100: print("Student >=100")
case 90: print("Student >=90")
case 80..<90: print("Student [80, 90)")
case 60...79: print("Student [60, 79]")
case 0: print("Student >=0")
default: break
}


extension String {
    // pattern 对应 case 后面的值，value 对应 switch 的变量，返回值表示是否匹配
    static func ~=(pattern: (String) -> Bool, value: String) -> Bool {
        pattern(value)
    }
}
func hasPrefix(_ prefix: String) -> ((String) -> Bool) {
    { $0.hasPrefix(prefix) }
}
func hasSuffix(_ suffix: String) -> ((String) -> Bool) {
    { $0.hasSuffix(suffix) }
}

var str = "12345678"
switch str {
case hasPrefix("123"):
    print("hasPrefix 123")
case hasSuffix("678"):
    print("hasSuffix 678")
default:
    break
}


extension Int {
    static func ~=(pattern: (Int) -> Bool, value: Int) -> Bool {
        pattern(value)
    }
}
func isEven(_ i: Int) -> Bool {
    i % 2 == 0
}
func isOdd(_ i: Int) -> Bool {
    i % 2 != 0
}
var age3 = 10
switch age3 {
case isEven:
    print("偶数")
case isOdd:
    print("奇数")
default:
    break
}


/// where: 为模式匹配增加匹配条件
var data = (10, "KK")
switch data {
case let (age, _) where age > 10:
    print(data.1, "age>10")
case let (age, _) where age > 0:
    print(data.1, "age>0")
default:
    break
}

var ages = [10, 20, 30, 40]
for age in ages where age > 30 {
    print(age)
}

var ages1: [Int?] = [nil, nil, nil, 30, nil]
for age in ages1 where age != nil {
    print("不为空", age!)
}

protocol Stackable {
    associatedtype Element
}
protocol Container {
    associatedtype Stack: Stackable where Stack.Element: Equatable
}

extension Container where Self.Stack.Element: Hashable {
    
}

func equal<S1: Stackable, S2: Stackable>(_ s1: S1, _ s2: S2) -> Bool where S1.Element == S2.Element, S1.Element: Hashable {
    return false
}


// MARK: 类似OC的 #pragma mark
// MARK: - 类似OC的 #pragma mark -
// TODO: 用于标记未完成的任务
// FIXME: 用于标记待修复的问题
#warning("TODO")

/// 条件编译
// 操作系统: macOS\iOS\tvOS\watchOS\Linux\Android\Windows\FreeBSD
#if os(macOS) || os(iOS)
// CPU架构: i386\x86_64\arm\arm64
#elseif arch(x86_64) || arch(arm64)
// swift版本
#elseif swift(<5) && swift(>=3)
// 模拟器
#elseif targetEnvironment(simulator)
// 可导入某模块
#elseif canImport(Foundation)
#else
#endif

func mylog<T>(_ message: T,
              file: NSString = #file,
              line: Int = #line,
              fn: String = #function) {
    #if DEBUG
    // /Users/../SwiftTest/main.swift 265 mylog(_:)
    let prefix = "\(file.lastPathComponent)_\(line)_\(fn)"
    print(prefix, message)
    #endif
}
mylog("我的日志")


/// API可用性

@available(iOS 10, macOS 10.14, *)
class Robot {
}

struct Component {
    @available(*, unavailable, renamed: "study")
    func study_() {}
    func study() {}
    
    @available(iOS, deprecated: 11)
    @available(macOS, deprecated: 10.2)
    func run() {}
}
