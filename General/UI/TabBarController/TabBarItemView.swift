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
        }
    }
    
    var item : TabBarItem
    
    // 图片
    var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    // 按钮
    var button: UIButton = {
        let button = UIButton(type: .custom)
        return button
    }()
    
    // 新消息提示
    var label: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.white
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 9)
        label.backgroundColor = UIColor.red
        label.layer.masksToBounds = true
//        label.text = " 99 "
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
        
        button.addTarget(self, action: #selector(buttonClicked(_:)), for: .touchUpInside)
        addSubview(button)
        
        addSubview(label)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func updateConstraints() {
        
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
    }
    
    func buttonClicked(_ sender:UIButton)
    {
        if self.selectStatus {
            return
        }
        
        let tabBarNotification = TabBarNotification()
        tabBarNotification.index = self.tag - 1
        self.postNotification(Notification_TabBar, withObject: tabBarNotification)
    }
    
}
