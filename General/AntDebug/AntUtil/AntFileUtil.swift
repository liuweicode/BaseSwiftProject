//
//  AntFileUtil.swift
//  AntDebug
//
//  Created by 刘伟 on 23/11/2016.
//  Copyright © 2016 上海凌晋信息技术有限公司. All rights reserved.
//

import UIKit

class AntFileUtil: NSObject {

    static let documentPath:String = {
        return NSHomeDirectory() + "/Documents"
    }()
    
    /**
     判断文件(夹)是否存在
     
     - parameter filePath: 文件(夹)路径
     
     - returns: true / false
     */
    class func isFileExists(_ filePath:String) -> Bool
    {
        return FileManager.default.fileExists(atPath: filePath)
    }
    
    /**
     删除指定文件或目录
     
     - parameter path: 文件(夹)路径
     
     - returns: true / false
     */
    class func remove(_ path:String) -> Bool
    {
        var result = true
        do{
            try FileManager.default.removeItem(atPath: path)
        }catch let error as NSError {
            #if DEBUG
                print(error.description)
            #endif
            result = false
        }
        return result
    }
    
    /**
     创建文件
     
     - parameter filePath:         文件路径
     - parameter deleteWhenExists: 如果文件存在是否先删除再创建，默认`是`
     
     - returns: true / false
     */
    class func touchFile(_ filePath:String,deleteWhenExists:Bool = true) -> Bool
    {
        var result = true
        if AntFileUtil.isFileExists(filePath) {
            if deleteWhenExists {
                _ = AntFileUtil.remove(filePath)
                result = FileManager.default.createFile(atPath: filePath, contents: Data(), attributes: nil)
            }else{
                // 不做任何事情
            }
        }else{
            result = FileManager.default.createFile(atPath: filePath, contents: Data(), attributes: nil)
        }
        return result
    }
    
    /**
     写字符串到文件
     
     - parameter content:  字符串内容
     - parameter filePath: 文件路径
     
     - returns: 是否写入成功
     */
    class func writeContent(_ content:String, filePath:String) -> Bool
    {
        var result = true
        do{
            try content.write(toFile: filePath, atomically: true, encoding: String.Encoding.utf8)
        }catch let error as NSError{
            print(error.description)
            result = false
        }
        return result
    }
    
    /**
     写data到文件
     
     - parameter data:     NSData
     - parameter filePath: 文件路径
     
     - returns: 是否写入成功
     */
    class func writeData(_ data:Data, filePath:String) -> Bool
    {
        return ((try? data.write(to: URL(fileURLWithPath: filePath), options: [.atomic])) != nil)
    }
    
    /**
     追加字符串到文件
     
     - parameter content:  字符串
     - parameter filePath: 文件路径
     
     - returns: 是否写入成功
     */
    class func writeAppendContent(_ content:String, filePath:String) -> Bool
    {
        if !AntFileUtil.isFileExists(filePath) {
            _ = AntFileUtil.touchFile(filePath)
        }
        
        if let data = content.data(using: String.Encoding.utf8)
        {
            if let fileHandler = FileHandle(forUpdatingAtPath: filePath)
            {
                fileHandler.seekToEndOfFile()
                
                fileHandler.write(data)
                
                return true
            }
        }
        return false
    }
    
    /**
     追加data到文件
     
     - parameter data:     NSData
     - parameter filePath: 文件路径
     
     - returns: 是否写入成功
     */
    class func writeAppendData(_ data:Data, filePath:String) -> Bool
    {
        if !AntFileUtil.isFileExists(filePath) {
            _ = AntFileUtil.touchFile(filePath)
        }
        
        if let fileHandler = FileHandle(forUpdatingAtPath: filePath)
        {
            fileHandler.seekToEndOfFile()
            
            fileHandler.write(data)
            
            return true
        }
        return false
    }

    // 获取文件大小
    class func getFileSizeWithFilePath(filePath:String) -> UInt64
    {
        if AntFileUtil.isFileExists(filePath)
        {
            do {
                
                let attributes = try FileManager.default.attributesOfItem(atPath: filePath) as NSDictionary
                
                return attributes.fileSize()
                
            } catch let error as NSError {
                #if DEBUG
                    print(error.description)
                #endif
                return 0
            }
        }
        return 0
    }
    
    // 读取文件内容
    class func readStringWithContentsOfFile(_ filePath:String) -> String?
    {
        var content:String? = nil
        if AntFileUtil.isFileExists(filePath) {
            do{
                content = try String(contentsOfFile: filePath, encoding: String.Encoding.utf8)
            }catch let error as NSError{
                print(error.description)
            }
        }
        return content
    }
}
