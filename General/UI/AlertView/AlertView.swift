//
//  AlertView.swift
//  LinkimFoundation
//
//  Created by 刘伟 on 16/7/6.
//  Copyright © 2016年 CocoaPods. All rights reserved.
//

import UIKit

class AlertViewButtonItem: NSObject {
    var label:String
    var action:(()->Void)?
    init(inLabel:String) {
        label = inLabel
    }
    init(inLabel:String,inAction:(()->Void)?) {
        label = inLabel
        action = inAction
    }
    
    class func cancelButton() -> AlertViewButtonItem
    {
        return AlertViewButtonItem(inLabel: "取消")
    }
    
    class func okButton(inAction:(()->Void)?) -> AlertViewButtonItem
    {
        return AlertViewButtonItem(inLabel: "确定", inAction: inAction)
    }
}

enum AlertViewStyle:Int {
    case normal,customer
}

typealias AlertViewButtonTouchUpInside = (_ alertView:AlertView, _ buttonIndex:Int) -> Void

let Alert_View_Corner_Radius:CGFloat = 7

class AlertView: UIView {

    var parentView:UIView?
    
    fileprivate var alertViewStyle:AlertViewStyle
    
    var didSetupConstraints = false
    
    var dialogView:UIView = {
        let dialogView = UIView()
        dialogView.backgroundColor = UIColor.white
        dialogView.layer.cornerRadius = Alert_View_Corner_Radius;
        dialogView.layer.masksToBounds = true
        dialogView.layer.borderColor = UIColor(red: 198.0/255.0, green: 198.0/255.0, blue: 198.0/255.0, alpha: 1.0).cgColor
        dialogView.layer.borderWidth = 0.65;
        dialogView.layer.shadowRadius = Alert_View_Corner_Radius + 5;
        dialogView.layer.shadowOpacity = 0.1;
        dialogView.layer.shadowOffset = CGSize(width: 0 - (Alert_View_Corner_Radius+5)/2, height: 0 - (Alert_View_Corner_Radius+5)/2);
        dialogView.layer.shadowColor = UIColor.black.cgColor;
        dialogView.layer.shadowPath = UIBezierPath(roundedRect: dialogView.bounds, cornerRadius: dialogView.layer.cornerRadius).cgPath
        return dialogView
    }()
    
    var containerView:UIView = {
        let containerView = UIView()
        containerView.backgroundColor = UIColor.white
        return containerView
    }()
    
    fileprivate var lineView:UIView = {
        let lineView = UIView()
        lineView.backgroundColor = UIColor(red: 198.0/255.0, green: 198.0/255.0, blue: 198.0/255.0, alpha: 1.0)
        return lineView
    }()
    
    var buttonContainerView:UIView = {
        let buttonContainerView = UIView()
        buttonContainerView.backgroundColor = UIColor(red: 198.0/255.0, green: 198.0/255.0, blue: 198.0/255.0, alpha: 1.0)
        return buttonContainerView
    }()
    
    lazy var titleLable:UILabel = {
        let titleLable = UILabel()
        titleLable.backgroundColor = UIColor.white
        titleLable.numberOfLines = 0
        titleLable.textAlignment = .center
        titleLable.font = UIFont.boldSystemFont(ofSize: 16)
        titleLable.textColor = UIColor(hex6: 0x858585)
        return titleLable
    }()
    
    lazy var messageLabel:UILabel = {
        let messageLabel = UILabel()
        messageLabel.backgroundColor = UIColor.white
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        messageLabel.font = UIFont.systemFont(ofSize: 15)
        messageLabel.textColor = UIColor(hex6: 0x858585)
        return messageLabel
    }()
    
    fileprivate var cancelButtonItem:AlertViewButtonItem?
    fileprivate var otherButtonItems:[AlertViewButtonItem]?
    
    var onButtonTouchUpInside:AlertViewButtonTouchUpInside?
    
    func setCancelButtonItem(_ cancelButtonItem:AlertViewButtonItem)
    {
        self.cancelButtonItem = cancelButtonItem
        buttonContainerView.subviews.enumerated().forEach { (index,view) in
            view.removeFromSuperview()
        }
        self.setButtons()
    }
    
    func setOtherButtonItems(_ otherButtonItems:AlertViewButtonItem...)
    {
        self.otherButtonItems = otherButtonItems
        buttonContainerView.subviews.enumerated().forEach { (index,view) in
            view.removeFromSuperview()
        }
        self.setButtons()
    }
    
    func setButtons()
    {
        var buttonsArray = otherButtonItems ?? [AlertViewButtonItem]()
        if let inCancelButtonItem = cancelButtonItem {
            buttonsArray.insert(inCancelButtonItem, at: 0)
        }
        for (index,value) in buttonsArray.enumerated() {
            let closeButton = UIButton(type: .custom)
            closeButton.tag = index
            closeButton.setTitle(value.label, for: .normal)
            closeButton.setTitleColor(UIColor(hex6: 0x858585), for: .normal)
            closeButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
            closeButton.layer.cornerRadius = Alert_View_Corner_Radius
            closeButton.setBackgroundImage(UIImage.imageWithColor(UIColor(hex6: 0x00f7f8f9)), for: .normal)
            closeButton.setBackgroundImage(UIImage.imageWithColor(UIColor(hex6: 0x00f7f8f9).alphaValue(0.8)), for: .highlighted)
            closeButton.addTarget(self, action: #selector(onButtonClick(_:)), for: .touchUpInside)
            buttonContainerView.addSubview(closeButton)
        }
    }
    
    init() {
        alertViewStyle = .customer
        super.init(frame: CGRect.zero)
        let screenBounds = UIScreen.main.bounds
        frame = CGRect(x: 0, y: 0, width: screenBounds.width, height: screenBounds.height)

        dialogView.addSubview(containerView)
        dialogView.addSubview(lineView)
        dialogView.addSubview(buttonContainerView)
        addSubview(dialogView)
        
        self.registerNotification(name: NSNotification.Name.UIKeyboardWillShow.rawValue, selector: #selector(keyboardWillShow(_:)))
        self.registerNotification(name: NSNotification.Name.UIKeyboardWillHide.rawValue, selector: #selector(keyboardWillHide(_:)))
    }
    
    convenience init(title inTitle:String?,message inMessage:String?,cancelButtonItem inCancelButtonItem:AlertViewButtonItem?,otherButtonItems inOtherButtonItems:AlertViewButtonItem...) {
        self.init()

        alertViewStyle = .normal
        cancelButtonItem = inCancelButtonItem
        otherButtonItems = inOtherButtonItems
        
        titleLable.text = inTitle
        messageLabel.text = inMessage
        
        containerView.addSubview(titleLable)
        containerView.addSubview(messageLabel)
        
        self.setButtons()
        
    }
    
    convenience init(title inTitle:String?,message inMessage:String?,cancelButtonItem inCancelButtonItem:AlertViewButtonItem?,otherButtonItems inOtherButtonItems:[AlertViewButtonItem]?) {
        self.init()
        
        alertViewStyle = .normal
        cancelButtonItem = inCancelButtonItem
        otherButtonItems = inOtherButtonItems
        
        titleLable.text = inTitle
        messageLabel.text = inMessage
        
        containerView.addSubview(titleLable)
        containerView.addSubview(messageLabel)
        
        self.setButtons()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func onButtonClick(_ sender:UIButton)
    {
        let tag = sender.tag
        if tag == 0 {
            if let inCancelButtonItem = cancelButtonItem {
                inCancelButtonItem.action?()
            }else{
                otherButtonItems![0].action?()
            }
        }else{
            if let _ = cancelButtonItem {
                otherButtonItems![tag-1].action?()
            }else{
                otherButtonItems![tag].action?()
            }
        }
       self.close()
    }
    
    fileprivate func updateNormalConstraint()
    {
        let screenSize = UIScreen.main.bounds
        let dialogViewWidth = screenSize.width * CGFloat(0.75)
        
        dialogView.snp.makeConstraints({ (make) in
            make.centerX.equalTo(self.snp.centerX)
            make.centerY.equalTo(self.snp.centerY).offset(-20)
            make.width.equalTo(dialogViewWidth)
            make.height.greaterThanOrEqualTo(0).priority(1)
        })
        
        containerView.snp.makeConstraints({ (make) in
            make.left.equalTo(dialogView.snp.left)
            make.top.equalTo(dialogView.snp.top)
            make.right.equalTo(dialogView.snp.right)
            make.height.greaterThanOrEqualTo(0).priority(1)
        })
        
        if titleLable.text == nil && messageLabel.text != nil
        {
            messageLabel.snp.makeConstraints( { (make) in
                make.top.equalTo(containerView.snp.top).offset(15)
                make.centerX.equalTo(containerView.snp.centerX)
                make.left.equalTo(containerView.snp.left).offset(10)
                make.right.equalTo(containerView.snp.right).offset(-10)
                make.height.greaterThanOrEqualTo(60)
            })
            
            containerView.snp.makeConstraints( { (make) in
                make.bottom.equalTo(messageLabel.snp.bottom).offset(10)
            })
        }
        else if titleLable.text != nil && messageLabel.text == nil
        {
            titleLable.snp.makeConstraints({ (make) in
                make.top.equalTo(containerView.snp.top).offset(15)
                make.centerX.equalTo(containerView.snp.centerX)
                make.left.equalTo(containerView.snp.left).offset(10)
                make.right.equalTo(containerView.snp.right).offset(-10)
                make.height.greaterThanOrEqualTo(60)
            })
            
            containerView.snp.makeConstraints( { (make) in
                make.bottom.equalTo(titleLable.snp.bottom).offset(10)
            })
        
        }
        else if titleLable.text != nil && messageLabel.text != nil
        {
            titleLable.snp.makeConstraints({ (make) in
                make.top.equalTo(containerView.snp.top).offset(15)
                make.centerX.equalTo(containerView.snp.centerX)
                make.left.equalTo(containerView.snp.left).offset(10)
                make.right.equalTo(containerView.snp.right).offset(-10)
                make.height.greaterThanOrEqualTo(0)
            })
            
            messageLabel.snp.makeConstraints( { (make) in
                make.top.equalTo(titleLable.snp.bottom).offset(10)
                make.centerX.equalTo(containerView.snp.centerX)
                make.left.equalTo(containerView.snp.left).offset(10)
                make.right.equalTo(containerView.snp.right).offset(-10)
                make.height.greaterThanOrEqualTo(30)
            })
            
            containerView.snp.makeConstraints( { (make) in
                make.bottom.equalTo(messageLabel.snp.bottom).offset(10)
            })
        }else{
            
        }
        
        lineView.snp.makeConstraints( { (make) in
            make.left.equalTo(dialogView.snp.left)
            make.top.equalTo(containerView.snp.bottom)
            make.right.equalTo(dialogView.snp.right)
            make.height.equalTo(1)
        })
        
        buttonContainerView.snp.makeConstraints( { (make) in
            make.left.equalTo(dialogView.snp.left)
            make.top.equalTo(lineView.snp.bottom)
            make.right.equalTo(dialogView.snp.right)
            make.height.equalTo(40)
        })
        
        buttonContainerView.subviews.enumerated().forEach({ (index,view) in
            let button = view as! UIButton
            button.snp.makeConstraints( { (make) in
                if index == 0 {
                    make.left.equalTo(buttonContainerView.snp.left)
                } else {
                    let previousButton = buttonContainerView.subviews[index - 1]
                    make.left.equalTo(previousButton.snp.right).offset(1)
                    if index == buttonContainerView.subviews.count - 1 {
                        make.right.equalTo(buttonContainerView.snp.right)
                    }
                }
                make.top.bottom.height.equalTo(buttonContainerView)
                make.width.equalTo(buttonContainerView.snp.width).dividedBy(buttonContainerView.subviews.count).priority(250)
            })
        })
        
        dialogView.snp.makeConstraints( { (make) in
            make.bottom.equalTo(buttonContainerView.snp.bottom)
        })
    }
    
    func updateCustomerConstraint()
    {
        let lastView = containerView.subviews.last!
        let size = lastView.frame.size
        
        dialogView.snp.makeConstraints( { (make) in
            make.centerX.equalTo(self.snp.centerX)
            make.centerY.equalTo(self.snp.centerY).offset(-20)
            make.width.equalTo(size.width)
            make.height.greaterThanOrEqualTo(0).priority(1)
        })
        
        containerView.snp.makeConstraints( { (make) in
            make.left.equalTo(dialogView.snp.left)
            make.top.equalTo(dialogView.snp.top)
            make.right.equalTo(dialogView.snp.right)
            make.bottom.equalTo(lastView.snp.bottom)
        })
        
        lineView.snp.makeConstraints( { (make) in
            make.left.equalTo(dialogView.snp.left)
            make.top.equalTo(containerView.snp.bottom)
            make.right.equalTo(dialogView.snp.right)
            make.height.equalTo(1)
        })
        
        buttonContainerView.snp.makeConstraints( { (make) in
            make.left.equalTo(dialogView.snp.left)
            make.top.equalTo(lineView.snp.bottom)
            make.right.equalTo(dialogView.snp.right)
            make.height.equalTo(40)
        })
        
        buttonContainerView.subviews.enumerated().forEach({ (index,view) in
            let button = view as! UIButton
            button.snp.makeConstraints( { (make) in
                if index == 0 {
                    make.left.equalTo(buttonContainerView.snp.left)
                } else {
                    let previousButton = buttonContainerView.subviews[index - 1]
                    make.left.equalTo(previousButton.snp.right).offset(1)
                    if index == buttonContainerView.subviews.count - 1 {
                        make.right.equalTo(buttonContainerView.snp.right)
                    }
                }
                make.top.bottom.height.equalTo(buttonContainerView)
                make.width.equalTo(buttonContainerView.snp.width).dividedBy(buttonContainerView.subviews.count).priority(1)
            })
            
        })
        
        dialogView.snp.makeConstraints( { (make) in
            make.bottom.equalTo(buttonContainerView.snp.bottom)
        })
    }
    
    override func updateConstraints() {
        
        if !didSetupConstraints {
        
            switch alertViewStyle {
            case .normal:
                self.updateNormalConstraint()
            case .customer:
                self.updateCustomerConstraint()
            }
            didSetupConstraints = true
        }
        super.updateConstraints()
    }
    
    // Keyboard Notification
    func keyboardWillShow(_ notification:Notification)
    {
        let keyboardSize = ((notification as NSNotification).userInfo![UIKeyboardFrameBeginUserInfoKey]! as AnyObject).cgRectValue.size
        let bottomHeight = (UIScreen.main.bounds.height - dialogView.frame.maxY)
        if bottomHeight < keyboardSize.height {
            let dialogSize = dialogView.frame.size
            dialogView.snp.remakeConstraints( { (make) in
                make.centerX.equalTo(self.snp.centerX)
                make.width.equalTo(dialogSize.width)
                make.height.equalTo(dialogSize.height)
                make.bottom.equalTo(self.snp.bottom).offset(-(keyboardSize.height + 20))
            })
            self.setNeedsLayout()
            UIView.animate(withDuration: 0.2, animations: {
                self.layoutIfNeeded()
            }) 
        }
    }
    
    func keyboardWillHide(_ notification:Notification)
    {
        let dialogSize = dialogView.frame.size
        dialogView.snp.remakeConstraints( { (make) in
            make.centerY.equalTo(self.snp.centerY).offset(-20)
            make.centerX.equalTo(self.snp.centerX)
            make.width.equalTo(dialogSize.width)
            make.height.equalTo(dialogSize.height)
        })
        self.setNeedsLayout()
        UIView.animate(withDuration: 0.2, animations: {
            self.layoutIfNeeded()
        }) 
    }
    
    /**
     显示Dialog
     */
    func show()
    {
        if let inParentView  = parentView{
            inParentView.addSubview(self)
            self.snp.makeConstraints( { (make) in
                make.edges.equalTo(inParentView)
            })
        }else{
            let frontToBackWindows = UIApplication.shared.windows.reversed()
            for window in frontToBackWindows {
                let windowOnMainScreen = window.screen == UIScreen.main
                let windowIsVisible = (!window.isHidden) && window.alpha > 0
                let windowLevelNormal = window.windowLevel == UIWindowLevelNormal
                
                if windowOnMainScreen && windowIsVisible && windowLevelNormal {
                    window.addSubview(self)
                    self.snp.makeConstraints( { (make) in
                        make.edges.equalTo(window)
                    })
                    break
                }
            }
        }

        dialogView.layer.opacity = 0.5;
        dialogView.layer.transform = CATransform3DMakeScale(1.3, 1.3, 1.0)
        
        UIView.animate(withDuration: 0.2, delay: 0, options: UIViewAnimationOptions(), animations: {
            self.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.4)
            self.dialogView.layer.opacity = 1
            self.dialogView.layer.transform = CATransform3DMakeScale(1, 1, 1)
        }, completion: { (finshed) in
            self.superview?.bringSubview(toFront: self)
        })
        
 
    }

    /**
     关闭Dialog
     */
    func close()
    {
        dialogView.layer.opacity = 1
        let currentTransform = dialogView.layer.transform
        UIView.animate(withDuration: 0.2, delay: 0, options: UIViewAnimationOptions(), animations: { 
            self.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
            self.dialogView.layer.transform = CATransform3DConcat(currentTransform, CATransform3DMakeScale(0.6, 0.6, 1.0))
            self.dialogView.layer.opacity = 0.0
            }) { (finished) in
                 self.subviews.enumerated().forEach({ (index,view) in
                    view.removeFromSuperview()
                 })
                self.removeFromSuperview()
        }
    }

}
