//
//  StringUtil.swift
//  AntDebug
//
//  Created by 刘伟 on 16/11/2016.
//  Copyright © 2016 上海凌晋信息技术有限公司. All rights reserved.
//

import UIKit

class StringUtil: NSObject {

    /**
     计算字符串大小
     
     - parameter font:    字体
     - parameter maxSize: 最大size
     
     - returns: 字符串大小
     */
    class func sizeWith(text textString:String, font aFont:UIFont, maxSize size:CGSize) -> CGSize {
        if textString.isEmpty {
            return CGSize.zero
        }
        let size = textString.boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: [NSFontAttributeName : aFont], context: nil).size
        return CGSize(width: ceil(size.width), height: ceil(size.height)) // 向上取整
    }
    
}
