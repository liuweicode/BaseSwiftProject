//
//  ScrollDefaultItemView.swift
//  Dancing
//
//  Created by 刘伟 on 31/10/2016.
//  Copyright © 2016 上海凌晋信息技术有限公司. All rights reserved.
//

import UIKit
import SnapKit

typealias OnClick = (_ extraData:Any? ) -> Void

// 默认高度
let ScrollDefaultItemViewDefaultHeight:CGFloat = 44

// 标题 + 描述 + 图标 的形式
class ScrollDefaultItemView: BaseView {

    let titleLab: UILabel = {
        let lab = UILabel.darkGrayLabel(fontsize: 16)
        lab.isUserInteractionEnabled = true
        return lab
    }()
    
    let detailLab: UILabel = {
        let lab = UILabel.lightGrayLabel(fontsize: 14)
        lab.textAlignment = .right
        lab.isUserInteractionEnabled = true
        return lab
    }()
    
    let iconView: UIImageView = {
        let icon = UIImageView()
        icon.contentMode = .scaleAspectFit
        icon.isUserInteractionEnabled = true
        return icon
    }()
    
    let lineView: UIView = {
        let lineView = UIView.lightGrayLineView()
        return lineView
    }()
    
    // Extra data
    var data: Any?
    
    // 点击事件
    var clickBlock: OnClick?
    
    override func settingLayout() {
        backgroundColor = COLOR_WHITE
        isUserInteractionEnabled = true
        
        addSubview(titleLab)
        titleLab.snp.makeConstraints { (make) in
            make.left.equalTo(self.snp.left).offset(20)
            make.centerY.equalTo(self.snp.centerY)
            make.width.height.greaterThanOrEqualTo(0)
        }
        
        addSubview(iconView)
        iconView.snp.makeConstraints { (make) in
            make.centerY.equalTo(self.snp.centerY)
            make.right.equalTo(self.snp.right).offset(-20)
            make.width.height.greaterThanOrEqualTo(0)
        }
        
        addSubview(detailLab)
        detailLab.snp.makeConstraints { (make) in
            make.right.equalTo(iconView.snp.left).offset(-4)
            make.centerY.equalTo(self.snp.centerY)
            make.height.greaterThanOrEqualTo(0)
            make.width.greaterThanOrEqualTo(0)
            make.left.greaterThanOrEqualTo(titleLab.snp.right)
        }
        
        addSubview(lineView)
        lineView.snp.makeConstraints { (make) in
            make.left.equalTo(titleLab.snp.left)
            make.right.equalTo(self.snp.right)
            make.height.equalTo(1)
            make.bottom.equalTo(self.snp.bottom)
        }
    }
    
    func setLineMargin(left leftMargin:CGFloat, right rightMargin:CGFloat)
    {
        lineView.snp.makeConstraints { (make) in
            make.left.equalTo(self.snp.left).offset(leftMargin)
            make.right.equalTo(self.snp.right).offset(rightMargin)
            make.height.equalTo(1)
            make.bottom.equalTo(self.snp.bottom)
        }
    }
    
    func setOnClick(_ onClick:@escaping OnClick)
    {
        self.clickBlock = onClick
    }
    
    func loadWith(title:String, detail:String = "", icon:String = "arrow_right", isIconHidden:Bool = false)
    {
        titleLab.text = title
        detailLab.text = detail
        if isIconHidden
        {
            iconView.image = UIImage(named: "transparent_square")
        }else{
            iconView.image = UIImage(named: icon)
        }
    }

    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("touchesBegan")
        backgroundColor = UIColor.groupTableViewBackground
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("touchesCancelled")
        UIView.animate(withDuration: 0.15, animations: { () -> Void in
            self.backgroundColor = UIColor.white
        })
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("touchesEnded")
        UIView.animate(withDuration: 0.15, animations: { () -> Void in
            self.backgroundColor = UIColor.white
        })
        self.clickBlock?(self.data)
    }

}
