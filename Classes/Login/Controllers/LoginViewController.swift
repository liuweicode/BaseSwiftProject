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
        
        rootView.uploadButton.addTarget(self, action: #selector(onUploadButtonClick(_:)), for: .touchUpInside)
        
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
//        let cancel = ActionSheetButtonItem(inLabel: "取消"){
//            print("取消")
//        }
//        let confirm = ActionSheetButtonItem(inLabel: "确定") {
//            print("确定")
//        }
//        let alertView = ActionSheet(title: "标题", message: "消息", cancelButtonItem: cancel, otherButtonItems: confirm)
//        alertView.show()
//
        self.doLoginRequest()
    }
    
    // 登录点击事件
    func onUploadButtonClick(_ button:UIButton)
    {
        //self.doUploadRequest()
        
//        let ok = AlertViewButtonItem(inLabel: "确定")
//        
//        let alertView = AlertView(title: nil, message: "测试内容", cancelButtonItem: ok, otherButtonItems: nil)
//        alertView.show()
        
//        let s1 = OpenSSLUtil.sha1(from: "1")
//        let s2 = OpenSSLUtil.sha256(from: "1")
//        print("s1 = \(s1)")
//        print("s2 = \(s2)")
        
        
        //self.navigationController?.pushViewController(TestPhotoViewController(), animated: true)
    }
}

extension LoginViewController
{
    // 发送验证码
    func doSendVerificationCodeRequest()
    {
        
        let phone = rootView.phoneTextField.text ?? ""
        if phone.trim().length == 0
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
        
        _ = NC_POST(self).send(params: param, url: API(service: API_USER_SIGN, notEncrypt: true, isPrintSql: true), successBlock: { (message) in
            
            ToastView.showSuccess("登录成功")

        }) { (message) in
            ToastView.showError(message.networkError!)
        }
    }
    
    func imageHasAlpha(_ image:UIImage) -> Bool {
        let alpha = image.cgImage?.alphaInfo;
        return (alpha == CGImageAlphaInfo.first ||
            alpha == CGImageAlphaInfo.last ||
            alpha == CGImageAlphaInfo.premultipliedFirst ||
            alpha == CGImageAlphaInfo.premultipliedLast);
    }
    
    func doUploadRequest()
    {
        let image = UIImage(named: "test.jpg")!
        var imageData:Data!
        var mimeType:String? = nil
        if imageHasAlpha(image) {
            imageData = UIImagePNGRepresentation(image)
            mimeType = "png"
        }else{
            imageData = UIImageJPEGRepresentation(image, 0.5)
            mimeType = "jpeg"
        }
        _ = NC_POST(self).send(data: imageData, url: "\(API(service:API_FILE_UPLOAD))&extension=\(SAFE_STRING(mimeType))", successBlock: { (message) in
            let file_path = message.responseJson["data"]["responsedata"]["path"].string!
             ToastView.showSuccess("上传成功:\(file_path)")
        }, failBlock: { (message) in
            ToastView.showError(message.networkError!)
        })
    }
    
}
