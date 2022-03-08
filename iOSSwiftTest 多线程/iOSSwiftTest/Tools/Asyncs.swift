//
//  Asyncs.swift
//  iOSSwiftTest
//
//  Created by karos li on 2021/8/19.
//

import Foundation

public typealias Task = () -> Void

public struct Asyncs {
    
    // MARK: - 异步执行
    @discardableResult
    public static func async(_ task: @escaping Task) -> DispatchWorkItem   {
        _async(task)
    }
    
    @discardableResult
    public static func async(_ task: @escaping Task, main: @escaping Task) -> DispatchWorkItem   {
        _async(task, main)
    }
    
    private static func _async(_ task: @escaping Task, _ main: Task? = nil) -> DispatchWorkItem  {
        let workItem = DispatchWorkItem(block: task)
        DispatchQueue.global().async(execute: workItem)
        
        if let main = main {
            workItem.notify(queue: DispatchQueue.main, execute: main)
        }
        
        return workItem
    }
    
    // MARK: - 异步在主队列delay执行
    @discardableResult
    public static func delay(_ seconds: Double, _ block: @escaping Task) -> DispatchWorkItem {
        let workItem = DispatchWorkItem(block: block)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + seconds, execute: workItem)
        return workItem
    }
    
    // MARK: - 异步delay执行
    @discardableResult
    public static func asyncDelay(_ seconds: Double, _ task: @escaping Task) -> DispatchWorkItem {
        return _asyncDelay(seconds, task)
    }
    
    @discardableResult
    public static func asyncDelay(_ seconds: Double, _ task: @escaping Task, main: @escaping Task) -> DispatchWorkItem {
        return _asyncDelay(seconds, task, main)
    }
    
    private static func _asyncDelay(_ seconds: Double, _ task: @escaping Task, _ main: Task? = nil) -> DispatchWorkItem {
        let workItem = DispatchWorkItem(block: task)
        DispatchQueue.global().asyncAfter(deadline: DispatchTime.now() + seconds, execute: workItem)
        
        if let main = main {
            workItem.notify(queue: DispatchQueue.main, execute: main)
        }
        
        return workItem
    }

}
