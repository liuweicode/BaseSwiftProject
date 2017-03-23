//
//  String+Utils.swift
//  Pods
//
//  Created by 刘伟 on 16/7/1.
//
//

import Foundation

public extension String
{
    // 字符串长度
    var length: Int { return self.characters.count }
    
    // 转OC字符串
    var OCString: NSString {
        get {
            return self as NSString
        }
    }
    
    /**
     trim 去除两端空格
     
     - returns: eg. " 1 2 " -> "1 2"
     */
    static func trim(_ sourceS:String) -> String {
        return sourceS.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }
    
    /**
     如果String是nil，则返回空字符串
     
     - parameter optionalString: 可选的String
     
     - returns: 安全的字符串
     */
    static func safeString(_ optionalString:String?) -> String {
        return optionalString ?? ""
    }
    
    func indexOf(target: String) -> Int? {
        
        let range = (self as NSString).range(of: target)
        
        guard range.toRange() != nil else {
            return nil
        }
        
        return range.location
        
    }
    func lastIndexOf(target: String) -> Int? {
        
        let range = (self as NSString).range(of: target, options: NSString.CompareOptions.backwards)
        
        guard range.toRange() != nil else {
            return nil
        }
        
        return self.length - range.location - 1
    }
    
    subscript(i: Int) -> String {
        guard i >= 0 && i < characters.count else { return "" }
        return String(self[index(startIndex, offsetBy: i)])
    }
    subscript(range: Range<Int>) -> String {
        let lowerIndex = index(startIndex, offsetBy: max(0,range.lowerBound), limitedBy: endIndex) ?? endIndex
        return substring(with: lowerIndex..<(index(lowerIndex, offsetBy: range.upperBound - range.lowerBound, limitedBy: endIndex) ?? endIndex))
    }
    subscript(range: ClosedRange<Int>) -> String {
        let lowerIndex = index(startIndex, offsetBy: max(0,range.lowerBound), limitedBy: endIndex) ?? endIndex
        return substring(with: lowerIndex..<(index(lowerIndex, offsetBy: range.upperBound - range.lowerBound + 1, limitedBy: endIndex) ?? endIndex))
    }
    
    /**
     手机号格式化
     
     - parameter sourceS: 手机号
     
     - returns: 格式化后的手机号
     */
    
    
    // 根据指定长度 生成随机字符串
    func randomStringWithLength (len : Int) -> NSString {
        
        let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        
        let randomString : NSMutableString = NSMutableString(capacity: len)
        
        for _ in 0 ..< len {
            let length = UInt32 (letters.length)
            let rand = arc4random_uniform(length)
            randomString.appendFormat("%C", letters.character(at: Int(rand)))
        }
        
        return randomString
    }
}
