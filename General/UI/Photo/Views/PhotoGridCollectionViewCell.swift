//
//  PhotoGridCollectionViewCell.swift
//  BingLiYun
//
//  Created by 刘伟 on 08/12/2016.
//  Copyright © 2016 上海凌晋信息技术有限公司. All rights reserved.
//

import UIKit

class PhotoGridCollectionViewCell: BaseCollectionViewCell {

    var representedAssetIdentifier: String!
    
    let thumbnailImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = UIColor.lightGray
        return imageView
    }()
    
    override func settingLayout() {
        
        backgroundColor = UIColor.red
        
        addSubview(thumbnailImageView)
        thumbnailImageView.snp.makeConstraints { (make) in
            make.edges.equalTo(self)
        }
    }

}
