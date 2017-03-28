//
//  ActionSheet.swift
//  BaseSwiftProject
//
//  Created by 刘伟 on 3/28/17.
//  Copyright © 2017 上海凌晋信息技术有限公司. All rights reserved.
//

import UIKit

class ActionSheetButtonItem: NSObject {
    var label:String
    var action:(()->Void)?
    init(inLabel:String) {
        label = inLabel
    }
    init(inLabel:String,inAction:(()->Void)?) {
        label = inLabel
        action = inAction
    }
    
    class func cancelButton() -> ActionSheetButtonItem
    {
        return ActionSheetButtonItem(inLabel: "取消")
    }
    
    class func okButton(inAction:(()->Void)?) -> ActionSheetButtonItem
    {
        return ActionSheetButtonItem(inLabel: "确定", inAction: inAction)
    }
}

typealias ActionSheetButtonTouchUpInside = (_ button:ActionSheetButtonItem, _ buttonIndex:Int) -> Void

let ActionSheet_View_Corner_Radius:CGFloat = 7
let ACTIONSHEETVIEWWIDTH = ScreenWidth * 0.9

class ActionSheet: UIView {
    
    var parentView:UIView?
    
    var didSetupConstraints = false
    
//    var dialogView:UIView = {
//        let dialogView = UIView()
//        dialogView.backgroundColor = UIColor.white
//        dialogView.layer.cornerRadius = ActionSheet_View_Corner_Radius;
//        dialogView.layer.masksToBounds = true
//        dialogView.layer.borderColor = UIColor(red: 198.0/255.0, green: 198.0/255.0, blue: 198.0/255.0, alpha: 1.0).cgColor
//        dialogView.layer.borderWidth = 0.65;
//        dialogView.layer.shadowRadius = ActionSheet_View_Corner_Radius + 5;
//        dialogView.layer.shadowOpacity = 0.1;
//        dialogView.layer.shadowOffset = CGSize(width: 0 - (ActionSheet_View_Corner_Radius+5)/2, height: 0 - (ActionSheet_View_Corner_Radius+5)/2);
//        dialogView.layer.shadowColor = UIColor.black.cgColor;
//        dialogView.layer.shadowPath = UIBezierPath(roundedRect: dialogView.bounds, cornerRadius: dialogView.layer.cornerRadius).cgPath
//        return dialogView
//    }()
    
    var buttonContainerView:UIView = {
        let buttonContainerView = UIView()
        buttonContainerView.backgroundColor = UIColor.clear
        return buttonContainerView
    }()
    
    fileprivate var cancelButtonItem: ActionSheetButtonItem?
    fileprivate var otherButtonItems: [ActionSheetButtonItem]?
    
    var onButtonTouchUpInside:ActionSheetButtonTouchUpInside?
    
    func setCancelButtonItem(_ cancelButtonItem:ActionSheetButtonItem)
    {
        self.cancelButtonItem = cancelButtonItem
        buttonContainerView.subviews.enumerated().forEach { (index,view) in
            view.removeFromSuperview()
        }
        self.setButtons()
    }
    
    func setOtherButtonItems(_ otherButtonItems:ActionSheetButtonItem...)
    {
        self.otherButtonItems = otherButtonItems
        buttonContainerView.subviews.enumerated().forEach { (index,view) in
            view.removeFromSuperview()
        }
        self.setButtons()
    }
    
    func setButtons()
    {
        let buttonsArray = otherButtonItems ?? [ActionSheetButtonItem]()
        for (index,value) in buttonsArray.enumerated() {
            let closeButton = UIButton(type: .custom)
            closeButton.tag = index + 1
            closeButton.setTitle(value.label, for: .normal)
            closeButton.setTitleColor(UIColor.white, for: .normal)
            closeButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
            closeButton.layer.cornerRadius = ActionSheet_View_Corner_Radius
            closeButton.layer.masksToBounds = true
            closeButton.setBackgroundImage(UIImage.imageWithColor(UIColor(hex6: 0x5B89D8)), for: .normal)
            closeButton.setBackgroundImage(UIImage.imageWithColor(UIColor(hex6: 0x5B89D8).alphaValue(0.8)), for: .highlighted)
            closeButton.addTarget(self, action: #selector(onButtonClick(_:)), for: .touchUpInside)
            buttonContainerView.addSubview(closeButton)
        }
        if let inCancelButtonItem = cancelButtonItem {
            // 取消按钮
            let closeButton = UIButton(type: .custom)
            closeButton.tag = 0
            closeButton.setTitle(inCancelButtonItem.label, for: .normal)
            closeButton.setTitleColor(UIColor(hex6: 0x5B89D8), for: .normal)
            closeButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
            closeButton.layer.cornerRadius = ActionSheet_View_Corner_Radius
            closeButton.layer.masksToBounds = true
            closeButton.setBackgroundImage(UIImage.imageWithColor(UIColor(hex6: 0xF7F7F7)), for: .normal)
            closeButton.setBackgroundImage(UIImage.imageWithColor(UIColor(hex6: 0xF7F7F7).alphaValue(0.8)), for: .highlighted)
            closeButton.addTarget(self, action: #selector(onButtonClick(_:)), for: .touchUpInside)
            buttonContainerView.addSubview(closeButton)
        }
    }
    
    init() {
        super.init(frame: CGRect.zero)
        self.translatesAutoresizingMaskIntoConstraints = false
        let screenBounds = UIScreen.main.bounds
        frame = CGRect(x: 0, y: 0, width: screenBounds.width, height: screenBounds.height)
    
        addSubview(buttonContainerView)
    }
    
    convenience init(title inTitle:String?,message inMessage:String?,cancelButtonItem inCancelButtonItem:ActionSheetButtonItem?,otherButtonItems inOtherButtonItems:ActionSheetButtonItem...) {
        self.init()
        
        cancelButtonItem = inCancelButtonItem
        otherButtonItems = inOtherButtonItems
        
        self.setButtons()
        
    }
    
    convenience init(title inTitle:String?,message inMessage:String?,cancelButtonItem inCancelButtonItem:ActionSheetButtonItem?,otherButtonItems inOtherButtonItems:[ActionSheetButtonItem]?) {
        self.init()
        
        cancelButtonItem = inCancelButtonItem
        otherButtonItems = inOtherButtonItems
        
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
        buttonContainerView.snp.makeConstraints( { (make) in
            make.centerX.equalTo(self)
            make.width.equalTo(ACTIONSHEETVIEWWIDTH)
            make.top.equalTo(self.snp.bottom).priority(200)
            make.height.greaterThanOrEqualTo(0)
        })
        
        buttonContainerView.subviews.enumerated().forEach({ (index,view) in
            let button = view as! UIButton
            button.snp.makeConstraints( { (make) in
                make.left.right.equalTo(buttonContainerView)
                make.height.equalTo(44)
                make.top.equalTo(buttonContainerView.snp.top).offset(index * (44 + 13))
            })
        })
        
        if let lastView = buttonContainerView.subviews.last
        {
            buttonContainerView.snp.makeConstraints( { (make) in
                make.bottom.equalTo(lastView.snp.bottom).offset(20)
            })
        }
        
    }
    
    override func updateConstraints() {
        
        if !didSetupConstraints {
            self.updateNormalConstraint()
            didSetupConstraints = true
        }
        super.updateConstraints()
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
        self.setNeedsLayout()
        self.layoutIfNeeded()
        
        UIView.animate(withDuration: 0.2, delay: 0, options: UIViewAnimationOptions(), animations: {
            self.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.7)
            self.buttonContainerView.snp.makeConstraints( { (make) in
                make.bottom.equalTo(self.snp.bottom).priority(1000)
            })
            self.layoutIfNeeded()
        }) { (finished) in
            self.superview?.bringSubview(toFront: self)
        }
        
    }
    
    /**
     关闭Dialog
     */
    func close()
    {
        let currentTransform = buttonContainerView.layer.transform
        let buttonContainerViewHeight = buttonContainerView.frame.height
        UIView.animate(withDuration: 0.2, delay: 0, options: UIViewAnimationOptions(), animations: {
            self.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
            self.buttonContainerView.layer.transform = CATransform3DConcat(currentTransform, CATransform3DMakeTranslation(0, buttonContainerViewHeight, 0))
        }) { (finished) in
            self.subviews.enumerated().forEach({ (index,view) in
                view.removeFromSuperview()
            })
            self.removeFromSuperview()
        }
    }
    
}
