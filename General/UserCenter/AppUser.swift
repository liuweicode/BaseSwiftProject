//
//  AppUser.swift
//  DaQu
//
//  Created by 刘伟 on 9/5/16.
//  Copyright © 2016 上海凌晋信息技术有限公司. All rights reserved.
//

import UIKit
import SwiftyJSON

enum Gender : Int{
    
    //  1=男 2=女 0=未知
    case unknow = 0, male = 1, female = 2
}

enum AgeType : Int{
    
    //  1=年 2=月
    case year = 1, month = 2
}


class AppUser: NSObject, NSCoding {
    
    var auto_login_secret: String = ""       //自动登录秘钥
    var phone: String = ""                   //手机号
    var real_name: String = ""               //用户真实姓名
    var nick_name: String = ""               //用户昵称
    var avatar: String = ""
    var user_ids: String = ""
    var f_car_type_id: Int = 0 // 我的车型
    var car_type_name: String = ""
    var car_brand_name: String = ""
    
    override init() {
        super.init()
    }
    
    init(json:JSON) {
        //用户自动登录秘钥
        self.auto_login_secret = json["auto_login_secret"].stringValue
        //手机号
        self.phone = json["phone"].stringValue
        //用户真实姓名
        self.real_name = json["real_name"].stringValue
        //用户昵称
        self.nick_name = json["nick_name"].stringValue
        //用户头像
        self.avatar = json["avatar"].stringValue
        //用户身份标识码
        self.user_ids = json["user_ids"].stringValue
        // 车型
        self.f_car_type_id = json["f_car_type_id"].intValue
        self.car_type_name = json["car_type_name"].stringValue
        self.car_brand_name = json["car_brand_name"].stringValue
    }
    
    // 序列化
    func encode(with aCoder: NSCoder) {
        aCoder.encode(auto_login_secret, forKey: "auto_login_secret")
        aCoder.encode(phone, forKey: "phone")
        aCoder.encode(real_name, forKey: "real_name")
        aCoder.encode(nick_name, forKey: "nick_name")
        aCoder.encode(avatar, forKey: "avatar")
        aCoder.encode(user_ids, forKey: "user_ids")
        aCoder.encode(f_car_type_id, forKey: "f_car_type_id")
        aCoder.encode(car_type_name, forKey: "car_type_name")
        aCoder.encode(car_brand_name, forKey: "car_brand_name")
    }
    
    // 反序列化
    required init?(coder aDecoder: NSCoder) {
        super.init()
        self.auto_login_secret = aDecoder.decodeObject(forKey: "auto_login_secret") as? String ?? ""
        self.phone = aDecoder.decodeObject(forKey: "phone") as? String ?? ""
        self.real_name = aDecoder.decodeObject(forKey: "real_name") as? String ?? ""
        self.nick_name = aDecoder.decodeObject(forKey: "nick_name") as? String ?? ""
        self.avatar = aDecoder.decodeObject(forKey: "avatar") as? String ?? ""
        self.user_ids = aDecoder.decodeObject(forKey: "user_ids") as? String ?? ""
        self.f_car_type_id = aDecoder.decodeObject(forKey: "f_car_type_id") as? Int ?? 0
        self.car_type_name = aDecoder.decodeObject(forKey: "car_type_name") as? String ?? ""
        self.car_brand_name = aDecoder.decodeObject(forKey: "car_brand_name") as? String ?? ""
    }
}
