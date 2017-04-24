//
//  TextViewViewController.swift
//  BaseSwiftProject
//
//  Created by 刘伟 on 2017/4/21.
//  Copyright © 2017年 上海凌晋信息技术有限公司. All rights reserved.
//

import UIKit

protocol TextViewViewControllerDelegate {
    func onInputCompleted(_ elementId:String, _ elementOriginValue:String,  _ newValue: String);
}

class TextViewViewController: BaseViewController {

    var elementId: String?
    var elementOriginVal: String?
    
    let textView : UITextView = {
        let tv = UITextView()
        return tv;
    }()
    
    var delegate: TextViewViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setNavigationItem(withLeftObject: nil, rightObject: "保存", titleObject: "输入")
        
        textView.text = SAFE_STRING(elementOriginVal)
        view.addSubview(textView)
        textView.snp.makeConstraints { (make) in
            make.left.top.right.equalTo(view)
            make.height.equalTo(200)
        }
    }

    override func rightTopAction(_ sender: Any) {
        delegate?.onInputCompleted(SAFE_STRING(elementId), SAFE_STRING(elementOriginVal), SAFE_STRING(textView.text))
        self.dismiss(animated: true, completion: nil)
    }
}
