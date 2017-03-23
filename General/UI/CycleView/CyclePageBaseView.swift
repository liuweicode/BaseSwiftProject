//
//  CyclePageBaseView.swift
//  LinkimFoundation
//
//  Created by 刘伟 on 16/7/7.
//  Copyright © 2016年 CocoaPods. All rights reserved.
//

import UIKit

// 翻页点的对齐方式
enum CyclePageAlignStyle:Int {
    case left,center,right
}

class CyclePageBaseView: UIView {

    /// 页数
    fileprivate var pageSize: NSInteger = 0
    
    /// 当前第几页
    fileprivate var pageIndex: NSInteger = 0
    
    /// 未选中状态圆点
    var normalImageName: String?
    
    /// 选中状态圆点
    var pressedImageName: String?
    
    /// 圆点间距
    var dotMargin: CGFloat = 0
    
    /// 圆点长度
    var dotWidth: CGFloat = 0
    
    /// 翻页远点的对齐方式
    var pageAlignStyle:CyclePageAlignStyle = .center // 默认居中对齐

    let contentView:UIView = {
        let contentView = UIView()
        contentView.backgroundColor = UIColor.clear
        return contentView
    }()
    
    var didSetupConstraints = false
    
    init(){
        super.init(frame: CGRect.zero)
        addSubview(contentView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func getPagetSize() -> NSInteger
    {
        return self.pageSize
    }
    
    func setPageSize(_ pageSize:NSInteger)
    {
        self.pageSize = pageSize
        self.contentView.subviews.enumerated().forEach { (index,view) in
            view.removeFromSuperview()
        }
        
        for i in 0..<self.pageSize {
            let imageView = UIImageView()
            imageView.tag = i + 1
            self.contentView.addSubview(imageView)
        }
        setPageIndex(0)
        self.didSetupConstraints = false
        self.setNeedsUpdateConstraints()
    }
    
    func setPageIndex(_ pageIndex:NSInteger)
    {
        if pageIndex == self.pageIndex && pageIndex != 0 {
            return
        }
        
        self.pageIndex = pageIndex
        for i in 0..<self.pageSize {
            let imageView = self.contentView.viewWithTag(i+1) as! UIImageView
            if pageIndex == i {
                    imageView.image = UIImage(named: self.pressedImageName!)
            }else{
                    imageView.image = UIImage(named: self.normalImageName!)
            }
        }
    }
    
    func updateConstraintsForLeft() {
        var previousView:UIView? = nil
        self.contentView.subviews.enumerated().forEach { (index,view) in
            view.snp.makeConstraints({ (make) in
                if let pre = previousView
                {
                    make.left.equalTo(pre.snp.right).offset(dotMargin)
                }else{
                    make.left.equalTo(self.contentView.snp.left).offset(dotMargin)
                }
                make.top.bottom.equalTo(self.contentView)
                make.width.equalTo(dotWidth)
            })
            previousView = view
        }
        
        if let pre = previousView {
            contentView.snp.makeConstraints({ (make) in
                make.top.bottom.equalTo(self)
                make.left.equalTo(self.snp.left).offset(20)
                make.right.equalTo(pre.snp.right)
            })
        }
    }
    
    func updateConstraintsForRight() {
        var previousView:UIView? = nil
        self.contentView.subviews.reversed().enumerated().forEach { (index,view) in
            view.snp.makeConstraints({ (make) in
                if let pre = previousView
                {
                    make.right.equalTo(pre.snp.left).offset(-dotMargin)
                }else{
                    make.right.equalTo(self.contentView.snp.right).offset(-dotMargin)
                }
                make.top.bottom.equalTo(self.contentView)
                make.width.equalTo(dotWidth)
            })
            previousView = view
        }
        
        if let pre = previousView {
            contentView.snp.makeConstraints({ (make) in
                make.top.bottom.equalTo(self)
                make.left.equalTo(pre.snp.left)
                make.right.equalTo(self.snp.right).offset(-20)
            })
        }
    }
    
    func updateConstraintsForCenter() {
        var previousView:UIView? = nil
        self.contentView.subviews.enumerated().forEach { (index,view) in
            view.snp.makeConstraints({ (make) in
                if let pre = previousView
                {
                    make.left.equalTo(pre.snp.right).offset(dotMargin)
                }else{
                    make.left.equalTo(self.contentView.snp.left).offset(dotMargin)
                }
                make.top.bottom.equalTo(self.contentView)
                make.width.equalTo(dotWidth)
            })
            previousView = view
        }
        
        if let pre = previousView {
            contentView.snp.makeConstraints({ (make) in
                make.top.bottom.equalTo(self)
                make.left.equalTo(self.contentView.subviews.first!.snp.left).priority(1)
                make.right.equalTo(pre.snp.right).priority(1)
                make.centerX.equalTo(self.snp.centerX)
            })
        }
    }
    
    override func updateConstraints() {
        
        if !didSetupConstraints
        {
            switch self.pageAlignStyle {
            case .left:
                self.updateConstraintsForLeft()
            case .center:
                self.updateConstraintsForCenter()
            case .right: 
                self.updateConstraintsForRight()
            }
            
            didSetupConstraints = true
        }
        super.updateConstraints()
    }
    
}
