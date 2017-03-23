//
//  UIButton+Cache.swift
//  DaQu
//
//  Created by 刘伟 on 16/10/12.
//  Copyright © 2016年 上海凌晋信息技术有限公司. All rights reserved.
//

import UIKit
import SDWebImage

extension UIButton
{

    public func cacheWith(_ urlString: String, placeholderImage: UIImage? = nil)
    {
        if String.isBlankOrNil(sourceS: urlString)
        {
            self.setImage(placeholderImage, for: .normal)
            return
        }
        if let url = URL(string: urlString)
        {
            self.sd_setImage(with: url, for: .normal)
        }else{
            self.setImage(placeholderImage, for: .normal)
        }
    }

}
