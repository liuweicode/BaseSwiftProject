//
//  SplitLineView.swift
//  JiChongChong
//
//  Created by 刘伟 on 3/16/17.
//  Copyright © 2017 上海凌晋信息技术有限公司. All rights reserved.
//

import UIKit

let PX1 = (1 / UIScreen.main.scale)

class SplitLineView: BaseView {

    override func settingLayout() {
        self.backgroundColor = UIColor.clear
    }
    
    override func draw(_ rect: CGRect) {
        
        if let context = UIGraphicsGetCurrentContext()
        {
            context.setFillColor(UIColor.clear.cgColor)
            context.setStrokeColor(COLOR_SEPARTE_LINE_GRAY.cgColor)
            context.fill(rect);
            context.stroke(CGRect(x: 0, y: rect.size.height, width: rect.size.width, height: (1 / UIScreen.main.scale)))
        }
        
    }

}
