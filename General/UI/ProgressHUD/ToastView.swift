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
    
    class func showError(_ networkError: NetworkErrorType?)
    {
        guard let error = networkError else {
            return
        }
        DispatchQueue.main.async {
            switch error
            {
            case .httpError(let code, _):
                SVProgressHUD.showError(withStatus: "网络错误:(\(code))")
            case .serverError(let ret, let msg):
                
            
                switch ret
                {
                    // 操作成功
                    case .operation_success:
                        print("Nothing ^_^")
                    // 其他
                    case .other:
                        ToastView.showError(msg)
                    // 请求非法
                    case .request_invalid:
                        //APPCONTROLLER.setupLogo()
                        ToastView.showError(msg)
                    // 未签名
                    case .unsigned:
                        APPCONTROLLER.setupLogo()
                    // 签名错误
                    case .signature_error:
                        APPCONTROLLER.setupLogo()
                    // 未登录
                    case .not_logged_in:
                        APPCONTROLLER.setupLogo()
                    // 账号已被禁用
                    case .id_forbidden:
                        APPCONTROLLER.setupLogo()
                    // 表示登录过期
                    case .login_state_expired:
                        APPCONTROLLER.setupLogo()
                    // 表示已在其他设备授权 请重新授权
                    case .logged_in_on_another_device:
                        DispatchQueue.main.async {
                            SVProgressHUD.showError(withStatus: "已在其他设备授权，请重新授权")
                            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2.0) {
                                SVProgressHUD.dismiss()
                                APPCONTROLLER.setupLogo()
                            }
                        }
                    case .encryption_key_invalid:
                        APPCONTROLLER.setupLogo()
                }
                
            case .decryptDataError(let msg):
                
                SVProgressHUD.showError(withStatus:msg)
                
            case .responseDataError(let msg):
                
                SVProgressHUD.showError(withStatus:msg)
                
            case .operationError(let code, let msg):
                
                SVProgressHUD.showError(withStatus:"\(code)\n\(msg)")
            }
            
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2.0) {
                SVProgressHUD.dismiss()
            }
        }
    }
    
    class func showErrorMessage(_ networkError: NetworkErrorType?)
    {
        guard let error = networkError else {
            return
        }
        DispatchQueue.main.async {
            switch error
            {
            case .httpError(let code, _):
                SVProgressHUD.showError(withStatus: "网络错误:(\(code))")
            case .serverError( _, let msg):
                SVProgressHUD.showError(withStatus:msg)
            case .decryptDataError(let msg):
                SVProgressHUD.showError(withStatus:msg)
            case .responseDataError(let msg):
                SVProgressHUD.showError(withStatus:msg)
            case .operationError(let code, let msg):
                SVProgressHUD.showError(withStatus:"\(code)\n\(msg)")
            }
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2.0) {
                SVProgressHUD.dismiss()
            }
        }
    }
}
