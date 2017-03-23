//
//  String+Format.swift
//  DaQu
//
//  Created by 刘伟 on 16/9/29.
//  Copyright © 2016年 上海凌晋信息技术有限公司. All rights reserved.
//

import Foundation

extension String
{
    /// 格式化数字 保留小数位数 不足补0
    ///  四舍五入方式
    /// - parameter numberS:         原始数字
    /// - parameter afractionDigits: 小数位数
    ///
    /// - returns:
    static func formatWith(number numberS:NSNumber, fractionDigits afractionDigits: Int) -> String
    {
        
        let numberFormatter = NumberFormatter()
        
        numberFormatter.numberStyle = .decimal
        
        numberFormatter.maximumFractionDigits = afractionDigits
        
        numberFormatter.minimumFractionDigits = afractionDigits
        
        let formatNum = numberFormatter.string(from: numberS)
        
        return formatNum ?? NSDecimalNumber.notANumber.stringValue
    }
    
    /// 格式化手机号
    ///
    /// - parameter sourceS: 手机号 13800138000
    ///
    /// - returns: 格式化后的手机号 138 0013 8000
    static func phoneFormat(_ sourceS:String) -> String{
        if sourceS.length > 0 {
            var tmpS = sourceS
            for i in stride(from: 3, to: sourceS.length, by: 5) {
                tmpS.insert(" ", at: sourceS.characters.index(sourceS.startIndex, offsetBy: i))
            }
            return tmpS
        }
        return sourceS
    }
    
}
