//
//  main.swift
//  SwiftTest
//
//  Created by karos li on 2021/7/23.
//

import Foundation
import Dispatch

class Dog {
    
}

class Person {
    weak var dog: Dog? {
        // arc 自动给弱引用设置 nil，不会触发属性观察器
        willSet {
            
        }
        didSet {
            
        }
    }
    deinit {
        print("Person deinit")
    }
}

/// 强引用
print(1)
// 默认是强引用
var p: Person? = Person()
print(2)
p = nil
print(3)


/// 弱引用
print(4)
// 弱引用必须是可选类型，并且是 var 修饰
weak var p1: Person? = Person()
print(5)

var p0 = Person()
// arc 自动给弱引用设置 nil，不会触发属性观察器
p0.dog = Dog()


/// 无主引用 unowned，不会强引用，实例销毁后，任然存储实例的内存地址，类似 OC 的 unsafe_unretained


class TT {
    var age: Int = 0
    
    /// 一旦调用，就会造成循环引用
    lazy var strongfn: ()->() = {
        self.run()
    }
    
    /// 由于使用了 weak，就避免了循环引用
    lazy var weakfn: ()->() = { [weak self] in
        self?.run()
    }
    
    /// 由于使用了 unowned，就避免了循环引用
    lazy var unownedfn: ()->() = { [unowned self] in
        self.run()
    }
    
    /// 由于第一次初始化的时候调用闭包表达式，这里相当于 lazy var getAge: Int = self.age，所以不会产生循环引用，因为闭包调用后，生命周期结束了
    lazy var getAge: Int = {
        self.age
    }()
    
    func run() {
        print("TT run")
    }
    
    deinit {
        print("TT deinit")
    }
}

func testTT() {
    let t = TT()
    t.weakfn()
}

testTT()


/// 非逃逸闭包：在函数作用域内调用
func testNonEscape(fn: ()->Void) {
    fn()
}
testNonEscape {
    print("testNonEscape")
}

/// 逃逸闭包：可能在函数作用域外调用
var gFn: (()->Void)?
func testEscape(fn: @escaping ()->Void) {
    gFn = fn
}
testEscape {
    print("testEscape")
}
gFn?()

/// 逃逸闭包
func testEscape1(fn: @escaping ()->Void) {
    DispatchQueue.main.async {
        fn()
    }
}
testEscape1 {
    print("testEscape1")
}

/// 逃逸闭包不能捕获 inout 参数，编译器会编译报错
func testInout(_ num: inout Int) {
    testEscape {
        // escaping closure captures 'inout' parameter 'num'
//        num += 1
    }
}

func someFunction(_ a: inout Int) -> () -> Int {
    return { [a] in return a + 1 }
}

func testEscapeInout() {
    var num = 10
    testInout(&num)
    
    var a = 11
    // 12
    print("testEscapeInout", someFunction(&a)())
}

/*
 如果需要捕获和修改inout参数，可以使用一个本地变量
func multithreadedFunction(queue: DispatchQueue, x: inout Int) {
    // Make a local copy and manually copy it back.
    var localX = x
    defer { x = localX }

    // Operate on localX asynchronously, then wait before returning.
    queue.async { someMutatingOperation(&localX) }
    queue.sync {}
}
 */

testEscapeInout()

/// 局部作用域
do {
    let t = TT()
}


/*
 指针
 
 UnsafePointer<Pointee> 类似于 const Pointee *
 UnsafeMutablePointer<Pointee> 类似于 Pointee *
 UnsafeRawPointer 类似于 const void *
 UnsafeMutableRawPointer 类似于 void *
 */

var age = 10
func testPointer1(_ ptr: UnsafeMutablePointer<Int>) {
    ptr.pointee = 30
    print("testPointer1", ptr.pointee)
}

func testPointer2(_ ptr: UnsafePointer<Int>) {
    print("testPointer2", ptr.pointee)
}

func testPointer3(_ ptr: UnsafeMutableRawPointer) {
    ptr.storeBytes(of: 40, as: Int.self)
    print("testPointer3", 40)
}

func testPointer4(_ ptr: UnsafeRawPointer) {
    let a = ptr.load(as: Int.self)
    print("testPointer4", a)
}

testPointer1(&age)
testPointer2(&age)
testPointer3(&age)
testPointer4(&age)


var ocarray = NSArray(objects: 10, 11, 12, 13, 14)

// OC stop: BOOL *
// Swift stop: UnsafeMutablePointer<ObjCBool>
ocarray.enumerateObjects { element, index, stop in
    print(element, index)
    if index == 2 {
        stop.pointee = ObjCBool(true)
    }
}

// 这种遍历可读性更高
for (index, element) in ocarray.enumerated() {
    print(element, index)
    if index == 2 {
        break
    }
}


/// 获取变量的指针（保存的是变量的地址）
var age1 = 25
// @inlinable public func withUnsafeMutablePointer<T, Result>(to value: inout T, _ body: (UnsafeMutablePointer<T>) throws -> Result) rethrows -> Result
var age1Ptr = withUnsafeMutablePointer(to: &age1) {
    $0
}
var age2Ptr = withUnsafeMutablePointer(to: &age1) { (ptr) -> UnsafeMutablePointer<Int> in
    ptr.pointee = 30
    return ptr
}

print("age1Ptr.pointee", age1Ptr.pointee)
print("age2Ptr.pointee", age2Ptr.pointee)
/// 类似于这样写
func myWithUnsafeMutablePointer<T, Result>(to value: UnsafeMutablePointer<T>, _ body: (UnsafeMutablePointer<T>)->Result) -> Result {
    return body(value)
}

/// 获取堆空间地址
class Cat {
    var age = 0
}

var cat = Cat()
// 方法1
var catPtr = withUnsafeMutablePointer(to: &cat) { UnsafeMutableRawPointer($0) }
var mallocAddress = catPtr.load(as: UInt.self)
var mallocPointer = UnsafeMutableRawPointer(bitPattern: mallocAddress)
print("mallocPointer", mallocPointer!)
// 方法2
var mallocPointer1 = unsafeBitCast(cat, to: UnsafeMutableRawPointer.self)
print("mallocPointer1", mallocPointer1)


/// 创建堆空间指针
// UnsafeMutableRawPointer!
// 方法1
var createMallocPtr = malloc(16)
createMallocPtr?.storeBytes(of: 10, as: Int.self)
createMallocPtr?.storeBytes(of: 20, toByteOffset: 8, as: Int.self)
print("createMallocPtr", (createMallocPtr?.load(as: Int.self))!)
print("createMallocPtr", (createMallocPtr?.load(fromByteOffset: 8, as: Int.self))!)
free(createMallocPtr)
// 方法2
var createMallocPtr1 = UnsafeMutableRawPointer.allocate(byteCount: 16, alignment: 1)
createMallocPtr1.storeBytes(of: 40, as: Int.self)
createMallocPtr1.advanced(by: 8).storeBytes(of: 50, as: Int.self)
print("createMallocPtr1", createMallocPtr1.load(as: Int.self))
print("createMallocPtr1", createMallocPtr1.advanced(by: 8).load(as: Int.self))
createMallocPtr1.deallocate()
// 方法3
var createMallocPtr2 = UnsafeMutablePointer<Int>.allocate(capacity: 3)// 3 * 8 = 24
createMallocPtr2.pointee = 60// 初始化
createMallocPtr2.successor().initialize(to: 70) // successor() 表示后继指针，每调用一次 指针偏移 8
createMallocPtr2.successor().successor().pointee = 80

print("createMallocPtr2", createMallocPtr2.pointee)
print("createMallocPtr2", (createMallocPtr2 + 1).pointee)
print("createMallocPtr2", (createMallocPtr2 + 2).pointee)

print("createMallocPtr2", createMallocPtr2[0])
print("createMallocPtr2", createMallocPtr2[1])
print("createMallocPtr2", createMallocPtr2[2])

createMallocPtr2.deinitialize(count: 3)
createMallocPtr2.deallocate()

/// 指针转换 UnsafeMutableRawPointer -> UnsafeMutablePointer
var convertMallocPtr = UnsafeMutableRawPointer.allocate(byteCount: 16, alignment: 1)
var genericConvertMallocPtr =  convertMallocPtr.assumingMemoryBound(to: Int.self)

// unsafeBitCast 是忽略数据类型的强制转换，不会因为数据类型的变化而改变原来的内存数据
//var genericConvertMallocPtr1 = unsafeBitCast(convertMallocPtr, to: UnsafeMutablePointer<Int>.self)

/// 指针转换  UnsafeMutablePointer -> UnsafeMutableRawPointer
var rawConvertMallocPtr = UnsafeMutableRawPointer(genericConvertMallocPtr)
//var rawConvertMallocPtr1 = unsafeBitCast(genericConvertMallocPtr, to: UnsafeMutableRawPointer.self)


