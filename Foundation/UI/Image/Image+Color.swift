//
//  Image+Color.swift
//  Pods
//
//  Created by 刘伟 on 16/7/6.
//
//

import UIKit

public extension UIImage
{

    /**
     根据颜色获取纯色图片
     
     - parameter color: 颜色
     
     - returns: 生成的颜色图片
     */
    public static func imageWithColor(_ color:UIColor) -> UIImage
    {
        let size = CGSize(width: 20, height: 80)
        UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.main.scale)
        color.set()
        UIRectFill(CGRect(x: 0, y: 0, width: size.width, height: size.height))
        let image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return image!;
    }
    
    public static func imageWithColor(_ color:UIColor, width:CGFloat, height:CGFloat) -> UIImage
    {
        let size = CGSize(width: width, height: height)
        UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.main.scale)
        color.set()
        UIRectFill(CGRect(x: 0, y: 0, width: size.width, height: size.height))
        let image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return image!;
    }

}
