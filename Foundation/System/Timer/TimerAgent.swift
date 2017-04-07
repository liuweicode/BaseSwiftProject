//
//  TimerAgent.swift
//  Pods
//
//  Created by 刘伟 on 16/6/30.
//
//

import UIKit

class TimerAgent: NSObject
{
    var timers: [Timer]!
    
    override init()
    {
        timers = [Timer]()
    }
    
    /**
     根据timer名称查找timer
     
     - parameter name: timer名称
     
     - returns: NSTimer
     */
    func timerForName(_ name:String?) -> Timer?
    {
        for timer in timers {
            if timer.timeName == name || (timer.timeName == nil && name == nil){
                return timer
            }
        }
        return nil
    }
    
    deinit
    {
        for timer in timers {
            if timer.isValid {
                timer.invalidate()
            }
        }
        timers.removeAll()
        timers = nil;
    }
}
