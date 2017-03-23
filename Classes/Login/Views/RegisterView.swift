//
//  RegisterView.swift
//  BingLiYun
//
//  Created by 刘伟 on 10/01/2017.
//  Copyright © 2017 上海凌晋信息技术有限公司. All rights reserved.
//

import UIKit

class RegisterView: BaseView {

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
    
    let nameTextField: UITextField = {
        let nameTextField = UITextField()
        nameTextField.borderStyle = .none
        nameTextField.font = UIFont.systemFont(ofSize: 16)
        return nameTextField;
    }()
    
    let phoneTextField: PhoneTextField = {
        let phoneTextField = PhoneTextField()
        phoneTextField.borderStyle = .none
        phoneTextField.font = UIFont.systemFont(ofSize: 16)
        return phoneTextField;
    }()
    
    let passwordTextField: PasswordTextField = {
        let passwordTextField = PasswordTextField()
        passwordTextField.borderStyle = .none
        passwordTextField.font = UIFont.systemFont(ofSize: 16)
        return passwordTextField;
    }()
    
    let rePasswordTextField: PasswordTextField = {
        let rePasswordTextField = PasswordTextField()
        rePasswordTextField.borderStyle = .none
        rePasswordTextField.font = UIFont.systemFont(ofSize: 16)
        return rePasswordTextField;
    }()
    
    let captchaTextField: SMSCaptchaTextField = {
        let captchaTextField = SMSCaptchaTextField()
        captchaTextField.borderStyle = .none
        captchaTextField.font = UIFont.systemFont(ofSize: 16)
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
    
    let submitButton: UIButton = {
        let submitButton = UIButton.blueButton()
        submitButton.setTitle("提交", for: .normal)
        submitButton.layer.masksToBounds = true
        submitButton.layer.cornerRadius = 4
        return submitButton
    }()
    
    override func settingLayout() {
        
        backgroundColor = COLOR_BACKGROUND_LIGHT_GRAY
        
        addSubview(scrollView)
        scrollView.snp.makeConstraints { (make) in
            make.edges.equalTo(self)
        }
        
        scrollView.addSubview(contentView)
        contentView.snp.makeConstraints { (make) in
            make.edges.equalTo(scrollView)
            make.width.equalTo(scrollView.snp.width)
        }
        
        let viewHeight:CGFloat = 44
        
        let topView = UIView()
        topView.backgroundColor = UIColor.white
        contentView.addSubview(topView)
        topView.snp.makeConstraints { (make) in
            make.left.right.equalTo(contentView)
            make.top.equalTo(contentView).offset(10)
            make.height.greaterThanOrEqualTo(0)
        }
        
        //        topView.addSubview(phoneLab)
        //        phoneLab.snp.makeConstraints { (make) in
        //            make.left.equalTo(topView).offset(20)
        //            make.top.equalTo(topView)
        //            make.height.equalTo(viewHeight)
        //            make.width.equalTo(80)
        //        }
        
        topView.addSubview(nameTextField)
        nameTextField.snp.makeConstraints { (make) in
            make.left.equalTo(topView).offset(20)
            make.right.equalTo(topView).offset(-20)
            make.top.equalTo(topView)
            make.height.equalTo(viewHeight)
        }
        
        topView.addSubview(phoneTextField)
        phoneTextField.snp.makeConstraints { (make) in
            make.left.equalTo(topView).offset(20)
            make.right.equalTo(topView).offset(-20)
            make.top.equalTo(nameTextField.snp.bottom)
            make.height.equalTo(viewHeight)
        }
        
        //        topView.addSubview(passwordLab)
        //        passwordLab.snp.makeConstraints { (make) in
        //            make.left.equalTo(phoneLab)
        //            make.top.equalTo(phoneLab.snp.bottom)
        //            make.width.height.equalTo(phoneLab)
        //        }
        
        topView.addSubview(passwordTextField)
        passwordTextField.snp.makeConstraints { (make) in
            make.top.equalTo(phoneTextField.snp.bottom)
            make.left.equalTo(phoneTextField)
            make.width.height.equalTo(phoneTextField)
        }
        
        topView.addSubview(rePasswordTextField)
        rePasswordTextField.snp.makeConstraints { (make) in
            make.top.equalTo(passwordTextField.snp.bottom)
            make.left.equalTo(phoneTextField)
            make.width.height.equalTo(phoneTextField)
        }
        
        //        topView.addSubview(captchaLab)
        //        captchaLab.snp.makeConstraints { (make) in
        //            make.left.equalTo(phoneLab)
        //            make.top.equalTo(passwordLab.snp.bottom)
        //            make.width.height.equalTo(phoneLab)
        //        }
        
        topView.addSubview(captchaTextField)
        captchaTextField.snp.makeConstraints { (make) in
            make.top.equalTo(rePasswordTextField.snp.bottom)
            make.left.equalTo(phoneTextField)
            make.width.height.equalTo(phoneTextField)
        }
        
        topView.addSubview(obtainButton)
        obtainButton.snp.makeConstraints { (make) in
            make.right.equalTo(captchaTextField)
            make.centerY.equalTo(captchaTextField)
            make.height.equalTo(captchaTextField.snp.height).multipliedBy(0.8)
            make.width.equalTo(74)
        }
        
        let line1 = UIView.lightGrayLineView()
        topView.addSubview(line1)
        line1.snp.makeConstraints { (make) in
            make.left.equalTo(passwordTextField)
            make.right.equalTo(topView)
            make.height.equalTo(1)
            make.top.equalTo(passwordTextField.snp.top)
        }
        
        let line2 = UIView.lightGrayLineView()
        topView.addSubview(line2)
        line2.snp.makeConstraints { (make) in
            make.left.equalTo(captchaTextField)
            make.right.equalTo(topView)
            make.height.equalTo(1)
            make.top.equalTo(captchaTextField.snp.top)
        }
        
        topView.snp.makeConstraints { (make) in
            make.bottom.equalTo(captchaTextField.snp.bottom)
        }
        
        contentView.addSubview(submitButton)
        submitButton.snp.makeConstraints { (make) in
            make.left.equalTo(self).offset(30)
            make.right.equalTo(self).offset(-20)
            make.top.equalTo(topView.snp.bottom).offset(20)
            make.height.equalTo(44)
        }
        
        contentView.snp.makeConstraints { (make) in
            make.bottom.equalTo(submitButton.snp.bottom)
        }
    }

}
