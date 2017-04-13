//
//  TabBarItemView.swift
//  LinkimFoundation
//
//  Created by 刘伟 on 16/7/1.
//  Copyright © 2016年 CocoaPods. All rights reserved.
//

import UIKit

class TabBarItemView: UIView {

    fileprivate var _selectStatus = false
    
    // 是否选中
    var selectStatus:Bool{
        get {
            return _selectStatus
        }
        set{
            _selectStatus = newValue
            let imageName = _selectStatus ? self.item.highlightedImageName : self.item.normalImageName
            self.imageView.image = UIImage(named: imageName)
            self.textLabel.textColor = _selectStatus ? COLOR_TABBAR_BLUE:COLOR_TABBAR_GRAY
            self.imageView.tintColor = _selectStatus ? COLOR_TABBAR_BLUE:COLOR_TABBAR_GRAY
        }
    }
    
    var item : TabBarItem
    
    // 图片
    var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.tintColor = COLOR_TABBAR_GRAY
        imageView.contentMode = UIViewContentMode.scaleAspectFit
        return imageView
    }()
    
    // 文字
    var textLabel: UILabel = {
        let textLabel = UILabel()
        textLabel.textAlignment = NSTextAlignment.center
        textLabel.textColor = COLOR_TABBAR_GRAY
        textLabel.font = UIFont.systemFont(ofSize: 10)
        return textLabel
    }()
    
    // 按钮
    var button: UIButton = {
        let button = UIButton(type: UIButtonType.custom)
        return button
    }()
    
    // 新消息提示()
    var label: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.white
        label.textAlignment = NSTextAlignment.center
        label.font = UIFont.systemFont(ofSize: 9)
        label.backgroundColor = UIColor.red
        label.layer.masksToBounds = true
        //label.text = " 99 "
        label.layer.masksToBounds = true;
        label.layer.cornerRadius = 3;
        label.isHidden = true
        return label
    }()
    
    var didSetupConstraints = false
    
    init(_ aItem: TabBarItem)
    {
        item = aItem
        super.init(frame: CGRect.zero)
        imageView.image = UIImage(named: item.normalImageName)
        addSubview(imageView)
        
        textLabel.text = item.title
        addSubview(textLabel)

        button.addTarget(self, action: #selector(buttonClicked(_:)), for: .touchUpInside)
        addSubview(button)
        
        addSubview(label)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func updateConstraints() {
        //图片自带文字
        if !didSetupConstraints {
            
            imageView.snp.makeConstraints( { (make) in
                make.top.equalTo(self.snp.top)
                make.bottom.equalTo(self.snp.bottom)
                make.width.equalTo(imageView.snp.height)
                make.centerX.equalTo(self.snp.centerX)
            })
            
            button.snp.makeConstraints( { (make) in
                make.edges.equalTo(self)
            })
            
            label.snp.makeConstraints( { (make) in
                make.top.equalTo(self.snp.top)
                make.width.height.greaterThanOrEqualTo(6)
                make.left.equalTo(imageView.snp.right);
                make.width.lessThanOrEqualTo(20)
            })
            
            didSetupConstraints = true
        }
        super.updateConstraints()
        
        /* //图片不自带文字的情况下
        if !didSetupConstraints {
            
            let size = UIImage(named: item.normalImageName)?.size
            if !item.title.isEmpty{
                imageView.snp.makeConstraints( { (make) in
                    make.centerX.equalTo(self.snp.centerX)
                    make.centerY.equalTo(self.snp.centerY).offset(-6)
                    make.size.equalTo(size!)
                })
                
                textLabel.snp.makeConstraints({ (make) in
                    make.height.equalTo(12)
                    make.bottom.equalTo(self.snp.bottom)
                    make.width.equalTo(self.snp.width)
                    make.centerX.equalTo(imageView)
                })
                
                label.snp.makeConstraints({ (make) in
                    make.top.equalTo(self.snp.top)
                    make.width.height.greaterThanOrEqualTo(6)
                    make.left.equalTo(imageView.snp.right);
                    make.width.lessThanOrEqualTo(20)
                })
            }
            
            //当tabbar是只有一个图片的时候，不显示其他的东西。但有点击事件
            if item.title.isEmpty{
                imageView.snp.makeConstraints( { (make) in
                    make.center.equalTo(self.snp.center)
                    make.size.equalTo(size!)
                })
            }
            
            button.snp.makeConstraints( { (make) in
                make.edges.equalTo(self)
            })
            
            didSetupConstraints = true
        }
        super.updateConstraints()
         */
    }
    
    func buttonClicked(_ sender:UIButton)
    {
        if item.title.isEmpty {
            //Code Here . Show View Not Change Tabbar (post activity & meetting)

            
            return
        }
        
        if self.selectStatus {
            return
        }
        
        let tabBarNotification = TabBarNotification()
        tabBarNotification.index = self.tag - 1
        self.postNotification(Notification_TabBar, withObject: tabBarNotification)
    }
    
}
