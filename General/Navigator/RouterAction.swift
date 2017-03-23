//
//  RouterAction.swift
//  BingLiYun
//
//  Created by 刘伟 on 09/12/2016.
//  Copyright © 2016 上海凌晋信息技术有限公司. All rights reserved.
//

import UIKit

enum RouterAnimation {
    case none // 没有动画
    case push // 标准的导航压入动画
}

class RouterAction: NSObject {

    // 需要导航到的URL地址
    fileprivate var _url: URL?
    var url: URL?
    {
        get{
            return _url
        }
    }
    
    // 导航动画
    var animation: RouterAnimation?
    
    // 所有参数构建成query
    fileprivate var _query: String?
    var query: String?
        {
        get{
            return _query
        }
    }
    
    var openParams: [String: Any]?
    
    init(url: URL) {
        super.init()
        _url = url
        openParams = url.parseQuery()
    }
    
    convenience init(urlString: String) {
        
        var theUrl = URL(string:urlString)
        if theUrl == nil
        {
            theUrl = URL(string:"")
        }
        self.init(url:theUrl!)
    }
    
    
}
