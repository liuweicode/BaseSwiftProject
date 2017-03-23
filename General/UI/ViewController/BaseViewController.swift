//
//  BaseViewController.swift
//  DaQu
//
//  Created by 刘伟 on 8/26/16.
//  Copyright © 2016 上海凌晋信息技术有限公司. All rights reserved.
//

import UIKit
import JZNavigationExtension

fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}

let ShowBarBackgroundAlpha:CGFloat = 1.0

let HiddenBarBackgroundAlpha: CGFloat = 0.0

class BaseViewController: UIViewController {
    
    // 是否可以全屏滑动返回
    var isFullScreenInteractivePopGestureEnabled: Bool {
        get {
            return true
        }
    }
    
    // 是否支持边缘侧滑返回
    var isInteractivePopGestureRecognizerEnabled: Bool {
        get {
            return true
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ANT_LOG_EVENT(event: "viewDidLoad", label: "\(type(of: self))")
        
        view.backgroundColor = COLOR_WHITE;
        
        // 默认显示导航
        self.jz_isNavigationBarBackgroundHidden = false
        self.jz_navigationBarTintColor = NAVIGATION_COLOR
        self.jz_navigationBarBackgroundAlpha = ShowBarBackgroundAlpha
        
        UIApplication.shared.isStatusBarHidden = false
        UIApplication.shared.statusBarStyle = .lightContent
        
        if(self.navigationController?.viewControllers.count > 1)
        {
            self.setNavigationBack(withTitle: "")
        }
        
        if let navigation = self.navigationController
        {
            navigation.jz_fullScreenInteractivePopGestureEnabled = self.isFullScreenInteractivePopGestureEnabled
            navigation.interactivePopGestureRecognizer?.isEnabled = self.isInteractivePopGestureRecognizerEnabled
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        ANT_LOG_EVENT(event: "viewWillAppear", label: "\(type(of: self))")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        ANT_LOG_EVENT(event: "viewDidAppear", label: "\(type(of: self))")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        ANT_LOG_EVENT(event: "viewWillDisappear", label: "\(type(of: self))")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        ANT_LOG_EVENT(event: "viewDidDisappear", label: "\(type(of: self))")
    }

    deinit {
        self.unRegisterAllNotification()
    }
}
