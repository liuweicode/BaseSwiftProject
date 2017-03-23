//
//  NSDate+Ext.swift
//  DaQu
//
//  Created by 刘伟 on 16/9/21.
//  Copyright © 2016年 上海凌晋信息技术有限公司. All rights reserved.
//

import UIKit
import SwiftDate

extension Date
{
    func yyyymmddhhmmss() -> String {
        return self.string(custom: "yyyy-MM-dd HH:mm:ss")
    }

    func timeAgoSinceNow() -> String {
        
        let calendar = Calendar.current
        let now = Date()
        let unitFlags: Set<Calendar.Component> = [ Calendar.Component.second, Calendar.Component.minute, Calendar.Component.hour, Calendar.Component.day, Calendar.Component.weekOfYear, Calendar.Component.month, Calendar.Component.year]
        
        let components = calendar.dateComponents(unitFlags, from: self, to: now)
        
        
        if let day = components.day , day >= 2 {
            return self.string(custom: "yyyy-MM-dd")
        }
        
        if let day = components.day , day >= 1 {
            return "昨天"
        }
        
        if let hour = components.hour , hour >= 2 {
            return "\(hour)\"小时前"
        }
        
        if let hour = components.hour , hour >= 1 {
            return "1小时前"
        }
        
        if let minute = components.minute , minute >= 2 {
            return "\(minute)分钟前"
        }
        
        if let minute = components.minute , minute >= 1 {
            return "1分钟前"
        }
        
        if let second = components.second , second >= 3 {
            return "\(second)秒前"
        }
        
        return "现在"
    }
    
//    func timeWeekDay() -> String {
//        
//        let chinese = Region(calendarName: CalendarName.chinese)
//        
//        var weekDay:String = "周八"
//        
//        switch self.inRegion(chinese).weekday {
//            case 0:
//                weekDay = "周一"
//                break
//            case 1:
//                weekDay = "周二"
//                break
//            case 2:
//                weekDay = "周三"
//                break
//            case 3:
//                weekDay = "周四"
//                break
//            case 4:
//                weekDay = "周五"
//                break
//            case 5:
//                weekDay = "周六"
//                break
//            case 6:
//                weekDay = "周日"
//                break
//            default:
//                break
//            }
//        return weekDay
//    }
}

extension Int
{
    func yyyymmddhhmmss() -> String {
        let date = Date(timeIntervalSince1970: Double(self))
        return date.yyyymmddhhmmss()
    }
    
    func timeAgoSinceNow() -> String {
        let date = Date(timeIntervalSince1970: Double(self))
        return date.timeAgoSinceNow()
    }
    
//    func timeWeekDay() -> String {
//        let date = Date(timeIntervalSince1970: Double(self))
//        return date.timeWeekDay()
//    }
}
