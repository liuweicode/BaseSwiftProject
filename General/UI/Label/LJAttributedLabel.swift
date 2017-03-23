//
//  LJAttributedLabel.swift
//  Dancing
//
//  Created by 刘伟 on 31/10/2016.
//  Copyright © 2016 上海凌晋信息技术有限公司. All rights reserved.
//

import UIKit
import TTTAttributedLabel

let LJ_ACTION_PATH = "LJ_ACTION://"

typealias LJLabelLinkBlock = (_ action:String) -> Void

class LJAttributedLabel: TTTAttributedLabel {

    var block: LJLabelLinkBlock?
    
    func addTextLink(withColor color:UIColor, andAction action:String, onRange range:NSRange)
    {
        let path = "\(LJ_ACTION_PATH)\(action)"
        guard let url = URL(string: path) else { return }
        let result = NSTextCheckingResult.linkCheckingResult(range: range, url: url)
        self.addLink(with: result, attributes: [kCTForegroundColorAttributeName as AnyHashable:color])
        self.delegate = self
    }
    
    func addTextLink(withAction action:String, onRange range:NSRange)
    {
        let path = "\(LJ_ACTION_PATH)\(action)"
        guard let url = URL(string: path) else { return }
        let result = NSTextCheckingResult.linkCheckingResult(range: range, url: url)
        self.addLink(with: result, attributes: [:])
        self.delegate = self
    }
    
    func makeTextLinkClickBlock(_ block:@escaping LJLabelLinkBlock)
    {
        self.block = block
    }
}

extension LJAttributedLabel: TTTAttributedLabelDelegate
{
    func attributedLabel(_ label: TTTAttributedLabel!, didSelectLinkWith url: URL!) {
        let path = url.absoluteString
        if path.length > LJ_ACTION_PATH.length
        {
            let action = path.substring(from: LJ_ACTION_PATH.endIndex)
            self.block?(action)
        }
    }
}


