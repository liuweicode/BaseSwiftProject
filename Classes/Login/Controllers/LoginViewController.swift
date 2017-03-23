//
//  LoginViewController.swift
//  Dancing
//
//  Created by 刘伟 on 27/10/2016.
//  Copyright © 2016 上海凌晋信息技术有限公司. All rights reserved.
//

import UIKit
import SnapKit
import JZNavigationExtension

class LoginViewController: BaseViewController {
    
    var isPresent = false
    
    fileprivate var time_value = 60
    
    lazy var rootView = LoginView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.jz_isNavigationBarBackgroundHidden = false
        self.jz_navigationBarBackgroundAlpha = ShowBarBackgroundAlpha
        
        if isPresent
        {
            self.setNavigationItem(withLeftObject: "取消", rightObject: nil, titleObject: "登录")
        }else{
            self.setNavigationItem(withLeftObject: nil, rightObject: nil, titleObject: "登录")
        }
        
        view.addSubview(rootView)
        rootView.snp.makeConstraints( { (make) in
            make.edges.equalTo(self.view)
        })
        
        rootView.obtainButton.addTarget(self, action: #selector(onSendVerificationCodeButtonClick(_:)), for: .touchUpInside)
        rootView.loginButton.addTarget(self, action: #selector(onLoginButtonClick(_:)), for: .touchUpInside)
        
        // 检测版本更新
        //APPVersionManager.sharedInstance.checkAppHasNewVersion()
    }
    
    override func leftTopAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    // 发送验证码
    func onSendVerificationCodeButtonClick(_ button:UIButton)
    {
        self.doSendVerificationCodeRequest()
    }
    
    // 登录点击事件
    func onLoginButtonClick(_ button:UIButton)
    {
        self.doLoginRequest()
    }
}

extension LoginViewController
{
    // 发送验证码
    func doSendVerificationCodeRequest()
    {
        let phone = rootView.phoneTextField.text ?? ""
        if String.trim(phone).length == 0
        {
            ToastView.showError("手机号不能为空")
            return
        }
        
        let finalPhone = phone.replacingOccurrences(of: " ", with: "")
        if !String.isMobile(sourceS: finalPhone)
        {
            ToastView.showError("手机号格式不正确")
            return
        }
        
        rootView.phoneTextField.resignFirstResponder()
        rootView.captchaTextField.resignFirstResponder()
        
        ToastView.showProgressLoading()
        
        let param: [String: Any] = [
            "phone":finalPhone,
            "action":"1"
        ];
        
        _ = NC_POST(self).send(params: param, url: API(service: API_SMS_SENDSMSCODE), successBlock: {[weak self] (message) in
            
            ToastView.hide()
            
            guard let strongSelf = self else{ return }
            
            _ = strongSelf.timer(selector: #selector(strongSelf.handerTimer(_:)), timeInterval: 1, repeats: true, name: nil)
            
            let ok = AlertViewButtonItem(inLabel: "确定")
            
            let action_msg = message.responseJson["data"]["responsedata"]["action_msg"].string ?? DLocalizedString("操作成功")
            
            let alertView = AlertView(title: nil, message: action_msg, cancelButtonItem: ok, otherButtonItems: nil)
            alertView.show()
            
        }) { (message) in
            ToastView.showError(message.networkError!)
        }
    }

    func handerTimer(_ timer:Timer)
    {
        if time_value == 0
        {
            self.cancelAllTimers()
            time_value = 60
            rootView.obtainButton.isEnabled = true
            rootView.obtainButton.setTitle("发送", for: .normal)
        }else{
            time_value -= 1
            rootView.obtainButton.isEnabled = false
            rootView.obtainButton.setTitle("\(time_value)s", for: .normal)
        }
    }
    
    func checkParamsValid() -> Bool
    {
        var errorMsg: String? = nil
        
        while true {
            
            let phone = rootView.phoneTextField.text
            if String.isBlankOrNil(sourceS: phone)
            {
                errorMsg = "手机号不能为空"
                break
            }
            
            let finalPhone = phone!.replacingOccurrences(of: " ", with: "")
            if !String.isMobile(sourceS: finalPhone)
            {
                errorMsg = "手机号格式不正确"
                break
            }
            
            let captcha = rootView.captchaTextField.text
            if String.isBlankOrNil(sourceS: captcha)
            {
                errorMsg = "验证码不能为空"
                break
            }
            
            break
        }
        
        if errorMsg == nil
        {
            return true
        }else{
            ToastView.showError(errorMsg!)
            return false
        }
    }
    
    func doLoginRequest()
    {
        if !self.checkParamsValid()
        {
            return
        }
        
        rootView.phoneTextField.resignFirstResponder()
        
        ToastView.showProgressLoading()
        
        let phone = rootView.phoneTextField.text!.replacingOccurrences(of: " ", with: "")
        let captcha = rootView.captchaTextField.text
        
        let param: [String : Any] = [
            "phone": phone,
            "code": SAFE_STRING(captcha)
        ];
        
        _ = NC_POST(self).send(params: param, url: API(service: API_USER_SIGN), successBlock: { (message) in
            
            ToastView.hide()
            
            // 保存用户信息
            let appUser = AppUser(json: message.responseJson["data"]["responsedata"]["user_info"])
            UserCenter.saveUser(appUser)
            
            if self.isPresent
            {
                self.dismiss(animated: true, completion: nil)
                self.postNotification(NK_LOGIN_SUCCESS)
            }else{
                APPCONTROLLER.setMain()
            }

        }) { (message) in
            ToastView.showErrorMessage(message.networkError!)
        }
    }
}
