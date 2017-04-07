//
//  UIButton+DaQu.swift
//  DaQu
//
//  Created by 刘伟 on 8/26/16.
//  Copyright © 2016 上海凌晋信息技术有限公司. All rights reserved.
//

import UIKit


extension UIButton
{
    
    // 蓝色底白色字
    class func blueButton() -> UIButton {
        let button = UIButton(type: .custom)
        button.titleLabel?.font = DFont(16)
        button.setTitleColor(UIColor.white, for: .normal)
        button.setBackgroundImage(UIImage.imageWithColor(COLOR_BUTTON_BLUE), for: .normal)
        button.setTitleColor(UIColor.white.alphaValue(0.8), for: .highlighted)
        button.setBackgroundImage(UIImage.imageWithColor(COLOR_BUTTON_BLUE.alphaValue(0.8)), for: .highlighted)
        button.setBackgroundImage(UIImage.imageWithColor(COLOR_BUTTON_GRAY), for: .disabled)
        return button
    }
    
    // 灰色底白色字
    class func grayButton() -> UIButton {
        let button = UIButton(type: .custom)
        button.titleLabel?.font = DFont(16)
        button.setTitleColor(UIColor.white, for: .normal)
        button.setBackgroundImage(UIImage.imageWithColor(COLOR_BUTTON_GRAY), for: .normal)
        button.setTitleColor(UIColor.white.alphaValue(0.8), for: .highlighted)
        button.setBackgroundImage(UIImage.imageWithColor(COLOR_BUTTON_GRAY.alphaValue(0.8)), for: .highlighted)
        return button
    }
    
}
