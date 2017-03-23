//
//  Sandbox.swift
//  Pods
//
//  Created by 刘伟 on 16/7/4.
//
//

import UIKit
import Foundation

open class Sandbox: NSObject {
    
    // Documents 会被iTunes同步
    open static let documentPath:String = {
        return NSHomeDirectory() + "/Documents"
    }()
    
    // Library 会被iTunes同步
    open static let libraryPath:String =
    {
        return NSHomeDirectory() + "/Library"
    }()
    
    // 存放缓存文件，不会被iTunes同步
    open static let libraryCachesPath:String = {
       return NSHomeDirectory() + "/Library/Caches"
    }()
    
    // 沙盒临时目录 app退出后可能会被删除
    open static let tmpPath:String = {
        return NSTemporaryDirectory()
    }()
    
    
    /**
     判断文件(夹)是否存在
     
     - parameter filePath: 文件(夹)路径
     
     - returns: true / false
     */
    open static func isFileExists(_ filePath:String) -> Bool
    {
        return FileManager.default.fileExists(atPath: filePath)
    }
    
    /**
     删除指定文件或目录
     
     - parameter path: 文件(夹)路径
     
     - returns: true / false
     */
    open static func remove(_ path:String) -> Bool
    {
        var result = true
        do{
          try FileManager.default.removeItem(atPath: path)
        }catch let error as NSError {
            #if DEBUG
                ANT_LOG_ERROR(error.description)
            #endif
            result = false
        }
        return result
    }
    
    /**
     删除指定目录下所有文件
     
     - parameter directory: 目录路径
     */
    open static func removeAllFilesWithDirectory(_ directory:String)
    {
        if String.isBlankOrNil(sourceS: directory) { return }
        
        var theDirectory = directory
        
        if !directory.hasSuffix("/"){
            theDirectory += "/"
        }
        
        if let files = FileManager.default.subpaths(atPath: theDirectory)
        {
            for p in files {
                let path = theDirectory + p
                if FileManager.default.fileExists(atPath: path) {
                    do{
                        print("删除:\(path)")
                        try FileManager.default.removeItem(atPath: path)
                    }catch let error as NSError{
                        print(error.description)
                    }
                }
            }
        }
    }
    
    /**
     创建文件夹
     
     - parameter directoryPath: 文件夹路径
     
     - returns: true / false
     */
    open static func mkdir(_ directoryPath:String) -> Bool
    {
        var result = true
        if FileManager.default.fileExists(atPath: directoryPath) == false
        {
            do{
                try FileManager.default.createDirectory(atPath: directoryPath, withIntermediateDirectories: true, attributes: nil)
            }catch let error as NSError{
                print(error.description)
                result = false
            }
        }
        return result
    }
    
    /**
     创建文件
     
     - parameter filePath:         文件路径
     - parameter deleteWhenExists: 如果文件存在是否先删除再创建，默认`是`
     
     - returns: true / false
     */
    open static func touchFile(_ filePath:String,deleteWhenExists:Bool = true) -> Bool
    {
        var result = true
        if Sandbox.isFileExists(filePath) {
            if deleteWhenExists {
                _ = Sandbox.remove(filePath)
                result = FileManager.default.createFile(atPath: filePath, contents: Data(), attributes: nil)
            }else{
                // 不做任何事情
            }
        }else{
            result = FileManager.default.createFile(atPath: filePath, contents: Data(), attributes: nil)
        }
        return result
    }
    
    open static func human(_ fileSize: UInt64) -> String {
        let sizeClasses = [
            (UInt64(1024 * 1024 * 1024), "GB"),
            (UInt64(1024 * 1024), "MB"),
            (UInt64(1024), "KB"),
            ]
        for (size, unit) in sizeClasses {
            if fileSize >= size {
                let sizeInUnit = Double(fileSize) / Double(size)
                return String(format: "%0.2f\(unit)", sizeInUnit)
            }
        }
        return "\(fileSize)B"
    }
    
    /**
     如果该路径是文件，则返回文件大小 
     如果该路径是目录，则返回目录下所有文件大小总和
     
     - parameter filePath: 文件(夹)路径
     
     - returns: 文件大小
     */
//    open static func getFileSize(_ filePath:String) -> UInt64
//    {
//        let fileManager = FileManager.default
//        var bool: ObjCBool = false
//        if fileManager.fileExists(atPath: filePath, isDirectory: &bool) {
//            // 是目录
//            if bool.boolValue {
//                var folderFileSizeInBytes:UInt64 = 0
//                if let filesEnumerator = fileManager.enumerator(at: URL(fileURLWithPath: filePath, isDirectory: true), includingPropertiesForKeys: nil, options: [], errorHandler: {
//                    (url, error) -> Bool in
//                    print(url.path)
//                    print(error.localizedDescription)
//                    return true
//                }) {
//                    
//                    var fileURL = filesEnumerator.nextObject() as? URL
//                    
//                    while fileURL != nil {
//                        do {
//                            let attributes = try fileManager.attributesOfItem(atPath: fileURL!.path) as NSDictionary
//                            folderFileSizeInBytes += UInt64(attributes.fileSize().hashValue)
//                        } catch let error as NSError {
//                            print(error.localizedDescription)
//                        }
//                        fileURL = filesEnumerator.nextObject() as? URL
//                    }
//                }
////                let  byteCountFormatter =  NSByteCountFormatter()
////                byteCountFormatter.allowedUnits = .UseBytes
////                byteCountFormatter.countStyle = .File
////                let folderSizeToDisplay = byteCountFormatter.stringFromByteCount(Int64(folderFileSizeInBytes))
////                print(folderSizeToDisplay)  // "X,XXX,XXX bytes"
//                return folderFileSizeInBytes
//            }else{
//                do{
//                    let attributes :NSDictionary = try FileManager.default.attributesOfItem(atPath: filePath) as NSDictionary
//                    var fileSizeInBytes:UInt64 = 0
//                    fileSizeInBytes = UInt64(attributes.fileSize().hashValue)
//                    return fileSizeInBytes
//                }catch let error as NSError{
//                    print(error.description)
//                }
//            }
//        }
//        return 0
//    }
    
    /**
     读取指定文件内容
     
     - parameter filePath: 文件路径
     
     - returns: UTF8编码内容字符串
     */
    open static func readStringWithContentsOfFile(_ filePath:String) -> String?
    {
        var content:String? = nil
        if Sandbox.isFileExists(filePath) {
            do{
                content = try String(contentsOfFile: filePath, encoding: String.Encoding.utf8)
            }catch let error as NSError{
                print(error.description)
            }
        }
        return content
    }
    
    /**
     读取指定文件内容
     
     - parameter filePath: 文件路径
     
     - returns: data
     */
    open static func readDataWithContentsOfFile(_ filePath:String) -> Data?
    {
        var content:Data? = nil
        if Sandbox.isFileExists(filePath) {
            content = try? Data(contentsOf: URL(fileURLWithPath: filePath))
        }
        return content
    }
    
    /**
     写字符串到文件
     
     - parameter content:  字符串内容
     - parameter filePath: 文件路径
     
     - returns: 是否写入成功
     */
    open static func writeContent(_ content:String, filePath:String) -> Bool
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
    open static func writeData(_ data:Data, filePath:String) -> Bool
    {
        return ((try? data.write(to: URL(fileURLWithPath: filePath), options: [.atomic])) != nil)
    }
    
    /**
     追加字符串到文件
     
     - parameter content:  字符串
     - parameter filePath: 文件路径
     
     - returns: 是否写入成功
     */
    open static func writeAppendContent(_ content:String, filePath:String) -> Bool
    {
        if !Sandbox.isFileExists(filePath) {
            _ = Sandbox.touchFile(filePath)
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
    open static func writeAppendData(_ data:Data, filePath:String) -> Bool
    {
        if !Sandbox.isFileExists(filePath) {
            _ = Sandbox.touchFile(filePath)
        }
        
        if let fileHandler = FileHandle(forUpdatingAtPath: filePath)
        {
            fileHandler.seekToEndOfFile()
            
            fileHandler.write(data)
            
            return true
        }
        return false
    }
    
    
    
    /**
     读取当前Bundle中文件内容
     
     - parameter fileName: 文件名
     - parameter type:     文件拓展名
     
     - throws: 如果读取失败则抛出异常
     
     - returns: UTF8编码内容字符串
     */
    open static func readBundleContentOfFileName(_ fileName:String,type:String) throws -> String? {
        
        let bundle = Bundle.main
        
        var content:String?
        
        if let path = bundle.path(forResource: fileName, ofType: type)
        {
            content = try String(contentsOfFile: path, encoding:String.Encoding.utf8)
        }
       return content
    }
    

    /**
     读取当前Bundle中Json文件内容
     
     - parameter fileName: 文件名
     
     - returns: UTF8编码内容字符串
     */
    open static func readBundleJsonContentOfFileName(_ fileName:String) -> String? {
        
        var content:String?

        do{
            try content = self.readBundleContentOfFileName(fileName, type: "json")
        }catch{
            print("加载Json配置出错")
        }
        
        guard content != nil else{
            print("没有读取到JSON内容")
            return nil
        }
        
        return content
    }
}
