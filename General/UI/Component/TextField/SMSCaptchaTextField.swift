//
//  SMSCaptchaTextField.swift
//  LinkimFoundation
//
//  Created by 刘伟 on 16/7/11.
//  Copyright © 2016年 CocoaPods. All rights reserved.
//

import UIKit

let kCaptchaLen = 6 // 验证码长度

class SMSCaptchaTextField: BaseTextField,UITextFieldDelegate,BaseTextFieldDelegate {

//    var obtainButton:UIButton = {
//        let obtainButton = UIButton(type: .custom)
//        obtainButton.setTitle("获取验证码", for: .normal)
//        obtainButton.setTitleColor(UIColor.black, for: .normal)
//        obtainButton.setTitleColor(UIColor.lightGray, for: .disabled)
//        return obtainButton
//    }()
    
    func initTextData() {
        self.placeholder = "请输入短信验证码"
        self.keyboardType = .numberPad
        self.font = UIFont.systemFont(ofSize: 16)
        self.clearButtonMode = .whileEditing
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        _ = self.delegate?.textField!(textField, shouldChangeCharactersIn: range, replacementString: string)
        
        let newString = (textField.text! as NSString).replacingCharacters(in: range, with: string)
        
        return newString.length <= kCaptchaLen
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.delegate?.textFieldDidEndEditing?(textField)
    }

}
