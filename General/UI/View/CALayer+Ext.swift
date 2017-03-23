//
//  CALayer+Ext.swift
//  Dancing
//
//  Created by 刘伟 on 28/10/2016.
//  Copyright © 2016 上海凌晋信息技术有限公司. All rights reserved.
//

import QuartzCore
import UIKit

extension CALayer
{
    func setBorderColorFromUIColor(color:UIColor)
    {
       self.borderColor = color.cgColor;
    }
}
