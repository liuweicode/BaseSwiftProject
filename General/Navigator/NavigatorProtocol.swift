//
//  NavigatorProtocol.swift
//  BingLiYun
//
//  Created by 刘伟 on 09/12/2016.
//  Copyright © 2016 上海凌晋信息技术有限公司. All rights reserved.
//

import UIKit

@objc protocol NavigatorProtocol {
    
    // 是否是弹出模式
    var isModalView: Bool { get }
    
    // 是否需要登录
    var needLogin: Bool { get }
    
    // 是否是单例模式
    var isSingleton: Bool { get }
    
    // 导航控制器将要显示页面前会调用此方法
    @objc optional func handle(withRouterAction: RouterAction)
    
}
