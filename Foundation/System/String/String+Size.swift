//
//  String+Size.swift
//  Pods
//
//  Created by 刘伟 on 16/7/1.
//
//

import UIKit

extension String
{
    /**
     计算字符串大小
     
     - parameter font:    字体
     - parameter maxSize: 最大size
     
     - returns: 字符串大小
     */
    public func sizeWithFont(font:UIFont,maxSize:CGSize) -> CGSize {
        if self.isEmpty {
            return CGSize.zero
        }
        let size = self.boundingRect(with: maxSize, options: .usesLineFragmentOrigin, attributes: [NSFontAttributeName : font], context: nil).size
        return CGSize(width: ceil(size.width), height: ceil(size.height)) // 向上取整
    }
    
}
