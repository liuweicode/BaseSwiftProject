////
////  FindPasswordViewController.swift
////  BingLiYun
////
////  Created by 刘伟 on 17/11/2016.
////  Copyright © 2016 上海凌晋信息技术有限公司. All rights reserved.
////
//
//import UIKit
//
//class FindPasswordViewController: BaseViewController {
//
//    let rootView = FindPasswordView()
//    
//    fileprivate var time_value = 60
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        self.setNavigationItem(withLeftObject: nil, rightObject: nil, titleObject: "找回密码")
//        
//        view.addSubview(rootView)
//        rootView.snp.makeConstraints( { (make) in
//            make.edges.equalTo(self.view)
//        })
//    
//        rootView.obtainButton.addTarget(self, action: #selector(onSendVerificationCodeButtonClick(_:)), for: .touchUpInside)
//        rootView.submitButton.addTarget(self, action: #selector(onSubmitButtonClick(_:)), for: .touchUpInside)
//    }
//
//    func onSendVerificationCodeButtonClick(_ sender: UIButton)
//    {
//        self.doSendVerificationCodeRequest()
//    }
//    
//    func onSubmitButtonClick(_ sender: UIButton)
//    {
//        self.doFindPasswordBackRequest()
//    }
//}
//
//extension FindPasswordViewController
//{
//    func handerTimer(_ timer:Timer)
//    {
//        if time_value == 0
//        {
//            self.cancelAllTimers()
//            time_value = 60
//            rootView.obtainButton.isEnabled = true
//        }else{
//            time_value -= 1
//            rootView.obtainButton.isEnabled = false
//            rootView.obtainButton.setTitle("\(time_value)s", for: .normal)
//        }
//    }
//    
//    // 发送验证码
//    func doSendVerificationCodeRequest()
//    {
//        let phone = rootView.phoneTextField.text ?? ""
//        if String.trim(phone).length == 0
//        {
//            ToastView.showError("手机号不能为空")
//            return
//        }
//        
//        let finalPhone = phone.replacingOccurrences(of: " ", with: "")
//        if !String.isMobile(sourceS: finalPhone)
//        {
//            ToastView.showError("手机号格式不正确")
//            return
//        }
//        rootView.phoneTextField.resignFirstResponder()
//        rootView.passwordTextField.resignFirstResponder()
//        rootView.captchaTextField.resignFirstResponder()
//        
//        ToastView.showProgressLoading()
//        
//        let param: [String: Any] = [
//            "phone":finalPhone,
//            "action":"1"
//        ];
//        
//        _ = NC_POST(self).send(params: param, url: API(API_SMS_SENDSMSCODE), successBlock: {[weak self] (message) in
//            
//            ToastView.hide()
//            
//            guard let strongSelf = self else{ return }
//            
//            _ = strongSelf.timer(selector: #selector(strongSelf.handerTimer(_:)), timeInterval: 1, repeats: true, name: nil)
//            
//            let ok = AlertViewButtonItem(inLabel: "确定")
//            
//            let action_msg = message.responseJson["data"]["responsedata"]["action_msg"].string ?? "操作成功"
//            
//            let alertView = AlertView(title: nil, message: action_msg, cancelButtonItem: ok, otherButtonItems: nil)
//            alertView.show()
//
//        }) { (message) in
//            ToastView.showError(message.networkError!)
//        }
//    }
//    
//    func checkParamsValid() -> Bool
//    {
//        var errorMsg: String? = nil
//        
//        while true {
//            
//            let phone = rootView.phoneTextField.text
//            if String.isBlankOrNil(sourceS: phone)
//            {
//                errorMsg = "手机号不能为空"
//                break
//            }
//            
//            let finalPhone = phone!.replacingOccurrences(of: " ", with: "")
//            if !String.isMobile(sourceS: finalPhone)
//            {
//                errorMsg = "手机号格式不正确"
//                break
//            }
//            
//            let newPassword = rootView.passwordTextField.text
//            if !String.isValidPassword(sourceS: newPassword)
//            {
//                errorMsg = "新密码无效"
//                break
//            }
//            
//            let verificationCode = rootView.captchaTextField.text
//            if String.isBlankOrNil(sourceS: verificationCode)
//            {
//                errorMsg = "验证码不能为空"
//                break
//            }
//            
//            break
//        }
//        
//        if errorMsg == nil
//        {
//            return true
//        }else{
//            ToastView.showError(errorMsg!)
//            return false
//        }
//    }
//    
//    func doFindPasswordBackRequest()
//    {
//        if !self.checkParamsValid()
//        {
//            return
//        }
//        
//        rootView.phoneTextField.resignFirstResponder()
//        rootView.passwordTextField.resignFirstResponder()
//        rootView.captchaTextField.resignFirstResponder()
//        
//        ToastView.showProgressLoading()
//        
//        let phone = rootView.phoneTextField.text!.replacingOccurrences(of: " ", with: "")
//        let pwd = rootView.passwordTextField.text!
//        let verificationCode = rootView.captchaTextField.text!
//        
//        let param: [String : Any] = [
//            "phone":phone,
//            "newpwd":pwd,
//            "sms_code":verificationCode
//        ];
//        
//        _ = NC_POST(self).send(params: param, url: API(API_USER_RESETPWD), successBlock: {[weak self] (message) in
//            
//            ToastView.hide()
//            
//            guard let _ = self else{ return }
//            
//            let ok = AlertViewButtonItem(inLabel: "确定", inAction: {
//                APPCONTROLLER.popViewController()
//            })
//            
//            let action_msg = message.responseJson["data"]["responsedata"]["action_msg"].string ?? "操作成功"
//            
//            let alertView = AlertView(title: nil, message: action_msg, cancelButtonItem: ok, otherButtonItems: nil)
//            alertView.show()
//            
//        }) { (message) in
//            ToastView.showError(message.networkError!)
//        }
//    }
//
//}
