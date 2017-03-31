//
//  ToastView.swift
//  LinkimFoundation
//
//  Created by 刘伟 on 16/7/8.
//  Copyright © 2016年 CocoaPods. All rights reserved.
//

import UIKit
//import PKHUD
import SVProgressHUD

/// 自行扩展
class ToastView: NSObject {
    
    class func initialization()
    {
        SVProgressHUD.setDefaultStyle(.dark)
        SVProgressHUD.setDefaultMaskType(.clear)
    }
    
    class func showInfo(_ message:String?)
    {
        DispatchQueue.main.async {
            SVProgressHUD.showInfo(withStatus: message)
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2.0) {
                SVProgressHUD.dismiss()
            }
        }
    }
    
    class func showSuccess(_ message:String?)
    {
        DispatchQueue.main.async {
            SVProgressHUD.showSuccess(withStatus: message)
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2.0) {
                SVProgressHUD.dismiss()
            }
        }
    }
    
    class func showError(_ message:String?)
    {
        DispatchQueue.main.async {
            SVProgressHUD.showError(withStatus: message)
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2.0) {
                SVProgressHUD.dismiss()
            }
        }
    }
    
    class func showProgressLoading()
    {
        DispatchQueue.main.async {
            SVProgressHUD.show()
        }
    }
    
    class func showSuccess()
    {
        SVProgressHUD.showSuccess(withStatus: "success")
    }
    
    class func hide()
    {
        DispatchQueue.main.async {
            SVProgressHUD.dismiss()
        }
    }
    
    // 显示登录
    class func showLogin()
    {
        DispatchQueue.main.async {
            SVProgressHUD.showError(withStatus: "请重新登录")
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2.0) {
                SVProgressHUD.dismiss()
                APPCONTROLLER.setupLogo()
            }
        }
    }
    
    class func showError(_ backendError: BackendError?)
    {
        guard let error = backendError else {
            return
        }
        DispatchQueue.main.async {
            
            switch error
            {
            case .network(error: let err):
                SVProgressHUD.showError(withStatus: "网络错误:(\(SAFE_STRING(err?.localizedDescription)))")
            case .operationError(code: let code, reason: let reason):
                SVProgressHUD.showError(withStatus: "code:\(code)\nreason:\(reason)")
            }
            
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2.0) {
                SVProgressHUD.dismiss()
            }
        }
    }
}
