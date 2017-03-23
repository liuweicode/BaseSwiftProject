//
//  DemoView.swift
//  DaQu
//
//  Created by 刘伟 on 16/9/28.
//  Copyright © 2016年 上海凌晋信息技术有限公司. All rights reserved.
//

import UIKit
import SnapKit

class DemoView: BaseView {

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
    }

}
