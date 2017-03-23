//
//  UIFont+Ext.swift
//  DaQu
//
//  Created by 刘伟 on 2016/10/14.
//  Copyright © 2016年 上海凌晋信息技术有限公司. All rights reserved.
//

import UIKit



extension UIFont
{
    private struct AssociatedKey {
        static var sizeWidthKey = "sizeWidth"
        static var sizeHeightKey = "sizeHeight"
    }
    
    public var fontSize: CGSize {
        get {
            if let sizeWidth = objc_getAssociatedObject(self, &AssociatedKey.sizeWidthKey) as? NSNumber ,
               let sizeHeight = objc_getAssociatedObject(self, &AssociatedKey.sizeHeightKey) as? NSNumber
            {
                return CGSize(width: sizeWidth.doubleValue, height: sizeHeight.doubleValue)
                
            } else {
                return CGSize.zero
            }
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKey.sizeWidthKey, newValue.width, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            objc_setAssociatedObject(self, &AssociatedKey.sizeHeightKey, newValue.height, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    class func getFontWith(fontName:String = "Helvetica", text:String?, fontSize:CGFloat) -> UIFont {
        
        let titleFont = UIFont(name: fontName, size: fontSize) ?? UIFont.systemFont(ofSize: fontSize)
        
        if let displayStr = text
        {
            let titleSize = displayStr.sizeWithFont(font: titleFont, maxSize: CGSize(width: Int.max, height: Int.max))
            titleFont.fontSize = titleSize
        }else{
            titleFont.fontSize = CGSize.zero
        }
        
        return titleFont
    }
    
}



