//
//  TabBarItem.swift
//  LinkimFoundation
//
//  Created by 刘伟 on 16/7/1.
//  Copyright © 2016年 CocoaPods. All rights reserved.
//

import UIKit

class TabBarItem: NSObject {    
    var title: String
    var className: String
    var normalImageName: String
    var highlightedImageName: String
    
    init(title aTitle:String, className aClassName:String, normalImageName aNormalImageName:String, highlightedImageName aHighlightedImageName:String) {
        title = aTitle
        className = aClassName
        normalImageName = aNormalImageName
        highlightedImageName = aHighlightedImageName
        super.init()
    }
}
