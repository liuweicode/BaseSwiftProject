//
//  String+Business.swift
//  BingLiYun
//
//  Created by 刘伟 on 06/12/2016.
//  Copyright © 2016 上海凌晋信息技术有限公司. All rights reserved.
//

import UIKit

extension String
{
    func getSmallImageUrlString() -> String {
        
        var finalUrl: String?
        
        if let lastDotIndex = self.lastIndexOf(target: ".")
        {
            let from = self.length - lastDotIndex - 1
            
            if from >= 0 && from < self.length
            {
                let suffix = self[from...self.length]
                finalUrl = self.replacingOccurrences(of: suffix, with: "@smallimage\(suffix)")
            }
        }
        return finalUrl ?? ""
    }

    func getThumbnailImageUrlString() -> String {
     
        var finalUrl: String?
        
        if let lastDotIndex = self.lastIndexOf(target: ".")
        {
            let from = self.length - lastDotIndex - 1
            
            if from >= 0 && from < self.length
            {
                let suffix = self[from...self.length]
                finalUrl = self.replacingOccurrences(of: suffix, with: "@thumbnails\(suffix)")
            }
        }
        return finalUrl ?? ""
    }
}
