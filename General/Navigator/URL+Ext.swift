//
//  URL+Ext.swift
//  BingLiYun
//
//  Created by 刘伟 on 09/12/2016.
//  Copyright © 2016 上海凌晋信息技术有限公司. All rights reserved.
//

import UIKit

extension URL
{
    func parseQuery() -> [String:Any]? {
        
        guard let theQuey = self.query else { return nil }
        
        var dict = [String:Any]()
        
        let pairs = theQuey.components(separatedBy: "&")
        
        pairs.enumerated().forEach { (offset, element) in
            
            let items = element.components(separatedBy: "=")
            
            if items.count == 2
            {
                if let key = items[0].removingPercentEncoding, let val = items[1].removingPercentEncoding
                {
                    dict[key] = val
                }
            }
        }
        return dict
    }

}
