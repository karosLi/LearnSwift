//
//  Cache.swift
//  iOSSwiftTest
//
//  Created by karos li on 2021/8/19.
//

import Foundation

public struct Cache {
    private static var data = [String: Any]()
    private static var lock = DispatchSemaphore(value: 1)
    
    public static func get(_ key: String) -> Any? {
        lock.wait()
        defer {
            lock.signal()
        }
        
        return data[key]
    }
    
    public static func set(_ key: String, _ value: Any) {
        lock.wait()
        defer {
            lock.signal()
        }
        
        data[key] = value
    }
}
