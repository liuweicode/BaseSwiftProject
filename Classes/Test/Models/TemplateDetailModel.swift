//
//  TemplateDetailModel.swift
//  BaseSwiftProject
//
//  Created by 刘伟 on 2017/4/21.
//  Copyright © 2017年 上海凌晋信息技术有限公司. All rights reserved.
//

import UIKit
import SwiftyJSON

class TemplateDetailModel: NSObject {
    
    var id = 0
    var category_id = 0
    var topic_id = 0
    var title = ""
    var pic_url = ""
    var template_content = ""

    init(json:JSON) {
        super.init()
        self.id = json["id"].intValue
        self.category_id = json["category_id"].intValue
        self.topic_id = json["topic_id"].intValue
        
        self.title = json["title"].stringValue
        self.pic_url = json["pic_url"].stringValue
        self.template_content = json["template_content"].stringValue
    }

}
