//
//  PasswordTextField.swift
//  LinkimFoundation
//
//  Created by 刘伟 on 16/7/8.
//  Copyright © 2016年 CocoaPods. All rights reserved.
//

import UIKit

let kPasswordMaxLen = 20 // 密码最大长度限制

class PasswordTextField: BaseTextField,UITextFieldDelegate,BaseTextFieldDelegate {

    func initTextData() {
        self.placeholder = "请输入密码"
        self.keyboardType = .default
        self.font = UIFont.systemFont(ofSize: 16)
        self.isSecureTextEntry = true
        self.clearButtonMode = .whileEditing
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        _ = self.delegate?.textField!(textField, shouldChangeCharactersIn: range, replacementString: string)
        
        let newString = (textField.text! as NSString).replacingCharacters(in: range, with: string)
        
        return newString.length <= kPasswordMaxLen
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.delegate?.textFieldDidEndEditing?(textField)
    }

}
