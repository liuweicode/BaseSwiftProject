//
//  GuidePageView.swift
//  Dancing
//
//  Created by 刘伟 on 28/10/2016.
//  Copyright © 2016 上海凌晋信息技术有限公司. All rights reserved.
//

import UIKit

class GuidePageView: CyclePageBaseView {

    override init() {
        super.init()
        self.dotMargin = 7
        self.dotWidth = 10
        self.normalImageName = "guide_page_normal"
        self.pressedImageName = "guide_page_pressed"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
