//
//  AntLogViewController.swift
//  BingLiYun
//
//  Created by 刘伟 on 23/11/2016.
//  Copyright © 2016 上海凌晋信息技术有限公司. All rights reserved.
//

import UIKit
import SnapKit

class AntLogViewController: BaseViewController {

    var filePath: String?
    
    var textView: UITextView = {
        let tv = UITextView()
        tv.isEditable = false
        return tv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(textView)
        textView.snp.makeConstraints { (make) in
            make.edges.equalTo(view)
        }
        
        if filePath == nil
        {
            filePath = ANT_LOG_FILE_PATH
        }
        
        self.setNavigationItem(withLeftObject: nil, rightObject: "清除日志", titleObject: filePath!)
        
        textView.text = AntFileUtil.readStringWithContentsOfFile(AntFileUtil.documentPath + "/" + filePath!)
    }
    
    override func rightTopAction(_ sender: Any) {
        _ = AntFileUtil.remove(AntFileUtil.documentPath + "/" + filePath!)
        ToastView.showSuccess("删除成功")
        textView.text = ""
    }

}
