//
//  main.swfit.swift
//  iOSSwiftTest
//
//  Created by karos li on 2021/8/18.
//

import UIKit

class MyApplication: UIApplication {
    
}

/// 去除了 AppDelegate 中声明的 @main，就可以在这里手动设置入口
UIApplicationMain(CommandLine.argc, CommandLine.unsafeArgv, NSStringFromClass(MyApplication.self), NSStringFromClass(AppDelegate.self))
