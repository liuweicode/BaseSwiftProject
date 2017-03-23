//
//  GuideView.swift
//  Dancing
//
//  Created by 刘伟 on 28/10/2016.
//  Copyright © 2016 上海凌晋信息技术有限公司. All rights reserved.
//

import UIKit
import SnapKit

class GuideView: BaseView {

    /// 轮播控件
    var cycleView:CycleView = {
        let cycleView = CycleView()
        cycleView.isAutoScroll = false
        cycleView.isLoop = false
        cycleView.registerClass(GuideCollectionViewCell.self, identifier: String(describing: GuideCollectionViewCell.self))
        return cycleView
    }()
    
    /// 翻页控件
    var pageView:GuidePageView = {
        let advertPageView = GuidePageView()
        advertPageView.pageAlignStyle = .center
        return advertPageView
    }()
    
    var didSetupConstraints = false
    
    override init()
    {
        super.init(frame: CGRect(x: 0, y: 0, width: ScreenWidth, height: ScreenWidth * 0.5))
        addSubview(cycleView)
        addSubview(pageView)
        cycleView.setPageView(pageView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func updateConstraints() {
        
        if !didSetupConstraints {
            
            cycleView.snp.makeConstraints({ (make) in
                make.edges.equalTo(self)
            })
            
            pageView.snp.makeConstraints({ (make) in
                make.left.equalTo(self.snp.left)
                make.right.equalTo(self.snp.right)
                make.height.equalTo(10)
                make.bottom.equalTo(self.snp.bottom).offset(-8)
            })
            
            didSetupConstraints = true
        }
        super.updateConstraints()
    }
    
}
