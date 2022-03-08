//
//  main.swift
//  SwiftTest
//
//  Created by karos li on 2021/7/23.
//

import Foundation

let aa: Int? = 1
print(aa)


//var pType = Person.self

typealias Fun = (Int) -> Int

func getFun() -> Fun {
    var num = 1
    func plus(_ i: Int) -> Int {
        num += i
        return num
    }
    
    /**
     这里的立即数 0x18，转成十进制是 24，表示这个闭包需要申请 24 个字节的内存空间，而由于 swift_allocObject 底层调用的是 malloc，而iOS/MacOS系统，的内存对齐是16个字节，所以实际分配给这个闭包的是 32 个字节
     0x100003cec <+28>:  mov    w9, #0x18
     0x100003cf0 <+32>:  mov    x1, x9
     0x100003cf4 <+36>:  mov    w9, #0x7
     0x100003cf8 <+40>:  mov    x2, x9
     0x100003cfc <+44>:  bl     0x100003e88               ; symbol stub for: swift_allocObject
     
     
     x0：用于存放返回值得寄存器
     (lldb) register read x0
           x0 = 0x00000001007c3170
     (lldb) x/5xg 0x00000001007c3170
     0x1007c3170: 0x0000000100004030 0x0000000000000003
     0x1007c3180: 0x0000000000000001 0xed000021646c726f
     0x1007c3190: 0x0000000000000000
     
     在这里 x0 存的就是闭包的地址，从这个地址（0x00000001007c3170）可以看出（不是以 0x00000001000 开头，也不是 0x0007 开头 ）闭包是存放在堆空间里，所以捕获的变量也会在堆空间
     
     闭包的本质就是一个类的实例，swift 的一个实例，前面16个字节是类型信息和引用计数，所以
     类型信息：0x0000000100004030
     引用计数：0x0000000000000003
    
     成员变量：0x1007c3180，由于初始 num = 1，他的值是 0x0000000000000001
     */
    return plus
}

/**
 局部变量，把 7 存放到 x13，然后 x13 存放到 x14，最后把 x14 存放到内存数据段里，因为这里是字面量，所以放到数据段里
 0x100003998 <+52>:  mov    w13, #0x7
 0x10000399c <+56>:  mov    x14, x13
 0x1000039a0 <+60>:  str    x14, [x12, #0x60]
 
 (lldb) register read x12
      x12 = 0x0000000100008000  (void *)0x0000000100003e00
 
 [x12, #0x60] = 0x0000000100003e60
 */
var a = 7

print("局部变量的地址：", Mems.ptr(ofVal: &a))

class Person {
    
}
var b = Person()
print("局部变量的地址：", Mems.ptr(ofVal: &b))

func testLocalVar() {
    var a = 8

    print("局部变量的地址：", Mems.ptr(ofVal: &a))

}

testLocalVar()

let fun = getFun()
print(fun(1))
print(fun(2))
print(fun(3))
