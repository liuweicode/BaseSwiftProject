//
//  NSAttributedString+theme.swift
//  Dancing
//
//  Created by 刘伟 on 28/10/2016.
//  Copyright © 2016 上海凌晋信息技术有限公司. All rights reserved.
//

import Foundation
import UIKit

class LabelAttributeModel: NSObject {
    
    var fontSize: CGFloat = 0
    
    var color: UIColor = UIColor.black
    
    var string: String = ""
    
    var isBold: Bool = false // 是否是粗体
    
    override init() {
       super.init()
    }
    
    init(string:String, fontSize:CGFloat, color:UIColor, isBold:Bool = false) {
        super.init()
        self.string = string
        self.fontSize = fontSize
        self.color = color
        self.isBold = isBold
    }
}

extension NSAttributedString
{
    
    class func getAttributedString(withAttributeModels array:[LabelAttributeModel]) -> NSMutableAttributedString {
        
        var totalString = ""
        
        array.forEach { (model) in
            totalString += model.string
        }
        
        let totalAttr = NSMutableAttributedString(string: totalString)
        var lastIndex = 0
        
        array.enumerated().forEach { (offset, model) in
            let currentLength = model.string.length
            let fontName = model.isBold ? "Helvetica-Bold" : "Helvetica"
            let font = CTFontCreateWithName(fontName as CFString, model.fontSize, nil)
            totalAttr.addAttribute(NSFontAttributeName, value: font, range: NSMakeRange(lastIndex, currentLength))
            totalAttr.addAttribute(NSForegroundColorAttributeName, value: model.color, range: NSMakeRange(lastIndex, currentLength))
            lastIndex += currentLength
        }
        
        return totalAttr
    }
    
}
