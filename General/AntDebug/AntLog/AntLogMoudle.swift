//
//  AntLogMoudle.swift
//  AntDebug
//
//  Created by 刘伟 on 23/11/2016.
//  Copyright © 2016 上海凌晋信息技术有限公司. All rights reserved.
//

import UIKit

let ANT_LOG_FILE_PATH = "LogFilePath"
let ANT_LOG_CRASH_FILE_PATH = "LogCrash"

let ANT_LOG_CLICK_EVENT_FILE_PATH = "LogClickEvent"
let ANT_LOG_NETWORK_FILE_PATH = "LogNetwork"


fileprivate func _ant_write_log_to_file(content:String?, filePath:String = ANT_LOG_FILE_PATH)
{
    guard let contentStr = content else {
        return
    }
    
    let urlString = AntFileUtil.documentPath + "/" + filePath
    
    _ = AntFileUtil.touchFile(urlString, deleteWhenExists: false)
    
    let size = AntFileUtil.getFileSizeWithFilePath(filePath: urlString)
    if size > (1000 * 1000)
    {
        // 超过1000K，重写文件
        _ = AntFileUtil.writeContent(contentStr, filePath: urlString)
    }
    _ = AntFileUtil.writeAppendContent(contentStr, filePath: urlString)
}

func ANT_LOG_EVENT(event:String, label:String)
{
    #if DEBUG
        
    let date = AntDateUtil.getCurrentDate()
    
    AntGALogWindow.instance().showGAEvent(withCategory: event, action: nil, label: nil, value: 0, extras: nil)
    
    print("\r\n\(label)|\(event)")
        
    _ant_write_log_to_file(content: "T:\(date)E:\(event), V:\(label)\r\n", filePath: ANT_LOG_CLICK_EVENT_FILE_PATH)
    
    #endif
}

func ANT_LOG_INFO(_ message: @autoclosure () -> String, file: StaticString = #file, function: StaticString = #function, line: UInt = #line)
{
    #if DEBUG
        
        AntGALogWindow.instance().showGAEvent(withCategory: message(), action: nil, label: nil, value: 0, extras: nil)
        
        let theFileName = ("\(file)" as NSString).lastPathComponent
        print("\r\n\(theFileName)|\(function)|\(line):\(message())")
        
        _ant_write_log_to_file(content: "\r\n\(theFileName)|\(function)|\(line):\(message())")
        
    #endif
}

func ANT_LOG_WARN(_ message: @autoclosure () -> String, file: StaticString = #file, function: StaticString = #function, line: UInt = #line)
{
    #if DEBUG
        
        AntGALogWindow.instance().showGAEvent(withCategory: message(), action: nil, label: nil, value: 0, extras: nil)
        
        let theFileName = ("\(file)" as NSString).lastPathComponent
        print("\n\n⚠️⚠️⚠️⚠️⚠️⚠️\(theFileName)|\(function)|\(line):\(message())")
        
        _ant_write_log_to_file(content: "\n\n⚠️⚠️⚠️⚠️⚠️⚠️\(theFileName)|\(function)|\(line):\(message())")
        
    #endif
}

func ANT_LOG_ERROR(_ message: @autoclosure () -> String, file: StaticString = #file, function: StaticString = #function, line: UInt = #line)
{
    #if DEBUG
        
        AntGALogWindow.instance().showGAEvent(withCategory: message(), action: nil, label: nil, value: 0, extras: nil)
        
        let theFileName = ("\(file)" as NSString).lastPathComponent
        print("\n\n❌❌❌❌❌❌\(theFileName)|\(function)|\(line):\(message())")
        
        _ant_write_log_to_file(content: "\n\n❌❌❌❌❌❌\(theFileName)|\(function)|\(line):\(message())")
        
    #endif
}

func ANT_LOG_NETWORK_REQUEST(_ message: @autoclosure () -> String, file: StaticString = #file, function: StaticString = #function, line: UInt = #line)
{
    #if DEBUG
        
        AntGALogWindow.instance().showGAEvent(withCategory: message(), action: nil, label: nil, value: 0, extras: nil)
        
        let theFileName = ("\(file)" as NSString).lastPathComponent
        print("\n\n⬆️⬆️\(theFileName)|\(function)|\(line):\(message())")
        
        _ant_write_log_to_file(content: "\n\n⬆️⬆️\(theFileName)|\(function)|\(line):\(message())", filePath: ANT_LOG_NETWORK_FILE_PATH)
        
    #endif
}

func ANT_LOG_NETWORK_RESPONSE(_ message: @autoclosure () -> String, file: StaticString = #file, function: StaticString = #function, line: UInt = #line)
{
    #if DEBUG
        
        AntGALogWindow.instance().showGAEvent(withCategory: message(), action: nil, label: nil, value: 0, extras: nil)
        
        let theFileName = ("\(file)" as NSString).lastPathComponent
        print("\n\n⬇️⬇️\(theFileName)|\(function)|\(line):\(message())")
        
        _ant_write_log_to_file(content: "\n\n⬇️⬇️\(theFileName)|\(function)|\(line):\(message())", filePath: ANT_LOG_NETWORK_FILE_PATH)
        
    #endif
}

func ANT_LOG_NETWORK_ERROR(_ message: @autoclosure () -> String, file: StaticString = #file, function: StaticString = #function, line: UInt = #line)
{
    #if DEBUG
        
        AntGALogWindow.instance().showGAEvent(withCategory: message(), action: nil, label: nil, value: 0, extras: nil)
        
        let theFileName = ("\(file)" as NSString).lastPathComponent
        print("\n\n😭😭😭😭😭😭Fuck！！！\(theFileName)|\(function)|\(line):\(message())")
        
        _ant_write_log_to_file(content: "\n\n😭😭😭😭😭😭Fuck！！！\(theFileName)|\(function)|\(line):\(message())", filePath: ANT_LOG_NETWORK_FILE_PATH)
        
    #endif
}


class AntLogMoudle: NSObject {

   
}
