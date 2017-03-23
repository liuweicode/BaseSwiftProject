//
//  LogConfig.swift
//  DaQu
//
//  Created by 刘伟 on 8/26/16.
//  Copyright © 2016 上海凌晋信息技术有限公司. All rights reserved.
//

import UIKit

//// MARK: ============== 普通日志 ==============
//func LogInfo(_ message: @autoclosure () -> String, file: StaticString = #file, function: StaticString = #function, line: UInt = #line)
//{
//    #if DEBUG
//        let theFileName = ("\(file)" as NSString).lastPathComponent
//        print("\n\n\(theFileName)|\(function)|\(line):\(message())")
//    #endif
//}
//
//func LogWarn(_ message: @autoclosure () -> String, file: StaticString = #file, function: StaticString = #function, line: UInt = #line)
//{
//    #if DEBUG
//        let theFileName = ("\(file)" as NSString).lastPathComponent
//        print("\n\n⚠️⚠️⚠️⚠️⚠️⚠️\(theFileName)|\(function)|\(line):\(message())")
//    #endif
//}
//
//func LogError(_ message: @autoclosure () -> String, file: StaticString = #file, function: StaticString = #function, line: UInt = #line)
//{
//    #if DEBUG
//        let theFileName = ("\(file)" as NSString).lastPathComponent
//        print("\n\nFuck！！！❌❌❌❌❌❌\(theFileName)|\(function)|\(line):\(message())")
//    #endif
//}
//
//
//// MARK: ============== 网络日志 ==============
//
//func LogNetworkRequest(_ message: @autoclosure () -> String, file: StaticString = #file, function: StaticString = #function, line: UInt = #line)
//{
//    #if DEBUG
//        let theFileName = ("\(file)" as NSString).lastPathComponent
//        print("\n\n⬆️⬆️\(theFileName)|\(function)|\(line):\(message())")
//    #endif
//}
//
//func LogNetworkResponse(_ message: @autoclosure () -> String, file: StaticString = #file, function: StaticString = #function, line: UInt = #line)
//{
//    #if DEBUG
//        let theFileName = ("\(file)" as NSString).lastPathComponent
//        print("\n\n⬇️⬇️\(theFileName)|\(function)|\(line):\(message())")
//    #endif
//}
//
//func LogNetworkError(_ message: @autoclosure () -> String, file: StaticString = #file, function: StaticString = #function, line: UInt = #line)
//{
//    #if DEBUG
//        let theFileName = ("\(file)" as NSString).lastPathComponent
//        print("\n\nFuck！！！😭😭😭😭😭😭\(theFileName)|\(function)|\(line):\(message())")
//    #endif
//}
