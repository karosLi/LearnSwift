//
//  main.swift
//  SwiftTest
//
//  Created by karos li on 2021/7/23.
//

import Foundation

/*
 内存分布（地址从低往高）：
 Mach-O
    - 代码段（只读）
    - 数据段（可读可写）
 堆空间
 栈空间
 动态库
 
 dyld_stub_binder：用于符号绑定，并且是 lazy 符号绑定，在运行时第一次使用时才会进行符号绑定
 符号绑定：查找符号在动态库真实的函数地址，并把函数地址修改到 Mach-O 中的数据段里
 
 第一次创建字符串
 SwiftTest`Swift.String.init(_builtinStringLiteral: Builtin.RawPointer, utf8CodeUnitCount: Builtin.Word, isASCII: Builtin.Int1) -> Swift.String:
 ->  0x10000756e <+0>: jmpq   *0x4a9c(%rip)             ; (void *)0x00000001000076d0(数据段地址)
    jmpq = 取出 0x4a9c(%rip) 里存放的8个字节，并根据这8个字节进行跳转
     libdyld.dylib`dyld_stub_binder:(符号绑定)
     ->  0x7fff20488b0c <+0>:   pushq  %rbp
         0x7fff20488b0d <+1>:   testq  $0xf, %rsp
         0x7fff20488b14 <+8>:   jne    0x7fff20488c9e            ; stack_not_16_byte_aligned_error
         0x7fff20488b1a <+14>:  movq   %rsp, %rbp
 */
var str01 = "0123456789"
/**
 第二次创建字符串，可以直接使用符号绑定过的实际函数地址去进行调用
 
 SwiftTest`Swift.String.init(_builtinStringLiteral: Builtin.RawPointer, utf8CodeUnitCount: Builtin.Word, isASCII: Builtin.Int1) -> Swift.String:
 ->  0x10000756e <+0>: jmpq   *0x4a9c(%rip)             ; (void *)0x00007fff2caffcf0(实际函数的地址): Swift.String.init(_builtinStringLiteral: Builtin.RawPointer, utf8CodeUnitCount: Builtin.Word, isASCII: Builtin.Int1) -> Swift.String

 
 */
var str02 = "0123456789"




/**
 代码段（只读）-常量区 与 数据段（可读可写）-全局变量
 
 0x100002f50 <+0>:   pushq  %rbp
 0x100002f51 <+1>:   movq   %rsp, %rbp
 0x100002f54 <+4>:   subq   $0x100, %rsp              ; imm = 0x100
 获取代码段-常量区里的字面量字符串地址，并给到 rax
 
 常量字符串的地址
 (lldb) x 0x1000078A0
 0x1000078a0: 30 31 32 33 34 35 36 37 38 39 00 0a 00 00 00 00  0123456789......
 0x1000078b0: 43 61 6e 27 74 20 75 6e 73 61 66 65 42 69 74 43  Can't unsafeBitC
 
 0x100002f5b <+11>:  leaq   0x493e(%rip), %rax        ; "0123456789"
 0x100002f62 <+18>:  movl   %edi, -0x34(%rbp)
 rdi = 常量字符串地址
 0x100002f65 <+21>:  movq   %rax, %rdi
 0x100002f68 <+24>:  movl   $0xa, %eax
 0x100002f6d <+29>:  movq   %rsi, -0x40(%rbp)
 rsi = 字符串长度
 0x100002f71 <+33>:  movq   %rax, %rsi
 0x100002f74 <+36>:  movl   $0x1, %edx
 0x100002f79 <+41>:  callq  0x10000758e               ; symbol stub for: Swift.String.init(_builtinStringLiteral: Builtin.RawPointer, utf8CodeUnitCount: Builtin.Word, isASCII: Builtin.Int1) -> Swift.String
 0x100002f7e <+46>:  movq   0x5193(%rip), %rcx        ; (void *)0x00007fff81655f88: type metadata for Any
 0x100002f85 <+53>:  addq   $0x8, %rcx
 call 完字符串初始化后，rax 会被填充成常量字符串
 0x100002f8c <+60>:  movq   %rax, 0x925d(%rip)        ; SwiftTest.str : Swift.String
 0x100002f93 <+67>:  movq   %rdx, 0x925e(%rip)        ; SwiftTest.str : Swift.String + 8
 
 全局变量的地址
 (lldb) x 0x10000C1F0
 0x10000c1f0: 30 31 32 33 34 35 36 37 38 39 00 00 00 00 00 ea  0123456789......
 0x10000c200: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
 
->  0x100002f9a <+74>:  movl   $0x1, %edi
 0x100002f9f <+79>:  movq   %rcx, %rsi
 
 所以 var str = "0123456789"，是把 常量区字符串（0x1000078A0）拷贝了一份给到了全局变量（0x10000C1F0）
 */



/*
 0x1000031a9 <+57>:  movq   %rax, 0x9040(%rip)        ; SwiftTest.str : Swift.String
 0x1000031b0 <+64>:  movq   %rdx, 0x9041(%rip)        ; SwiftTest.str : Swift.String + 8
 
 0x9040(%rip)：全局变量的地址
 0x9040(%rip) = 0x1000031b0 + 0x9040 = 0x10000C1F0
 
 (lldb) x/2xg 0x10000C1F0
 0x10000c1f0: 0x3736353433323130 0xea00000000003938
 
 (lldb) x 0x10000C1F0
 0x10000c1f0: 30 31 32 33 34 35 36 37 38 39 00 00 00 00 00 ea  0123456789......
 0x10000c200: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
 
 第二个 8 字节的首字节前四位 e 表示数据类型，后四位 a 表示数据长度

 e 表示的是类似 OC 里的 tagger pointer 字符串，tagpointer 的最大字符串长度是 15 字节，因为会有一个字节来表示数据类型和长度
 a 表示字符串长度为 10
 
 ASCII 里，'0' 用 30 表示
 */
//var str = "0123456789"
//// 0x3736353433323130 0xea00000000003938
//print(Mems.ptr(ofVal: &str))
//print(Mems.memStr(ofVal: &str))
//print("")


//
//
//var str1 = "0123456789ABCDE"
//// 0x3736353433323130 0xef45444342413938
//print(Mems.memStr(ofVal: &str1))

/// 超过 15 个字符时，tagger pointer 放不下了
//var str2 = "0123456789ABCDEF"
// 0xd000000000000010 0x8000000100007870
//print(Mems.memStr(ofVal: &str2))


/*
 0x8 是标志位，一旦发现是 0x8，表明是一个字符串指针
 0xd 也是标志位，后面 10 表示的是字符串的总长度
 
 字符串真实地址 + 0x7FFFFFFFFFFFFFE0 = 0x8000000100007870
 字符串真实地址 = 0x100007890
 
 (lldb) x 0x100007890
 0x100007890: 30 31 32 33 34 35 36 37 38 39 41 42 43 44 45 46  0123456789ABCDEF
 0x1000078a0: 00 0a 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
 
 把字符串真实地址给到 rax
 0x100003168 <+8>:   leaq   0x4721(%rip), %rax        ; "0123456789ABCDEF"
 0x10000316f <+15>:  movl   %edi, -0x1c(%rbp)
 0x100003172 <+18>:  movq   %rax, %rdi
 0x100003175 <+21>:  movl   $0x10, %eax
 0x10000317a <+26>:  movq   %rsi, -0x28(%rbp)
 把字符串长度给到 rsi
 0x10000317e <+30>:  movq   %rax, %rsi
 0x100003181 <+33>:  movl   $0x1, %edx
 
 rax，rsi 作为参数
 0x100003186 <+38>:  callq  0x10000757e               ; symbol stub for: Swift.String.init(_builtinStringLiteral: Builtin.RawPointer, utf8CodeUnitCount: Builtin.Word, isASCII: Builtin.Int1) -> Swift.String
 0x10000318b <+43>:  movq   0x4f86(%rip), %rcx        ; (void *)0x00007fff81655f88: type metadata for Any
 0x100003192 <+50>:  addq   $0x8, %rcx
 0x100003199 <+57>:  movq   %rax, 0x9050(%rip)        ; SwiftTest.str2 : Swift.String
 0x1000031a0 <+64>:  movq   %rdx, 0x9051(%rip)        ; SwiftTest.str2 : Swift.String + 8
 
 libswiftCore.dylib`Swift.String.init(_builtinStringLiteral: Builtin.RawPointer, utf8CodeUnitCount: Builtin.Word, isASCII: Builtin.Int1) -> Swift.String:
 ->  0x7fff2caffcf0 <+0>:    pushq  %rbp
     0x7fff2caffcf1 <+1>:    movq   %rsp, %rbp
     0x7fff2caffcf4 <+4>:    testq  %rsi, %rsi
     0x7fff2caffcf7 <+7>:    js     0x7fff2cb0009e            ; <+942>
     0x7fff2caffcfd <+13>:   movl   %edx, %eax
     0x7fff2caffcff <+15>:   movabsq $-0x2000000000000000, %rdx ; imm = 0xE000000000000000
     0x7fff2caffd09 <+25>:   testq  %rsi, %rsi
     0x7fff2caffd0c <+28>:   je     0x7fff2caffd4a            ; <+90>
 
     rsi = 字符串长度
     比较字符串长度，小于等于 15 就跳转 0x7fff2caffd4e，否则继续往下执行
     0x7fff2caffd0e <+30>:   cmpq   $0xf, %rsi
     0x7fff2caffd12 <+34>:   jle    0x7fff2caffd4e            ; <+94>
     0x7fff2caffd14 <+36>:   movabsq $-0x4000000000000000, %rcx ; imm = 0xC000000000000000
     0x7fff2caffd1e <+46>:   orq    %rsi, %rcx
     0x7fff2caffd21 <+49>:   testb  $0x1, %al
     0x7fff2caffd23 <+51>:   cmoveq %rsi, %rcx
     0x7fff2caffd27 <+55>:   movabsq $0x1000000000000000, %rax ; imm = 0x1000000000000000
     0x7fff2caffd31 <+65>:   orq    %rcx, %rax
 
     rdi = 字符串真实地址
     rdx = 字符串真实地址 + 0x7fffffffffffffe0
     0x7fff2caffd34 <+68>:   movabsq $0x7fffffffffffffe0, %rdx ; imm = 0x7FFFFFFFFFFFFFE0
     0x7fff2caffd3e <+78>:   addq   %rdx, %rdi
 */

/// 超过 15 个字符时，然后动态追加字符串
var str3 = "0123456789ABCDEF"
// 0xd000000000000010 0x8000000100007870
print(Mems.memStr(ofVal: &str3))
str3.append("G")
// 0xf000000000000011 0x0000000108bcaae0
print(Mems.memStr(ofVal: &str3))
print("")

/*
 字符串真实地址(指向堆空间) = 0x0000000108bcaae0 + 0x20 = 0x108BCAB00
 
 (lldb) x 0x108BCAB00
 0x108bcab00: 30 31 32 33 34 35 36 37 38 39 41 42 43 44 45 46  0123456789ABCDEF
 0x108bcab10: 47 00 00 00 00 00 00 00 60 c3 64 81 ff 7f 00 00  G.......`.d.....
 */

/*
 所以，不管是类 OC 的 tagger pointer，还是字符串指针，都是占用 16 个字节。
 1、tagger pointer(字符串长度不超过15): 数据段里内存 0x3736353433323130 0xea00000000003938， 0xe = 数据类型，0x0a = 数据长度，字符串数据是从常量区拷贝到数据段里内存里
    - 在不动态修改字符串时：字符串数据都是存放到变量所在的数据段内存
    - 在动态修改字符串时：字符串数据都是存放到变量所在的数据段内存
    
 2、字符串指针(字符串长度超过15):
     - 在不动态修改字符串时：数据段里内存 0xd000000000000010 0x8000000100007870(虚拟地址)， 字符串真实地址（指向代码段-常量区） = 0x8000000100007870 - 0x7FFFFFFFFFFFFFE0，0x8 = 标志位，0xd = 标志位，0x0000000000000010 = 数据长度
     - 在动态修改字符串时：数据段里内存 0xf000000000000011 0x0000000108bcaae0(堆空间地址)，字符串真实地址(指向堆空间) = 0x0000000108bcaae0 + 0x20(32个字节存放的是类型信息，引用计数等)，0xf = 标志位，0x0000000000000011 = 数据长度
 */


/*
 证明地址是堆空间的方法：
 1、汇编看看有没有调用 swift_alloc -> swift_slowAlloc -> malloc
 2、使用符号断点 malloc
    - lldb下打印 bt，确定堆栈
    - 断点 到 malloc 最后一条汇编指令，register read rax，得到就是堆空间地址值
 */

