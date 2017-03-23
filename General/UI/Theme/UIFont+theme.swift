//
//  UIFont+theme.swift
//  DaQu
//
//  Created by 刘伟 on 8/30/16.
//  Copyright © 2016 上海凌晋信息技术有限公司. All rights reserved.
//

import UIKit

// 全局默认字体
func DFont(_ fontSize:CGFloat) -> UIFont {
    return UIFont.systemFont(ofSize: fontSize)
}

// 全局默认字体 粗体
func DBFont(_ fontSize:CGFloat) -> UIFont {
    return UIFont.boldSystemFont(ofSize: fontSize)
}
