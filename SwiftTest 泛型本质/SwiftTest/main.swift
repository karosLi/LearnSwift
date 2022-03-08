//
//  main.swift
//  SwiftTest
//
//  Created by karos li on 2021/7/23.
//

import Foundation

/// 不像 C++，是在编译期间，检测用到的泛型类型，然后插入类型相关的函数代码，利用重载来实现泛型。swift 的泛型函数，是只有一个函数来实现泛型，在调用的时候，会把泛型的类型的元类型信息传入到函数里，这样函数就可以根据元类型信息来确定内存布局，就可以使用不同的赋值指令来进行负值

func swapValus<T>(_ a: inout T, _ b: inout T) {
    (a, b) = (b, a)
}

var n1 = 10
var n2 = 20
/// 0x100003004 <+156>: bl     0x1000030b8               ; SwiftTest.swapValus<T>(inout T, inout T) -> () at main.swift:12
swapValus(&n1, &n2)

var d1 = 10.0
var d2 = 20.0

/*
 0x100003080 <+280>: ldr    x0, [sp, #0x18]
 0x100003084 <+284>: ldr    x1, [sp, #0x10]
 0x100003088 <+288>: adrp   x2, 5
 0x10000308c <+292>: ldr    x2, [x2, #0x18]
->  0x100003090 <+296>: bl     0x1000030b8               ; SwiftTest.swapValus<T>(inout T, inout T) -> () at main.swift:12
 
 x0: d1 的地址
 x1: d2 的地址
 x2: Double.self 元类型信息
 (lldb) register read x0
       x0 = 0x000000010000c1f0  SwiftTest`SwiftTest.d1 : Swift.Double
 (lldb) register read x1
       x1 = 0x000000010000c1f8  SwiftTest`SwiftTest.d2 : Swift.Double
 (lldb) register read x2
       x2 = 0x00000001ee53eed0  libswiftCore.dylib`type metadata for Swift.Double
 
 
 */
/// 0x100003090 <+296>: bl     0x1000030b8               ; SwiftTest.swapValus<T>(inout T, inout T) -> () at main.swift:12
swapValus(&d1, &d2)


/*
 SwiftTest`swapValus<T>(_:_:):
 ->  0x1000030b8 <+0>:   stp    x29, x30, [sp, #-0x10]!
     0x1000030bc <+4>:   mov    x29, sp
     0x1000030c0 <+8>:   sub    sp, sp, #0x60             ; =0x60
     0x1000030c4 <+12>:  stur   xzr, [x29, #-0x10]
     0x1000030c8 <+16>:  stur   xzr, [x29, #-0x18]
     0x1000030cc <+20>:  stur   x2, [x29, #-0x8]
     0x1000030d0 <+24>:  ldur   x8, [x2, #-0x8]
     0x1000030d4 <+28>:  ldr    x9, [x8, #0x40]
     0x1000030d8 <+32>:  add    x10, x9, #0xf             ; =0xf
     0x1000030dc <+36>:  and    x10, x10, #0xfffffffffffffff0
     0x1000030e0 <+40>:  mov    x11, sp
     0x1000030e4 <+44>:  subs   x10, x11, x10
     0x1000030e8 <+48>:  mov    sp, x10
     0x1000030ec <+52>:  add    x9, x9, #0xf              ; =0xf
     0x1000030f0 <+56>:  and    x9, x9, #0xfffffffffffffff0
     0x1000030f4 <+60>:  mov    x11, sp
     0x1000030f8 <+64>:  subs   x9, x11, x9
     0x1000030fc <+68>:  mov    sp, x9
     0x100003100 <+72>:  stur   x0, [x29, #-0x10]
     0x100003104 <+76>:  stur   x1, [x29, #-0x18]
     0x100003108 <+80>:  ldr    x11, [x8, #0x10]
     0x10000310c <+84>:  stur   x0, [x29, #-0x20]
     0x100003110 <+88>:  mov    x0, x9
     0x100003114 <+92>:  stur   x1, [x29, #-0x28]
     0x100003118 <+96>:  stur   x2, [x29, #-0x30]
     0x10000311c <+100>: stur   x8, [x29, #-0x38]
     0x100003120 <+104>: stur   x10, [x29, #-0x40]
     0x100003124 <+108>: stur   x9, [x29, #-0x48]
     0x100003128 <+112>: stur   x11, [x29, #-0x50]
     0x10000312c <+116>: blr    x11
     0x100003130 <+120>: ldur   x1, [x29, #-0x40]
     0x100003134 <+124>: mov    x0, x1
     0x100003138 <+128>: ldur   x1, [x29, #-0x20]
     0x10000313c <+132>: ldur   x2, [x29, #-0x30]
     0x100003140 <+136>: ldur   x8, [x29, #-0x50]
     0x100003144 <+140>: blr    x8
     0x100003148 <+144>: ldur   x8, [x29, #-0x38]
     0x10000314c <+148>: ldr    x9, [x8, #0x28]
     0x100003150 <+152>: ldur   x10, [x29, #-0x20]
     0x100003154 <+156>: mov    x0, x10
     0x100003158 <+160>: ldur   x1, [x29, #-0x48]
     0x10000315c <+164>: ldur   x2, [x29, #-0x30]
     0x100003160 <+168>: stur   x9, [x29, #-0x58]
     0x100003164 <+172>: blr    x9
     0x100003168 <+176>: ldur   x8, [x29, #-0x28]
     0x10000316c <+180>: mov    x0, x8
     0x100003170 <+184>: ldur   x1, [x29, #-0x40]
     0x100003174 <+188>: ldur   x2, [x29, #-0x30]
     0x100003178 <+192>: ldur   x9, [x29, #-0x58]
     0x10000317c <+196>: blr    x9
     0x100003180 <+200>: mov    sp, x29
     0x100003184 <+204>: ldp    x29, x30, [sp], #0x10
     0x100003188 <+208>: ret
 
 
 
 AT&T
 0x100003170 <+96>:  leaq   0x9071(%rip), %rax        ; SwiftTest.n1 : Swift.Int
 0x100003177 <+103>: leaq   0x9072(%rip), %rcx        ; SwiftTest.n2 : Swift.Int
 0x10000317e <+110>: movq   0x4ef3(%rip), %rdx        ; (void *)0x00007fff8164e1e0: type metadata for Swift.Int
 0x100003185 <+117>: movq   %rax, %rdi
 0x100003188 <+120>: movq   %rcx, %rsi
->  0x10000318b <+123>: callq  0x100003240               ; SwiftTest.swapValus<T>(inout T, inout T) -> () at main.swift:12
 
 (lldb) register read rdi
      rdi = 0x000000010000c1e8  SwiftTest`SwiftTest.n1 : Swift.Int
 (lldb) register read rsi
      rsi = 0x000000010000c1f0  SwiftTest`SwiftTest.n2 : Swift.Int
 (lldb) register read rdx
      rdx = 0x00007fff8164e1e0  libswiftCore.dylib`type metadata for Swift.Int

 
 SwiftTest`swapValus<T>(_:_:):
 ->  0x100003240 <+0>:   pushq  %rbp
     0x100003241 <+1>:   movq   %rsp, %rbp
     0x100003244 <+4>:   subq   $0x70, %rsp
     0x100003248 <+8>:   movq   $0x0, -0x10(%rbp)
     0x100003250 <+16>:  movq   $0x0, -0x18(%rbp)
     0x100003258 <+24>:  movq   %rdx, -0x8(%rbp)
 
     从 rdx -0x8 的后的内存空间里取出 8 字节 给到 rax
     0x00007fff8164e1e0 -0x8 = 0x7FFF8164E1D8
     (lldb) x/5xg 0x7FFF8164E1D8
     0x7fff8164e1d8: 0x00007fff816545d0 0x0000000000000200
     0x7fff8164e1e8: 0x00007fff2ce93870 0x0000000000000000
     0x7fff8164e1f8: 0x0000000000000000
 
     rax = 0x00007fff816545d0
 
     0x10000325c <+28>:  movq   -0x8(%rdx), %rax
 
     0x100003260 <+32>:  movq   0x40(%rax), %rcx
     0x100003264 <+36>:  addq   $0xf, %rcx
     0x100003268 <+40>:  andq   $-0x10, %rcx
     0x10000326c <+44>:  movq   %rsp, %r8
     0x10000326f <+47>:  subq   %rcx, %r8
     0x100003272 <+50>:  movq   %r8, %rsp
     0x100003275 <+53>:  movq   %rsp, %r9
     0x100003278 <+56>:  subq   %rcx, %r9
     0x10000327b <+59>:  movq   %r9, %rsp
     0x10000327e <+62>:  movq   %rdi, -0x10(%rbp)
     0x100003282 <+66>:  movq   %rsi, -0x18(%rbp)
 
     从 rax +0x10 的后的内存空间里取出 8 字节 给到 rcx
     0x00007fff816545d0 +0x10 = 0x7fff816545e0
     (lldb) x/5xg 0x7fff816545e0
     0x7fff816545e0: 0x00007fff2ce08640 0x00007fff2ce08650
     0x7fff816545f0: 0x00007fff2ce08660 0x00007fff2ce08670
     0x7fff81654600: 0x00007fff2ce08680
 
     rcx = 0x00007fff2ce08640
 
     0x100003286 <+70>:  movq   0x10(%rax), %rcx
 
     0x10000328a <+74>:  movq   %rdi, -0x20(%rbp)
     0x10000328e <+78>:  movq   %r9, %rdi
     0x100003291 <+81>:  movq   %rsi, -0x28(%rbp)
     0x100003295 <+85>:  movq   %rdx, -0x30(%rbp)
     0x100003299 <+89>:  movq   %rax, -0x38(%rbp)
     0x10000329d <+93>:  movq   %r8, -0x40(%rbp)
     0x1000032a1 <+97>:  movq   %r9, -0x48(%rbp)
     0x1000032a5 <+101>: movq   %rcx, -0x50(%rbp)
 
 
 (lldb) register read rcx
      rcx = 0x00007fff2ce08640  libswiftCore.dylib`swift::metadataimpl::ValueWitnesses<swift::metadataimpl::NativeBox<unsigned long long, 8ul, 8ul, 8ul> >::initializeWithCopy(swift::OpaqueValue*, swift::OpaqueValue*, swift::TargetMetadata<swift::InProcess> const*)
 
     0x1000032a9 <+105>: callq  *%rcx
 
     0x1000032ab <+107>: movq   -0x40(%rbp), %rdi
     0x1000032af <+111>: movq   -0x20(%rbp), %rsi
     0x1000032b3 <+115>: movq   -0x30(%rbp), %rdx
     0x1000032b7 <+119>: movq   -0x50(%rbp), %rcx
     0x1000032bb <+123>: movq   %rax, -0x58(%rbp)
     0x1000032bf <+127>: callq  *%rcx
     0x1000032c1 <+129>: movq   -0x38(%rbp), %rcx
     0x1000032c5 <+133>: movq   0x28(%rcx), %rdx
     0x1000032c9 <+137>: movq   -0x20(%rbp), %rdi
     0x1000032cd <+141>: movq   -0x48(%rbp), %rsi
     0x1000032d1 <+145>: movq   -0x30(%rbp), %r8
     0x1000032d5 <+149>: movq   %rdx, -0x60(%rbp)
     0x1000032d9 <+153>: movq   %r8, %rdx
     0x1000032dc <+156>: movq   -0x60(%rbp), %r9
     0x1000032e0 <+160>: movq   %rax, -0x68(%rbp)
     0x1000032e4 <+164>: callq  *%r9
     0x1000032e7 <+167>: movq   -0x28(%rbp), %rdi
     0x1000032eb <+171>: movq   -0x40(%rbp), %rsi
     0x1000032ef <+175>: movq   -0x30(%rbp), %rdx
     0x1000032f3 <+179>: movq   -0x60(%rbp), %rcx
     0x1000032f7 <+183>: movq   %rax, -0x70(%rbp)
     0x1000032fb <+187>: callq  *%rcx
     0x1000032fd <+189>: movq   %rbp, %rsp
     0x100003300 <+192>: popq   %rbp
     0x100003301 <+193>: retq


 */
