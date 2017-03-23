//
//  NetworkProtocol.swift
//  BingLiYun
//
//  Created by 刘伟 on 06/01/2017.
//  Copyright © 2017 上海凌晋信息技术有限公司. All rights reserved.
//

import Foundation

protocol NetworkProtocol {
    
    func handleNetworkSuccess(message:NetworkMessage)
    
    func handleNetworkFailure(message:NetworkMessage, errorType: NetworkErrorType)
}
