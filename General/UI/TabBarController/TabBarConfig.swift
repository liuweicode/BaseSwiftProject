//
//  TabBarConfig.swift
//  LinkimFoundation
//
//  Created by 刘伟 on 16/7/4.
//  Copyright © 2016年 CocoaPods. All rights reserved.
//

import UIKit
import SwiftyJSON

let FNK_TABBAR_CONFIG = "tabbar_config"

class TabBarConfig: NSObject {

    // 单例类
    static let sharedInstance = TabBarConfig()
    
    // 私有化init方法
    override init() {}
    
    var dataSource:TabBarDataSource? = {
        if let contentStr:String = Sandbox.readBundleJsonContentOfFileName(FNK_TABBAR_CONFIG)
        {
            if let jsonData = contentStr.data(using: String.Encoding.utf8, allowLossyConversion: true)
            {
                let dataSource = TabBarDataSource()
                var dict:[String:AnyObject]?
                let json = JSON(data: jsonData)
                    dataSource.backgroundColor = json["backgroundColor"].string!
                    dataSource.shadowColor = json["shadowColor"].string!
                let items = json["items"]
                for (_,subJson):(String, JSON) in items {
                    let tabBarItem = TabBarItem(title: subJson["title"].stringValue, className: subJson["className"].stringValue, normalImageName: subJson["normalImageName"].stringValue, highlightedImageName: subJson["highlightedImageName"].stringValue)
                    dataSource.items.append(tabBarItem)
                }
                return dataSource
            }
        }
        return nil
    }()
    
}
