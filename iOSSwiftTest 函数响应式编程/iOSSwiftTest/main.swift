//
//  main.swfit.swift
//  iOSSwiftTest
//
//  Created by karos li on 2021/8/18.
//

import UIKit

class MyApplication: UIApplication {
    
}

let random = RandomNumberGenerator()
/// numberOfZeroes 可以自定义
/// let result = random.dynamicallyCall(withKeywordArguments: ["numberOfZeroes": 3])
/// let result = random(numberOfZeroes: 3)

let result = random(numberOfZeroes: 0)

let a: Int? = nil
let b = 10
if a == b {
    
}

/// 去除了 AppDelegate 中声明的 @main，就可以在这里手动设置入口
UIApplicationMain(CommandLine.argc, CommandLine.unsafeArgv, NSStringFromClass(MyApplication.self), NSStringFromClass(AppDelegate.self))



