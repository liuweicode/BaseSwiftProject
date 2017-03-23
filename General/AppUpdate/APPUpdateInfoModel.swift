//
//  APPUpdateInfoModel.swift
//  BingLiYun
//
//  Created by 刘伟 on 30/11/2016.
//  Copyright © 2016 上海凌晋信息技术有限公司. All rights reserved.
//

import UIKit
import SwiftyJSON

enum APPUpdateAtionType: Int
{
    case optional = 0 // 可选更新
    case forcing = 1 // 强制更新
}

class APPUpdateInfoModel: NSObject {

    var code = 0 // #版本代码
    var version = "" // #版本编号
    var instruction = "" //更新说明", #更新说明
    var is_force = APPUpdateAtionType.optional //#是否强制更新
    var app_url = "" //#更新url
    
    init(json:JSON) {
        super.init()
        self.code = json["code"].intValue
        self.version = json["version"].stringValue
        self.instruction = json["instruction"].stringValue
        self.is_force = APPUpdateAtionType(rawValue: json["is_force"].intValue) ?? APPUpdateAtionType.optional
        self.app_url = json["app_url"].stringValue
    }
}
