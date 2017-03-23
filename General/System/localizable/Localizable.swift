//
//  Localizable.swift
//  Dancing
//
//  Created by 刘伟 on 27/10/2016.
//  Copyright © 2016 上海凌晋信息技术有限公司. All rights reserved.
//

import Foundation

protocol EnumeratableEnumType {
    static var allValues: [Self] {get}
}
// APP 支持的语言
enum AppLanguage: String
{
    case english = "en"
    case chinese_simplified = "Base"
    
    var description: String {
        switch self {
        case .english:
            return "English"
        case .chinese_simplified:
            return "简体中文"
        }
    }
}

extension AppLanguage: EnumeratableEnumType
{
    static var allValues: [AppLanguage]{
        return [.english, .chinese_simplified]
    }
}

func DLocalizedString(_ key:String) -> String
{
    let appLanguage = UserDefaults.standard.string(forKey: "dance_app_Language") ?? getCurrentLanguage().rawValue
    if let path = Bundle.main.path(forResource: appLanguage, ofType: "lproj")
    {
        if let bundle = Bundle(path: path)
        {
            return bundle.localizedString(forKey: key, value: nil, table: nil)
        }
    }
    return "本地化有误，请联系开发者"
}

// 获取当前语言
func getCurrentLanguage() -> AppLanguage
{
    if let lan = UserDefaults.standard.string(forKey: "dance_app_Language")
    {
        return AppLanguage(rawValue: lan)!
    }
    
    if let syslan = NSLocale.preferredLanguages.first
    {
        if syslan.hasPrefix("en")
        {
            return AppLanguage.english
        }else{
            return AppLanguage.chinese_simplified
        }
    }
    // 默认中文简体
    return AppLanguage.chinese_simplified
}

// 设置APP语言
func manualSetAppLanguage(_ lan:AppLanguage)
{
    print("选择的语言 \(lan.rawValue) \(lan.description)")
    UserDefaults.standard.set(lan.rawValue, forKey: "dance_app_Language")
    UserDefaults.standard.synchronize()
}

func getCurrentAppLanguageDesc() -> String {
    let lan = UserDefaults.standard.string(forKey: "dance_app_Language") ?? getCurrentLanguage().rawValue
    let appLanguage = AppLanguage(rawValue: lan)!
    return appLanguage.description
}


public class ObjectiveCLocalizable: NSObject
{
    public class func SwiftDLocalizedString(_ key:String) -> String
    {
        return DLocalizedString(key)
    }
    
}

