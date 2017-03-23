//
//  String+Ext.swift
//  DaQu
//
//  Created by 刘伟 on 9/5/16.
//  Copyright © 2016 上海凌晋信息技术有限公司. All rights reserved.
//

import Foundation
import UIKit

func SAFE_STRING(_ str:String?) -> String {
    return String.safeString(str)
}

extension String
{
    /**
     String -> Color
     
     - parameter colorStr: 字符串 格式：RR-GG-BB-AA
     
     - returns: UIColor，默认黑色
     */
    func RR_GG_BB_AA_COLOR() -> UIColor {
        let rgbaColor = self.components(separatedBy: "-")
        if rgbaColor.count == 4 {
            if let r:Float = Float(rgbaColor[0]), let g:Float = Float(rgbaColor[1]), let b:Float = Float(rgbaColor[2]), let a:Float = Float(rgbaColor[3])
           {
                return UIColor(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: CGFloat(a) / 100.0)
            }
        }
        return UIColor.black
    }
    
    /**
     生成随机字符串
     
     - parameter length: 字符串的产股
     
     - returns: 指定长度的字符串
     */
    static func randomSmallCaseString(_ length: Int) -> String {
        var output = ""
        for _ in 0..<length {
            let randomNumber = arc4random() % 26 + 97
            let randomChar = Character(UnicodeScalar(randomNumber)!)
            output.append(randomChar)
        }
        return output
    }
    
    static func moneyFormatForYuan(sourceMoney sourceS:String) -> String
    {
        let number = NSDecimalNumber(string: sourceS)
        
        if NSDecimalNumber.notANumber.isEqual(to: number)
        {
            return number.stringValue
        }
        
        return String.formatWith(number: number, fractionDigits: 2)
    }
    
    static func moneyFormatForCent(sourceMoney sourceS:String) -> String
    {
        let number = NSDecimalNumber(string: sourceS)
        
        if NSDecimalNumber.notANumber.isEqual(to: number)
        {
            return number.stringValue
        }
        
        let yuan = String.divideWith(dividend: number.stringValue, divisor: "100", scale: 2)
        
        return moneyFormatForYuan(sourceMoney: yuan)
    }
    
    public func replacing(range: CountableClosedRange<Int>, with replacementString: String) -> String {
        let start = characters.index(characters.startIndex, offsetBy: range.lowerBound)
        let end   = characters.index(start, offsetBy: range.count)
        return self.replacingCharacters(in: start ..< end, with: replacementString)
    }
}
