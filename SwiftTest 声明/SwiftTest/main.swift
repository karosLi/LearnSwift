//
//  main.swift
//  SwiftTest
//
//  Created by karos li on 2021/7/23.
//

import Foundation

struct CallableStruct {
    var value: Int
    // 等价于 在类型上声明 @dynamicCallable
    func callAsFunction(_ number: Int, scale: Int) -> Int {
        return scale * (number + value)
    }
}
let callable = CallableStruct(value: 100)
print("CallableStruct", callable(4, scale: 2))
print("CallableStruct", callable.callAsFunction(4, scale: 2))
// Both function calls print 208.


/// @dynamicCallable 动态调用-标签参数化
@dynamicCallable
struct CallableStruct1 {
    var value: Int
    func dynamicallyCall(withArguments args: [Int]) -> Int {
        return args[1] * (args[0] + value)
    }

    func dynamicallyCall(withKeywordArguments args: KeyValuePairs<String, Int>) -> Int {
        return args[1].value * (args[0].value + value)
    }
}
let callable1 = CallableStruct1(value: 100)
print("CallableStruct1", callable1(4, 2))
print("CallableStruct1", callable1(number: 4, scale: 2))


/// @dynamicMemberLookup 动态查找成员
@dynamicMemberLookup
public struct Reactive<Base> {
    /// Base object to extend.
    public let base: Base

    /// Creates extensions with base object.
    ///
    /// - parameter base: Base object.
    public init(_ base: Base) {
        self.base = base
    }
    
//    public subscript<Property>(dynamicMember keyPath: ReferenceWritableKeyPath<Base, Property>) -> Binder<Property> where Base: AnyObject {
//        Binder(self.base) { base, value in
//            base[keyPath: keyPath] = value
//        }
//    }

    /// Automatically synthesized binder for a key path between the reactive
    /// base and one of its properties
    public subscript<Property>(dynamicMember keyPath: ReferenceWritableKeyPath<Base, Property>) -> Property where Base: AnyObject {
        base[keyPath: keyPath]
    }
}

class Person {
    var age: Int = 18
    var male: Bool = true
}
let person = Person()
let rx = Reactive(person)
print("person", rx.age)


/// @propertyWrapper 自定义属性包装器
@propertyWrapper
struct SomeWrapper {
    var wrappedValue: Int
    var someValue: Double
    init() {
        self.wrappedValue = 100
        self.someValue = 12.3
    }
    init(wrappedValue: Int) {
        self.wrappedValue = wrappedValue
        self.someValue = 45.6
    }
    init(wrappedValue value: Int, custom: Double) {
        self.wrappedValue = value
        self.someValue = custom
    }
}

struct SomeStruct {
    // Uses init()
    @SomeWrapper var a: Int

    // Uses init(wrappedValue:)
    @SomeWrapper var b = 10

    // Both use init(wrappedValue:custom:)
    @SomeWrapper(custom: 98.7) var c = 30
    @SomeWrapper(wrappedValue: 30, custom: 98.7) var d
}

let s = SomeStruct()

@propertyWrapper
struct WrapperWithProjection {
    private var innerValue: Int = 0
    var customValue: Int = 0
    /// 必须要实现，可以是计算属性，也可是存储属性
    var wrappedValue: Int {
        get {
            innerValue
        }
        set {
            innerValue = newValue
        }
    }
    
    init(wrappedValue: Int, customValue: Int = 11) {
        self.wrappedValue = wrappedValue
        self.customValue = customValue
    }
    /// 投影值，引用传递，用于暴露属性包装的其他属性，比如这里的 customValue
    var projectedValue: WrapperWithProjection {
        return self
    }
}

struct SomeStruct1 {
    @WrapperWithProjection(customValue: 20) var x = 123
}
var s1 = SomeStruct1()
print("@propertyWrapper", s1.x)// 123
print("@propertyWrapper", s1.$x.customValue)// 20

@propertyWrapper /// 先告诉编译器 下面这个UserDefault是一个属性包裹器
struct UserDefault<T> {
    ///这里的属性key 和 defaultValue 还有init方法都是实际业务中的业务代码
    ///我们不需要过多关注
    let key: String
    let defaultValue: T

    init(_ key: String, defaultValue: T) {
        self.key = key
        self.defaultValue = defaultValue
    }
///  wrappedValue是@propertyWrapper必须要实现的属性
/// 当操作我们要包裹的属性时  其具体set get方法实际上走的都是wrappedValue 的set get 方法。
    var wrappedValue: T {
        get {
            return UserDefaults.standard.object(forKey: key) as? T ?? defaultValue
        }
        set {
            UserDefaults.standard.set(newValue, forKey: key)
        }
    }
}
///封装一个UserDefault配置文件
struct UserDefaultsConfig {
    @UserDefault("had_shown_guide_view", defaultValue: false)
    static var hadShownGuideView: Bool
}

UserDefaultsConfig.hadShownGuideView = false
print("UserDefaultsConfig", UserDefaultsConfig.hadShownGuideView) // false
UserDefaultsConfig.hadShownGuideView = true
print("UserDefaultsConfig", UserDefaultsConfig.hadShownGuideView) // true



/// @resultBuilder 结果构建，以自然地、声明的方式来创建嵌套的数据，比如链表和树。类似声明式DSL构建UI的方式
/// https://docs.swift.org/swift-book/ReferenceManual/Attributes.html#ID633
/// https://docs.swift.org/swift-book/ReferenceManual/Attributes.html#ID585
protocol Drawable {
    func draw() -> String
}
struct Line: Drawable {
    var elements: [Drawable]
    func draw() -> String {
        return elements.map { $0.draw() }.joined(separator: "")
    }
}
struct Text: Drawable {
    var content: String
    init(_ content: String) { self.content = content }
    func draw() -> String { return content }
}
struct Space: Drawable {
    func draw() -> String { return " " }
}
struct Stars: Drawable {
    var length: Int
    func draw() -> String { return String(repeating: "*", count: length) }
}
struct AllCaps: Drawable {
    var content: Drawable
    func draw() -> String { return content.draw().uppercased() }
}
@resultBuilder
struct DrawingBuilder {
    /// The buildBlock(_:) method adds support for writing a series of lines in a block of code. It combines the components in that block into a Line.
    static func buildBlock(_ components: Drawable...) -> Drawable {
        return Line(elements: components)
    }
    /// The buildEither(first:) and buildEither(second:) 用于支持 if-else
    static func buildEither(first: Drawable) -> Drawable {
        return first
    }
    static func buildEither(second: Drawable) -> Drawable {
        return second
    }
    /// 用于支持 for 循环
    static func buildArray(_ components: [Drawable]) -> Drawable {
        return Line(elements: components)
    }

}
/// @DrawingBuilder 可以用作参数，它会自动把闭包代码转换成数组，并传入 buildBlock 里
func draw(@DrawingBuilder content: () -> Drawable) -> Drawable {
    return content()
}
func caps(@DrawingBuilder content: () -> Drawable) -> Drawable {
    return AllCaps(content: content())
}

func makeGreeting(for name: String? = nil) -> Drawable {
    let greeting = draw {
        Stars(length: 3)
        Text("Hello")
        Space()
        caps {
            if let name = name {
                Text(name + "!")
            } else {
                Text("World!")
            }
        }
        Stars(length: 2)
    }
    return greeting
}
let genericGreeting = makeGreeting()
print("@resultBuilder", genericGreeting.draw())


/// Result Transformations 结果转换
@resultBuilder
struct ArrayBuilder {
    typealias Component = [Int]
    typealias Expression = Int
    static func buildExpression(_ element: Expression) -> Component {
        return [element]
    }
    static func buildOptional(_ component: Component?) -> Component {
        guard let component = component else { return [] }
        return component
    }
    static func buildEither(first component: Component) -> Component {
        return component
    }
    static func buildEither(second component: Component) -> Component {
        return component
    }
    static func buildArray(_ components: [Component]) -> Component {
        return Array(components.joined())
    }
    static func buildBlock(_ components: Component...) -> Component {
        return Array(components.joined())
    }
}

// 把计算属性的单个返回值得表达式转成数组，等价于 ArrayBuilder.buildExpression(10)
@ArrayBuilder var builderNumber: [Int] { 10 }
print("@ArrayBuilder", builderNumber)// @ArrayBuilder [10]



/// 解决冗余扩展
protocol Serializable {
    func serialize() -> Any
}
protocol SerializableInArray { }
extension Int: SerializableInArray { }
extension String: SerializableInArray { }
extension Array: Serializable where Element: SerializableInArray {
    func serialize() -> Any {
        return 0
    }
}

