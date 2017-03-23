//
//  PlaceholderTextView.swift
//  LinkimFoundation
//
//  Created by 刘伟 on 16/7/11.
//  Copyright © 2016年 CocoaPods. All rights reserved.
//

import UIKit

class PlaceholderTextView: UITextView {

    fileprivate var _placeholder:String?
    
    fileprivate var _placeholderColor:UIColor?
    
    var placeholderLabel:UILabel = {
        let placeholderLabel = UILabel()
        return placeholderLabel
    }()
    
    var placeholder:String?{
        get{
            return self._placeholder
        }
        set{
            self._placeholder = newValue
            self.setNeedsDisplay()
        }
    }

    var placeholderColor:UIColor{
        get{
            return self._placeholderColor ?? UIColor.lightGray
        }
        set{
            self._placeholderColor = newValue
            self.setNeedsDisplay()
        }
    }
    
    override var font: UIFont?{
        get{
            return super.font
        }
        set{
            super.font = newValue
            self.setNeedsDisplay()
        }
    }
    
    override var text: String!{
        get{
            return super.text
        }
        set{
            super.text = newValue
            self.setNeedsDisplay()
        }
    }
    
    init()
    {
        super.init(frame: CGRect.zero, textContainer:nil)
        self.setup()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setup()
    {
        self.placeholderColor = UIColor.lightGray
        self.addSubview(self.placeholderLabel)
        self.placeholderLabel.isHidden = true
        
        self.registerNotification(name: NSNotification.Name.UITextViewTextDidChange.rawValue, selector: #selector(textViewTextDidChange(_:)))
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.setNeedsDisplay()
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        if let placeholder = self.placeholder , self.text.length == 0{
            if self.font == nil{
                self.font = UIFont.systemFont(ofSize: 12)
            }
            let attrString = NSAttributedString(string: placeholder, attributes: [NSForegroundColorAttributeName:self.placeholderColor, NSFontAttributeName:self.font!])
            self.placeholderLabel.attributedText = attrString
            self.placeholderLabel.sizeToFit()
            let placeholderRect = self.placeholderLabel.frame
            self.placeholderLabel.frame = CGRect(x: 4, y: 8, width: placeholderRect.size.width, height: placeholderRect.size.height)
            self.placeholderLabel.isHidden = false
        }else{
            self.placeholderLabel.isHidden = true
        }
    }
    
    deinit{
        self.unRegisterAllNotification()
    }
    
    func textViewTextDidChange(_ note:Notification)
    {
        self.setNeedsDisplay()
    }
    
}
