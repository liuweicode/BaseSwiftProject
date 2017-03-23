//
//  Thread.swift
//  SKFinance
//
//  Created by 刘伟 on 26/12/2016.
//  Copyright © 2016 上海凌晋信息技术有限公司. All rights reserved.
//

import Foundation

extension DispatchQueue {
    
    // This is referenced to Kingfisher
    //
    // This method will dispatch the `block` to self.
    // If `self` is the main queue, and current thread is main thread, the block
    // will be invoked immediately instead of being dispatched.
    func safeAsync(_ block: @escaping ()->()) {
        if self === DispatchQueue.main && Thread.isMainThread {
            block()
        } else {
            async { block() }
        }
    }
}
