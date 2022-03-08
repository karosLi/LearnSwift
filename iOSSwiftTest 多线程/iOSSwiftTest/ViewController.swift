//
//  ViewController.swift
//  iOSSwiftTest
//
//  Created by karos li on 2021/8/18.
//

import UIKit

class ViewController: UIViewController {
    // 默认是 lazy，且只初始化一次
    static var age: Int = {
        // 只会初始化一次，底层调用的是 OC 里的 dispatch_once。可以断点输入 bt，查看堆栈
        print("get age")
        return 1
    }()
    
    var item: DispatchWorkItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("main", Thread.current)
        DispatchQueue.global().async {
            print("async", Thread.current)
        }
        
        
        let workItem = DispatchWorkItem {
            print("async1", Thread.current)
        }
        DispatchQueue.global().async(execute: workItem)
        
        
        Asyncs.async {
            print("1", Thread.current)
        } main: {
            print("2", Thread.current)
        }

        item = Asyncs.asyncDelay(3) {
            print("3", Thread.current)
        } main: {
            print("4", Thread.current)
        }
        
        print(Self.age)
        print(Self.age)
        print(Self.age)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        item?.cancel()
    }
}

