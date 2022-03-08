//
//  main.swift
//  SwiftTest
//
//  Created by karos li on 2021/7/23.
//

import Foundation

/*
 内存访问冲突：
 1、同一时间访问同一块内存
 2、至少有一个写
 3、访问的时间重叠，比如在同一个函数内
 */

/*
 Simultaneous accesses to 0x10000c1e0, but modification requires exclusive access.
 Previous access (a modification) started at SwiftTest`main + 76 (0x1000030d0).
 Current access (a read) started at:
 0    libswiftCore.dylib                 0x000000018eef6194 swift_beginAccess + 568
 1    SwiftTest                          0x00000001000030f4 increment(_:) + 72
 2    SwiftTest                          0x0000000100003084 main + 84
 3    libdyld.dylib                      0x0000000182ef942c start + 4
 
 */
var step = 1
func increment(_ num: inout Int) { num += step }
//increment(&step)

// 解决内存冲突
var copyOfStep = step
increment(&copyOfStep)
step = copyOfStep


/*
 满足下面条件，重叠访问结构体属性是安全的：
 1、只访问实例存储属性，不是计算或者类属性
 2、结构体是局部变量，非全局变量
 3、结构体没有被闭包捕获，或者只被非逃逸闭包捕获
 
 */

