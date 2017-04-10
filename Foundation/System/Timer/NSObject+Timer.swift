//
//  NSObject+Timer.swift
//  Pods
//
//  Created by 刘伟 on 16/6/30.
//
//

import Foundation


var associated_object_handle_linkim_timer_agent: String = "linkim.NSObject.timerAgent"

extension NSObject
{
    fileprivate func timerAgent() -> TimerAgent {
        var agent = objc_getAssociatedObject(self, &associated_object_handle_linkim_timer_agent) as? TimerAgent
        if agent == nil {
            agent = TimerAgent()
            objc_setAssociatedObject( self, &associated_object_handle_linkim_timer_agent, agent, .OBJC_ASSOCIATION_RETAIN_NONATOMIC );
        }
        return agent!
    }
    
    /**
     创建一个Timer并执行
     
     - parameter aSelector: Timer之行的方法
     - parameter ti:        时间间隔
     - parameter yesOrNo:   是否循环 默认不循环
     - parameter name:      Timer名称
     
     - returns: NSTimer
     */
    @discardableResult
    public func timer(selector aSelector: Selector, timeInterval ti: TimeInterval, repeats yesOrNo: Bool = false, name:String? = nil) -> Timer
    {
        let agent = self.timerAgent()
        var timer = agent .timerForName(name)
        
        if timer == nil {
            timer = Timer.scheduledTimer(timeInterval: ti, target: self, selector: aSelector, userInfo: nil, repeats: yesOrNo)
            timer!.timeName = name;
            agent.timers.append(timer!)
        }
        return timer!
    }
    
    func cancelTimer(_ name:String?)
    {
        let agent = self.timerAgent()
        if let timer = agent.timerForName(name)
        {
            if timer.isValid {
                timer .invalidate()
            }
            agent.timers.removeObject(timer)
        }
    }
    
    func cancelAllTimers()
    {
       let agent = self.timerAgent()
        for timer in agent.timers {
            if timer.isValid {
                timer .invalidate()
            }
        }
        agent.timers.removeAll()
    }
    
}
