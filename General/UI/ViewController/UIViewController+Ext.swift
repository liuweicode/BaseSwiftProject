//
//  UIViewController+Ext.swift
//  DaQu
//
//  Created by 刘伟 on 2016/10/14.
//  Copyright © 2016年 上海凌晋信息技术有限公司. All rights reserved.
//

import UIKit

extension UIViewController
{

    // 导航栏 设置返回按钮
    func setNavigationBack(withTitle backTitle: String)
    {
        let image = UIImage(named: "navigation_back_normal")!
        let font = UIFont.getFontWith(text: backTitle, fontSize: 17)
        
        let leftTopBtn = UIButton(frame: CGRect(x: 0, y: 0, width: font.fontSize.width + image.size.width, height: 38))
        leftTopBtn.titleLabel?.font = font
        leftTopBtn.setTitleColor(UIColor.blue, for: .normal)
        leftTopBtn.setTitle(backTitle, for: .normal)
        leftTopBtn.setImage(image, for: .normal)
        
        let leftBar = UIBarButtonItem(customView: leftTopBtn)
        leftTopBtn.addTarget(self, action: #selector(leftTopAction(_:)), for: .touchUpInside)
        
        let negativeSpacer = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.fixedSpace, target: self, action: nil)
        negativeSpacer.width = -5
        self.navigationItem.leftBarButtonItems = [negativeSpacer, leftBar];
    }
    
    
    func setNavigationItem(withLeftObject left:Any?, rightObject right:Any?, titleObject title:Any?)
    {
        if left is UIImage
        {
            let image = left as! UIImage
            let leftTopBtn = UIButton(frame: CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height))
            leftTopBtn.setImage(image, for: .normal)
            leftTopBtn.addTarget(self, action: #selector(leftTopAction(_:)), for: .touchUpInside)
            
            let leftBar = UIBarButtonItem(customView: leftTopBtn)
            
            let negativeSpacer = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.fixedSpace, target: self, action: nil)
            negativeSpacer.width = -5
            
            self.navigationItem.leftBarButtonItems = [negativeSpacer, leftBar];
        }
        
        if left is String
        {
            let backTitle = left as! String
            let font = UIFont.getFontWith(text: backTitle, fontSize: 17)
            
            let leftTopBtn = UIButton(frame: CGRect(x: 0, y: 0, width: font.fontSize.width, height: font.fontSize.height))
            leftTopBtn.titleLabel?.font = font
            leftTopBtn.setTitleColor(UIColor.white, for: .normal)
            leftTopBtn.setTitle(backTitle, for: .normal)
            leftTopBtn.addTarget(self, action: #selector(leftTopAction(_:)), for: .touchUpInside)
            
            let leftBar = UIBarButtonItem(customView: leftTopBtn)
            
            let negativeSpacer = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.fixedSpace, target: self, action: nil)
            
            negativeSpacer.width = -5
            
            self.navigationItem.leftBarButtonItems = [negativeSpacer, leftBar];
        }
        
        if left is UIView
        {
            let leftBar = UIBarButtonItem(customView: left as! UIView)
            let negativeSpacer = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.fixedSpace, target: self, action: nil)
            negativeSpacer.width = -5
            self.navigationItem.leftBarButtonItems = [negativeSpacer, leftBar];
        }
        
        if right is UIImage {
            let image = right as! UIImage
            let rightTopBtn = UIButton(frame: CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height))
            rightTopBtn.setImage(image, for: .normal)
            rightTopBtn.addTarget(self, action: #selector(rightTopAction(_:)), for: .touchUpInside)
            
            let rightBar = UIBarButtonItem(customView: rightTopBtn)
            
            let negativeSpacer = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.fixedSpace, target: self, action: nil)
            
            negativeSpacer.width = -5
            
            self.navigationItem.rightBarButtonItems = [negativeSpacer, rightBar];
        }
        
        if right is String {
            let rightTitle = right as! String
            let font = UIFont.getFontWith(text: rightTitle, fontSize: 17)
            
            let rightTopBtn = UIButton(frame: CGRect(x: 0, y: 0, width: font.fontSize.width, height: font.fontSize.height))
            rightTopBtn.titleLabel?.font = font
            rightTopBtn.setTitleColor(UIColor.white, for: .normal)
            rightTopBtn.setTitle(rightTitle, for: .normal)
            rightTopBtn.addTarget(self, action: #selector(rightTopAction(_:)), for: .touchUpInside)
            
            let rightBar = UIBarButtonItem(customView: rightTopBtn)
            
            let negativeSpacer = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.fixedSpace, target: self, action: nil)
            
            negativeSpacer.width = -5
            
            self.navigationItem.rightBarButtonItems = [negativeSpacer, rightBar];
        }
        
        if right is UIView {
            let rightBar = UIBarButtonItem(customView: right as! UIView)
            let negativeSpacer = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.fixedSpace, target: self, action: nil)
            negativeSpacer.width = -5
            self.navigationItem.rightBarButtonItems = [negativeSpacer, rightBar];
        }
        
        if title is String
        {
            let titleString = title as! String
            let font = UIFont.getFontWith(text: titleString, fontSize: 20)
            let lab = UILabel(frame: CGRect(x: (ScreenWidth - font.fontSize.width)/2, y: 10.5, width: font.fontSize.width, height: font.fontSize.height))
            lab.font = font
            lab.text = titleString
            lab.textColor = UIColor.white
            self.navigationItem.titleView = lab
        }
        
        if title is UIView
        {
            let view = title as! UIView
            self.navigationItem.titleView = view
        }
        
    }

    
    func leftTopAction(_ sender:Any)
    {
       _ = self.navigationController?.popViewController(animated: true)
    }
    
    func rightTopAction(_ sender:Any)
    {
        
    }
    
    func centerTopAction(_ sender:Any)
    {
        
    }

}
