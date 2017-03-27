//
//  NetworkCipher.swift
//  DaQu
//
//  Created by 刘伟 on 9/1/16.
//  Copyright © 2016 上海凌晋信息技术有限公司. All rights reserved.
//

import Foundation
import SwiftyJSON

// 网络传输数据加密
class NetworkCipher : NSObject {

    // 单例类
    static let shared = NetworkCipher()
    
    // 私有化init方法
    override init() {}

    // 网络数据传输 AES 加密Key
    fileprivate var _aes_key: String?
    var aes_key: String? {
        get{
            return _aes_key
        }
    }
    
    // 网络数据传输 AES 加密IV
    fileprivate var _aes_iv: String?
    var aes_iv: String? {
        get{
            return _aes_iv
        }
    }
    
    // 用于生成签名 signature = sort(token + timestamp + nonce) -> sha1
    fileprivate var _token: String?
    var token: String? {
        get{
            return _token
        }
    }
    
    func set(aes_key key: String, aes_iv iv: String, token tk: String)
    {
        objc_sync_enter(NetworkCipher.shared)
        _aes_key = key
        _aes_iv = iv
        _token = tk
        objc_sync_exit(NetworkCipher.shared)
    }
    
   
}
