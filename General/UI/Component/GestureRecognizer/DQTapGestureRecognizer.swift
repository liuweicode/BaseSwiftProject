//
//  DQTapGestureRecognizer.swift
//  DaQu
//
//  Created by 刘伟 on 9/9/16.
//  Copyright © 2016 上海凌晋信息技术有限公司. All rights reserved.
//

import UIKit

///Make sure you use  "[weak self] (gesture) in" if you are using the keyword self inside the closure or there might be a memory leak
class DQTapGestureRecognizer: UITapGestureRecognizer {
    
    var data: Any?
    
    fileprivate var tapAction: ((DQTapGestureRecognizer) -> Void)?
    
    override init(target: Any?, action: Selector?) {
        super.init(target: target, action: action)
    }
    
    convenience init (
        tapCount: Int = 1,
        fingerCount: Int = 1,
        action: ((DQTapGestureRecognizer) -> Void)?) {
        self.init()
        self.numberOfTapsRequired = tapCount
        self.numberOfTouchesRequired = fingerCount
        
        self.tapAction = action
        self.addTarget(self, action: #selector(DQTapGestureRecognizer.didTap(_:)))
    }
    
    func didTap (_ tap: DQTapGestureRecognizer) {
        tapAction?(tap)
    }
}

class DQLongPressGestureRecognizer: UILongPressGestureRecognizer {
    
    var data: Any?
    
    fileprivate var tapAction: ((DQLongPressGestureRecognizer) -> Void)?
    
    override init(target: Any?, action: Selector?) {
        super.init(target: target, action: action)
    }
    
    convenience init (
        action: ((DQLongPressGestureRecognizer) -> Void)?) {
        self.init()
        self.minimumPressDuration = 1
        
        self.tapAction = action
        self.addTarget(self, action: #selector(DQLongPressGestureRecognizer.didTap(_:)))
    }
    
    func didTap (_ tap: DQLongPressGestureRecognizer) {
        tapAction?(tap)
    }
}

extension UIView {
    
    func addClickGesture(_ target: Any, action: Selector, data:AnyObject?) {
        let tap = DQTapGestureRecognizer (target: target, action: action)
        tap.data = data
        tap.numberOfTapsRequired = 1
        addGestureRecognizer(tap)
        isUserInteractionEnabled = true
    }
    
    func addClickGesture(_ data:Any?, action: ((DQTapGestureRecognizer)->())?) {
        let tap = DQTapGestureRecognizer(tapCount: 1, fingerCount: 1, action: action)
        tap.data = data
        addGestureRecognizer(tap)
        isUserInteractionEnabled = true
    }
    
    func addLongPressGesture(_ target: Any, action: Selector, data:AnyObject?)
    {
        let press = DQLongPressGestureRecognizer (target: target, action: action)
        press.data = data
        press.numberOfTapsRequired = 1
        addGestureRecognizer(press)
        isUserInteractionEnabled = true
    }
    
    func addLongPressGesture(_ data:Any?, action: ((DQLongPressGestureRecognizer)->())?) {
        let tap = DQLongPressGestureRecognizer(action: action)
        tap.data = data
        addGestureRecognizer(tap)
        isUserInteractionEnabled = true
    }
}
