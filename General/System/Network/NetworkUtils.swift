//
//  NetworkUtils.swift
//  DaQu
//
//  Created by 刘伟 on 16/9/18.
//  Copyright © 2016年 上海凌晋信息技术有限公司. All rights reserved.
//

import UIKit

class NetworkUtils: NSObject {

    // 生成32位随机数
    class func generateRandNumber() -> String
    {
        let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        
        let randomString : NSMutableString = NSMutableString(capacity: 32)
        
        for _ in 0 ..< 32 {
            let length = UInt32 (letters.length)
            let rand = arc4random_uniform(length)
            randomString.appendFormat("%C", letters.character(at: Int(rand)))
        }
        
        return randomString as String
    }
    
    // 生成签名
    class func generateSignature(_ timestamp:String, random:String) -> String
    {
        
        let token = NetworkCipher.shared.token == nil ? "NULL" : NetworkCipher.shared.token!
        
        let sourceArr:[String] = [timestamp,random,token]
        
        let sortedArr:[String] = sourceArr.sorted { (n1, n2) -> Bool in
            return n1 < n2;
        }
        let signature = sortedArr.joined(separator: "")
        
        let sign = FSOpenSSL.sha1(from: signature)
        
        return sign == nil ? "NULL" : sign!
    }
}
