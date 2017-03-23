//
//  ImageUtil.swift
//  AntDebug
//
//  Created by 刘伟 on 16/11/2016.
//  Copyright © 2016 上海凌晋信息技术有限公司. All rights reserved.
//

import UIKit

class AntImageUtil: NSObject {

    class func imageWithColor(_ color:UIColor) -> UIImage
    {
        let size = CGSize(width: 20, height: 80)
        UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.main.scale)
        color.set()
        UIRectFill(CGRect(x: 0, y: 0, width: size.width, height: size.height))
        let image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return image!;
    }
}
