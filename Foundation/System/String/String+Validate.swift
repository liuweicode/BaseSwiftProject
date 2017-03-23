//
//  String+Validate.swift
//  Pods
//
//  Created by 刘伟 on 16/7/1.
//
//

import Foundation

extension String
{

    /**
     是否是有效的手机号
     
     - returns: true / false
     */
    static func isMobile(sourceS:String?) -> Bool {
        
        guard let mobile = sourceS else {
            return false
        }
        
        let MOBILE = "^1(3[0-9]|5[0-9]|8[0-9]|4[0-9]|7[0-9])\\d{8}$"
        
        let regextestmobile = NSPredicate(format: "SELF MATCHES %@",MOBILE)
        
        return regextestmobile.evaluate(with: mobile)
    }
    
    /**
        是否是有效合法的密码
     */
    static func isValidPassword(sourceS:String?) -> Bool {
        
        guard let pwd = sourceS else {
            return false
        }
        
        return (pwd.length >= 6 && pwd.length <= 16)
    }

    /**
     是否是有效的身份证
     
     - returns: true / false
     */
    static func isIDCard(sourceS:String) -> Bool {
        
        let MOBILE = "^(\\d{14}|\\d{17})(\\d|[xX])$"
        
        let regextestmobile = NSPredicate(format: "SELF MATCHES %@",MOBILE)
        
        return regextestmobile.evaluate(with: sourceS)
    }

    /**
     是否是空字符串
     比如 "  " -> true
         " 1 " -> false
     
     - returns: true / false
     */
//    static func isBlank(sourceS:String) -> Bool {
//        let trimmed = String.trim(sourceS)
//        return trimmed.isEmpty
//    }
    
    static func isBlankOrNil(sourceS:String?) -> Bool {
        guard let str = sourceS else {
            return true
        }
        let trimmed = String.trim(str)
        return trimmed.isEmpty
    }
    
    
    /// 是否是一个数字
    ///
    /// - parameter sourceS: 输入字符串
    ///
    /// - returns: true / false
    static func isNumber(_ sourceS:String) -> Bool {
        
        let PUREINT = "^(\\-|\\+)?\\d+(\\.\\d+)?$"
        
        let regextestmobile = NSPredicate(format: "SELF MATCHES %@",PUREINT)
        
        return regextestmobile.evaluate(with: sourceS)
    }
}
