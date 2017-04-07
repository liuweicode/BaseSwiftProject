//
//  Label+theme.swift
//  DaQu
//
//  Created by 刘伟 on 9/7/16.
//  Copyright © 2016 上海凌晋信息技术有限公司. All rights reserved.
//

import UIKit

extension UILabel
{
    
    class func lightGrayLabel(fontsize aFontSize:CGFloat, text aText:String? = nil) -> UILabel
    {
        let label = UILabel()
        label.textColor = COLOR_TEXT_LIGHT_BLACK
        label.font = DFont(aFontSize)
        label.text = aText
        return label
    }
    
    class func darkGrayLabel(fontsize aFontSize:CGFloat, text aText:String? = nil) -> UILabel
    {
        let label = UILabel()
        label.textColor = COLOR_TEXT_DARK_BLACK
        label.font = DFont(aFontSize)
        label.text = aText
        return label
    }
    
    class func pinkLabel(fontsize aFontSize:CGFloat, text aText:String? = nil) -> UILabel
    {
        let label = UILabel()
        label.textColor = COLOR_TEXT_PINK
        label.font = DFont(aFontSize)
        label.text = aText
        return label
    }
}

