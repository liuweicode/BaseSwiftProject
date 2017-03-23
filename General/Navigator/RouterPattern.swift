//
//  RouterPattern.swift
//  BingLiYun
//
//  Created by 刘伟 on 09/12/2016.
//  Copyright © 2016 上海凌晋信息技术有限公司. All rights reserved.
//

import UIKit

enum RouterPatternType {
    case clazz, http, html
}

class RouterPattern: NSObject {

    var key: String?
    
    var type: RouterPatternType?
    
    var patternString: String?
    
    
}
