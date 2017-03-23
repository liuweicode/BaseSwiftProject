//
//  String+arithmetic.swift
//  DaQu
//
//  Created by 刘伟 on 16/9/29.
//  Copyright © 2016年 上海凌晋信息技术有限公司. All rights reserved.
//

import Foundation

extension String
{
    
    /// 除法运算
    ///
    /// - parameter dividendStr: 被除数
    /// - parameter divisorStr:  除数
    /// - parameter scaleI:      保留小数位数
    ///
    /// - returns: 除法运算结果
    static func divideWith(dividend dividendStr: String, divisor divisorStr: String, scale scaleI: Int16 ) -> String
    {
        let dividendNumber = NSDecimalNumber(string: dividendStr)
        
        let divisorNumber = NSDecimalNumber(string: divisorStr)
        
        let numHander = NSDecimalNumberHandler(roundingMode: .plain, scale: scaleI, raiseOnExactness: false, raiseOnOverflow: false, raiseOnUnderflow: false, raiseOnDivideByZero: false)
        
        let totoalNumber = dividendNumber.dividing(by: divisorNumber, withBehavior: numHander)
        
        return totoalNumber.stringValue
    }
    
    
    /// 乘法运算
    ///
    /// - parameter multiplierStr1: 乘数1
    /// - parameter multiplierStr2: 乘数2
    ///
    /// - returns: 乘法运算结果
    static func multiplyWith(multiplier1 multiplierStr1: String, multiplier2 multiplierStr2: String) -> String
    {
        let num1 = NSDecimalNumber(string: multiplierStr1)
        
        let num2 = NSDecimalNumber(string: multiplierStr2)
        
        let numHander = NSDecimalNumberHandler(roundingMode: .plain, scale: Int16.max, raiseOnExactness: false, raiseOnOverflow: false, raiseOnUnderflow: false, raiseOnDivideByZero: false)
        
        return num1.multiplying(by: num2, withBehavior: numHander).stringValue
    }
    
    /// 减法运算
    ///
    /// - parameter minuendStr:    被减数
    /// - parameter subtrahendStr: 减数
    ///
    /// - returns: 减法运算结果
    static func subtractWith(minuend minuendStr: String, subtrahend subtrahendStr: String) -> String
    {
        let minuendNumber = NSDecimalNumber(string: minuendStr)
        
        let subtrahendNumber = NSDecimalNumber(string: subtrahendStr)
        
        let numHander = NSDecimalNumberHandler(roundingMode: .plain, scale: Int16.max, raiseOnExactness: false, raiseOnOverflow: false, raiseOnUnderflow: false, raiseOnDivideByZero: false)
        
        return minuendNumber.subtracting(subtrahendNumber, withBehavior: numHander).stringValue
    }
    
    /// 加法运算
    ///
    /// - parameter number1Str: 数字1
    /// - parameter number2Str: 数字2
    ///
    /// - returns: 加法运算结果
    static func addWith(number1 number1Str: String, number2 number2Str: String) -> String
    {
        let num1 = NSDecimalNumber(string: number1Str)
        
        let num2 = NSDecimalNumber(string: number2Str)
        
        let numHander = NSDecimalNumberHandler(roundingMode: .plain, scale: Int16.max, raiseOnExactness: false, raiseOnOverflow: false, raiseOnUnderflow: false, raiseOnDivideByZero: false)
        
        return num1.adding(num2, withBehavior: numHander).stringValue
    }
    
    
    /// 数字1 是否比 数字2 大
    ///
    /// - parameter leftStr:  数字1
    /// - parameter rightStr: 数字2
    ///
    /// - returns: 如果传入数据有一个不是合法的数字 则返回false
    static func isBiggerWith(left leftStr: String, right rightStr: String) -> Bool
    {
        if !String.isNumber(leftStr) || !String.isNumber(rightStr)
        {
            return false
        }
        
        let leftNumber = NSDecimalNumber(string: leftStr)
        
        let rightNumber = NSDecimalNumber(string: rightStr)
        
        return rightNumber.compare(leftNumber) == .orderedAscending
    }
    
    
    /// 数字1 是否大于等于 数字2
    ///
    /// - parameter leftStr:  数字1
    /// - parameter rightStr: 数字2
    ///
    /// - returns: 如果传入数据有一个不是合法的数字 则返回false
    static func isBiggerOrEqualWith(left leftStr: String, right rightStr: String) -> Bool
    {
        if !String.isNumber(leftStr) || !String.isNumber(rightStr)
        {
            return false
        }
        
        let leftNumber = NSDecimalNumber(string: leftStr)
        
        let rightNumber = NSDecimalNumber(string: rightStr)
        
        return rightNumber.compare(leftNumber) == .orderedAscending || rightNumber.compare(leftNumber) == .orderedSame
    }
    
    
    /// 数字1 是否等于 数字2
    ///
    /// - parameter leftStr:  数字1
    /// - parameter rightStr: 数字2
    ///
    /// - returns: 如果传入数据有一个不是合法的数字 则返回false
    static func isEqualWith(left leftStr: String, right rightStr: String) -> Bool
    {
        if !String.isNumber(leftStr) || !String.isNumber(rightStr)
        {
            return false
        }
        
        let leftNumber = NSDecimalNumber(string: leftStr)
        
        let rightNumber = NSDecimalNumber(string: rightStr)
        
        return leftNumber.isEqual(to: rightNumber)
    }

}
