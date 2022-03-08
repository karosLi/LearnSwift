//
//  main.swift
//  SwiftTest
//
//  Created by karos li on 2021/7/23.
//

import Foundation


/**
 0x100002ddd <+109>:  movq   %rax, 0x9414(%rip)        ; SwiftTest.arr : Swift.Array<Swift.Int>
 0x100002de4 <+116>:  movl   $0x1, %edi
 
 arr 全局变量地址 = 0x100002de4 + 0x9414 = 0x10000C1F8
 
 里面存的是数组的堆空间地址
 (lldb) x/1xg 0x10000C1F8
 0x10000c1f8: 0x0000000108bcaae0
 
 (lldb) x/10xg 0x0000000108bcaae0
 前面 32 个字节是类型和引用计数相关信息[?, 引用计数，元素数量，数组容量?]
 0x108bcaae0: 0x00007fff8166d0d0 0x0000000000000003
 0x108bcaaf0: 0x0000000000000005 0x000000000000000a
 实际存储的 1, 2, 3, 4, 5
 0x108bcab00: 0x0000000000000001 0x0000000000000002
 0x108bcab10: 0x0000000000000003 0x0000000000000004
 0x108bcab20: 0x0000000000000005 0x01b3000300000000
 */
var arr = [1, 2, 3, 4, 5]
// 0x0000000108bcaae0
print(Mems.memStr(ofVal: &arr))
// 0x00007fff8166d0d0 0x0000000200000003 0x0000000000000005 0x000000000000000a 0x0000000000000001 0x0000000000000002 0x0000000000000003 0x0000000000000004 0x0000000000000005 0x01b3000300000000
print(Mems.memStr(ofRef: arr))
// 8
print(MemoryLayout.stride(ofValue: arr))
// 8
print(MemoryLayout<Int>.stride)

