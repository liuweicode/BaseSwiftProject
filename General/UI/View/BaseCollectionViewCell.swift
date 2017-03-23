//
//  BaseCollectionViewCell.swift
//  DaQu
//
//  Created by 刘伟 on 9/6/16.
//  Copyright © 2016 上海凌晋信息技术有限公司. All rights reserved.
//

import UIKit

class BaseCollectionViewCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        settingLayout()
    }
    
    init()
    {
        super.init(frame: CGRect.zero)
        translatesAutoresizingMaskIntoConstraints = false
        settingLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func settingLayout()
    {
        
    }
    
}
