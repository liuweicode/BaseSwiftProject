//
//  NoConnectionView.swift
//  Dancing
//
//  Created by 刘伟 on 31/10/2016.
//  Copyright © 2016 上海凌晋信息技术有限公司. All rights reserved.
//

import UIKit

typealias OnReloadButtonClick = () -> Void

class NoConnectionView: BaseView {

    let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.alwaysBounceVertical = true
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }()
    
    let contentView: UIView = {
        let contentView = UIView()
        return contentView
    }()
    
    let noConnectionView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "no_connection")
        return view
    }()
    
    let tipLab: UILabel = {
        let lab = UILabel.darkGrayLabel(fontsize: 17, text: "数据加载失败")
        return lab
    }()
    
    let checkTipLab: UILabel = {
        let lab = UILabel.lightGrayLabel(fontsize: 14, text: "没有网络")
        return lab
    }()
    
    let reloadTipLab: UILabel = {
        let lab = UILabel.lightGrayLabel(fontsize: 14, text: "点击重新加载")
        return lab
    }()
    
    let reloadButton: UIButton = {
        let btn = UIButton(type: .custom)
        btn.titleLabel?.font = DFont(17)
        btn.setTitle("重新加载", for: .normal)
        btn.setTitleColor(COLOR_BUTTON_BLUE, for: .normal)
        btn.layer.borderWidth = 1
        btn.layer.borderColor = COLOR_BUTTON_BLUE.cgColor
        btn.layer.cornerRadius = 3
        btn.layer.masksToBounds = true
        return btn
    }()
    
    var onReloadButtonClick: OnReloadButtonClick?
    
    override func settingLayout() {
        
        backgroundColor = COLOR_BACKGROUND_LIGHT_GRAY
        
        addSubview(scrollView)
        scrollView.snp.makeConstraints { (make) in
            make.edges.equalTo(self)
        }
        
        scrollView.addSubview(contentView)
        contentView.snp.makeConstraints { (make) in
            make.edges.equalTo(scrollView)
            make.width.equalTo(scrollView.snp.width)
        }
        
        addSubview(noConnectionView)
        addSubview(tipLab)
        addSubview(checkTipLab)
        addSubview(reloadTipLab)
        addSubview(reloadButton)
        
        noConnectionView.snp.makeConstraints { (make) in
            make.top.equalTo(contentView).offset(90)
            make.centerX.equalTo(contentView)
            make.width.equalTo(contentView).multipliedBy(0.5)
            make.height.equalTo(noConnectionView.snp.width).multipliedBy(0.78)
        }
        
        tipLab.snp.makeConstraints { (make) in
            make.top.equalTo(noConnectionView.snp.bottom).offset(40)
            make.centerX.equalTo(contentView)
            make.width.height.greaterThanOrEqualTo(0)
        }
        
        checkTipLab.snp.makeConstraints { (make) in
            make.top.equalTo(tipLab.snp.bottom).offset(10)
            make.centerX.equalTo(contentView)
            make.width.height.greaterThanOrEqualTo(0)
        }
        
        reloadTipLab.snp.makeConstraints { (make) in
            make.top.equalTo(checkTipLab.snp.bottom).offset(2)
            make.centerX.equalTo(contentView)
            make.width.height.greaterThanOrEqualTo(0)
        }
        
        reloadButton.snp.makeConstraints { (make) in
            make.top.equalTo(reloadTipLab.snp.bottom).offset(20)
            make.centerX.equalTo(contentView.snp.centerX)
            make.width.greaterThanOrEqualTo(0)
            make.height.equalTo(reloadButton.snp.width).multipliedBy(0.4)
        }
        
        contentView.snp.makeConstraints { (make) in
            make.bottom.equalTo(reloadButton.snp.bottom)
        }
        
        reloadButton.addTarget(self, action: #selector(onClick(_:)), for: .touchUpInside)
    }
    
    func onClick(_ sender: Any)
    {
        self.onReloadButtonClick?()
    }
    
    func setClickBlock(_ block:@escaping OnReloadButtonClick)
    {
        self.onReloadButtonClick = block
    }

}
