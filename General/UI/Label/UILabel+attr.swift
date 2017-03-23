//
//  UILabel.swift
//  Dancing
//
//  Created by 刘伟 on 28/10/2016.
//  Copyright © 2016 上海凌晋信息技术有限公司. All rights reserved.
//

import Foundation
import UIKit

extension UILabel
{
    convenience init(withText aText:String, font aFont:UIFont, textColor aColor:UIColor) {
        self.init()
        font = aFont
        textColor = aColor
        text = aText
    }
    
    convenience init(withAttributeModels array:[LabelAttributeModel]) {
        self.init()
        refresh(withAttributeModels: array)
    }
    
    func refresh(withAttributeModels array:[LabelAttributeModel])
    {
        var totalString = ""
        
        array.forEach { (model) in
            totalString += model.string
        }
        
        let totalAttr = NSMutableAttributedString(string: totalString)
        var lastIndex = 0
        
        array.enumerated().forEach { (offset, model) in
            let currentLength = model.string.length
            let font = CTFontCreateWithName("Helvetica" as CFString, model.fontSize, nil)
            totalAttr.addAttribute(NSFontAttributeName, value: font, range: NSMakeRange(lastIndex, currentLength))
            totalAttr.addAttribute(NSForegroundColorAttributeName, value: model.color, range: NSMakeRange(lastIndex, currentLength))
            lastIndex += currentLength
        }
        
        self.attributedText = totalAttr
    }
    
}
