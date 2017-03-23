//
//  PhoneTextField.swift
//  LinkimFoundation
//
//  Created by 刘伟 on 16/7/8.
//  Copyright © 2016年 CocoaPods. All rights reserved.
//

import UIKit

let kPhoneNumLen = 11 //用户手机号长度限制

class PhoneTextField: BaseTextField,UITextFieldDelegate,BaseTextFieldDelegate {

    func initTextData() {
        self.placeholder = "请输入手机号"
        self.keyboardType = .numberPad
        self.font = UIFont.systemFont(ofSize: 16)
        self.clearButtonMode = .whileEditing
        self.translatesAutoresizingMaskIntoConstraints = false
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let newString = (textField.text! as NSString).replacingCharacters(in: range, with: string)
        let components = newString.components(separatedBy: CharacterSet.decimalDigits.inverted)
        
        var decimalString = components.joined(separator: "") as String
        
        let length = decimalString.length
        
        if length <= 3 {
            textField.text = decimalString
        }else if length > 3 && length <= 7 {
            decimalString.insert(" ", at: decimalString.characters.index(decimalString.startIndex, offsetBy: 3))
            textField.text = decimalString
        }else if length <= kPhoneNumLen {
            decimalString.insert(" ", at: decimalString.characters.index(decimalString.startIndex, offsetBy: 3))
            decimalString.insert(" ", at: decimalString.characters.index(decimalString.startIndex, offsetBy: 8))
            textField.text = decimalString
        }
        _ = self.delegate?.textField!(textField, shouldChangeCharactersIn: range, replacementString: string)
        return false
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.delegate?.textFieldDidEndEditing?(textField)
    }
}
