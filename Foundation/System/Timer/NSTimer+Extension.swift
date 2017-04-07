//
//  NSTimer+Extension.swift
//  Pods
//
//  Created by 刘伟 on 16/6/30.
//
//

import Foundation
import ObjectiveC

var associated_object_handle_linkim_timer_name: String = "linkim.NSTimer.name"

extension Timer
{
    var timeName: String? {
        get {
            return objc_getAssociatedObject(self, &associated_object_handle_linkim_timer_name) as? String
        }
        set {
            objc_setAssociatedObject(self, &associated_object_handle_linkim_timer_name, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    /**
    暂停默认Timer
     */
    func pauseTimer()
    {
        if self.isValid {
           self.fireDate = Date.distantFuture
        }
    }
    
    /**
    开始Timer
     */
    func resumeTimer()
    {
        if self.isValid {
           self.fireDate = Date()
        }
    }
    

}
