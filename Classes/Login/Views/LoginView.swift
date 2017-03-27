//
//  LoginView.swift
//  Dancing
//
//  Created by 刘伟 on 28/10/2016.
//  Copyright © 2016 上海凌晋信息技术有限公司. All rights reserved.
//

import UIKit
import SnapKit

class LoginView: BaseView {
    
    let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.alwaysBounceVertical = true
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }()
    
    let contentView: UIView = {
        let contentView = UIView()
        return contentView
    }()
    
    let logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "launch_logo")
        return imageView
    }()
    
    let phoneTextField: PhoneTextField = {
        let phoneTextField = PhoneTextField()
        phoneTextField.borderStyle = .none
        phoneTextField.font = UIFont.systemFont(ofSize: 16)
        phoneTextField.placeholder = "请输入手机号"
        return phoneTextField;
    }()
    
    let captchaTextField: SMSCaptchaTextField = {
        let captchaTextField = SMSCaptchaTextField()
        captchaTextField.borderStyle = .none
        captchaTextField.font = UIFont.systemFont(ofSize: 16)
        captchaTextField.placeholder = "请输入验证码"
        return captchaTextField;
    }()
    
    var obtainButton:UIButton = {
        let obtainButton = UIButton.blueButton()
        obtainButton.titleLabel?.font = DFont(13)
        obtainButton.setTitle("发送", for: .normal)
        obtainButton.layer.masksToBounds = true
        obtainButton.layer.cornerRadius = 4
        return obtainButton
    }()
    
    let loginButton: UIButton = {
        let loginButton = UIButton.blueButton()
        loginButton.setTitle("登录", for: .normal)
        loginButton.layer.masksToBounds = true
        loginButton.layer.cornerRadius = 4
        return loginButton
    }()
    
    let uploadButton: UIButton = {
        let uploadButton = UIButton.blueButton()
        uploadButton.setTitle("上传", for: .normal)
        uploadButton.layer.masksToBounds = true
        uploadButton.layer.cornerRadius = 4
        return uploadButton
    }()
    
    override func settingLayout() {
        
        addSubview(scrollView)
        scrollView.snp.makeConstraints { (make) in
            make.edges.equalTo(self)
        }
        
        scrollView.addSubview(contentView)
        contentView.snp.makeConstraints { (make) in
            make.edges.equalTo(scrollView)
            make.width.equalTo(scrollView.snp.width)
        }
        
        contentView.addSubview(logoImageView)
        logoImageView.snp.makeConstraints { (make) in
            make.centerX.equalTo(contentView)
            make.top.equalTo(40)
            make.width.height.greaterThanOrEqualTo(0)
        }
        
        let viewHeight:CGFloat = 44
        
        contentView.addSubview(phoneTextField)
        phoneTextField.snp.makeConstraints { (make) in
            make.left.equalTo(contentView).offset(20)
            make.right.equalTo(contentView).offset(-20)
            make.top.equalTo(logoImageView.snp.bottom).offset(50)
            make.height.equalTo(viewHeight)
        }
        
        contentView.addSubview(captchaTextField)
        captchaTextField.snp.makeConstraints { (make) in
            make.top.equalTo(phoneTextField.snp.bottom)
            make.left.equalTo(phoneTextField.snp.left)
            make.width.equalTo(phoneTextField)
            make.height.equalTo(phoneTextField)
        }
        
        contentView.addSubview(obtainButton)
        obtainButton.snp.makeConstraints { (make) in
            make.right.equalTo(captchaTextField)
            make.centerY.equalTo(captchaTextField)
            make.height.equalTo(captchaTextField.snp.height).multipliedBy(0.8)
            make.width.equalTo(74)
        }
        
        let line1 = UIView.lightGrayLineView()
        contentView.addSubview(line1)
        line1.snp.makeConstraints { (make) in
            make.left.equalTo(self)
            make.right.equalTo(self)
            make.height.equalTo(1)
            make.top.equalTo(phoneTextField.snp.top)
        }
        
        let line2 = UIView.lightGrayLineView()
        contentView.addSubview(line2)
        line2.snp.makeConstraints { (make) in
            make.left.equalTo(self)
            make.right.equalTo(self)
            make.height.equalTo(1)
            make.top.equalTo(captchaTextField.snp.top)
        }
        
        let line3 = UIView.lightGrayLineView()
        contentView.addSubview(line3)
        line3.snp.makeConstraints { (make) in
            make.left.equalTo(self)
            make.right.equalTo(self)
            make.height.equalTo(1)
            make.top.equalTo(captchaTextField.snp.bottom)
        }
        
        contentView.addSubview(loginButton)
        loginButton.snp.makeConstraints( { (make) in
            make.top.equalTo(line3.snp.bottom).offset(40)
            make.left.equalTo(contentView).offset(20)
            make.right.equalTo(contentView).offset(-20)
            make.height.equalTo(44)
        })
        
        contentView.addSubview(uploadButton)
        uploadButton.snp.makeConstraints { (make) in
            make.left.right.height.equalTo(loginButton)
            make.top.equalTo(loginButton.snp.bottom).offset(20)
        }
        
        contentView.snp.makeConstraints { (make) in
            make.bottom.equalTo(uploadButton.snp.bottom)
        }
    }
    

}
