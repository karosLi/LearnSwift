//
//  DynamicCall.swift
//  iOSSwiftTest
//
//  Created by karos li on 2021/8/20.
//

import Foundation

/// 把标签进行参数化
@dynamicCallable
struct RandomNumberGenerator {
    func dynamicallyCall(withKeywordArguments args: KeyValuePairs<String, Int>) -> Double {
        print(args.first?.key ?? "")
        let numberOfZeroes = Double(args.first?.value ?? 0)
        let maximum = pow(10, numberOfZeroes)
        return Double.random(in: 0...maximum)
    }
}

