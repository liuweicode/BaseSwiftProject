//
//  View+Ext.swift
//  DaQu
//
//  Created by 刘伟 on 9/6/16.
//  Copyright © 2016 上海凌晋信息技术有限公司. All rights reserved.
//

import UIKit

extension UIView
{

    func parentController() -> UIViewController? {
        var responder = self.next
        while responder != nil {
            
            if responder!.isKind(of: UIViewController.self) {
                return responder as? UIViewController
            }
            responder = responder!.next
        }
        return nil
    }
    
}

