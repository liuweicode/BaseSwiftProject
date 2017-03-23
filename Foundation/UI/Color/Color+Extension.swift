//
//  Color+Extension.swift
//  Pods
//
//  Created by 刘伟 on 16/6/30.
//
//

import UIKit

public extension UIColor
{
    
    /**
     设置透明度
     
     - parameter alpha: 透明值
     
     - returns: UIColor
     */
    public func alphaValue(_ alpha:CGFloat) -> UIColor {
        return self.withAlphaComponent(alpha)
    }
    
    /**
     获取随机色
     
     - returns: UIColor
     */
    public class func randomColor() -> UIColor
    {
        let randomRed:CGFloat   = CGFloat(drand48())

        let randomGreen:CGFloat = CGFloat(drand48())

        let randomBlue:CGFloat  = CGFloat(drand48())

        return UIColor(red: randomRed, green: randomGreen, blue: randomBlue, alpha: 1.0)
    }
}
