//
//  View+theme.swift
//  DaQu
//
//  Created by 刘伟 on 9/6/16.
//  Copyright © 2016 上海凌晋信息技术有限公司. All rights reserved.
//

import UIKit

extension UIView
{
    // 灰色分割线
    class func lightGrayLineView() -> UIView {
        let view = UIView()
        view.backgroundColor = COLOR_BACKGROUND_LIGHT_GRAY
        return view
    }
    
    // 灰色分割线
    class func darkGrayLineView() -> UIView {
        let view = UIView()
        view.backgroundColor = COLOR_BACKGROUND_DARK_GRAY
        return view
    }
}
