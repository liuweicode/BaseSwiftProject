//
//  DateUtil.swift
//  AntDebug
//
//  Created by 刘伟 on 16/11/2016.
//  Copyright © 2016 上海凌晋信息技术有限公司. All rights reserved.
//

import UIKit

class AntDateUtil: NSObject {

    class func getCurrentDate() -> Date
    {
        let date = Date()
        let zone = NSTimeZone.system
        let interval = zone.secondsFromGMT(for: date)
        let localeDate = date.addingTimeInterval(TimeInterval(interval))
        return localeDate
    }
}
