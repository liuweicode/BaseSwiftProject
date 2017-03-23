//
//  BaseTextField.swift
//  LinkimFoundation
//
//  Created by 刘伟 on 16/7/8.
//  Copyright © 2016年 CocoaPods. All rights reserved.
//

import UIKit

protocol BaseTextFieldDelegate {
    func initTextData()
}

class BaseTextField: UITextField {
    

    var delegateInterceptor: NSProtocolInterceptor?
    
    init()
    {
        super.init(frame: CGRect.zero)
        self.initMessageInterceptor()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initMessageInterceptor()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.initMessageInterceptor()
    }
    
    func initMessageInterceptor()
    {
        assert(self is BaseTextFieldDelegate, "必须在子类实现BaseTextFieldDelegate协议 %s:%d",file: #function, line: #line)
        delegateInterceptor = NSProtocolInterceptor.forProtocol(UITextFieldDelegate.self)
        delegateInterceptor!.middleMan = self
        delegateInterceptor!.receiver = self.delegate
        super.delegate = delegateInterceptor as? UITextFieldDelegate
        
        (self as! BaseTextFieldDelegate).initTextData()
    }
    
    deinit{
        self.delegate = nil
    }
    
    override var delegate: UITextFieldDelegate? {
        get {
            return delegateInterceptor?.receiver as? UITextFieldDelegate
        }
        set {
            if let _ = delegateInterceptor {
                super.delegate = nil
                delegateInterceptor?.receiver = newValue
                super.delegate = delegateInterceptor as? UITextFieldDelegate
            }else{
                super.delegate = newValue
            }
        }
    }
    
}
