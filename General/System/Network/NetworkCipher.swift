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
    static let sharedInstance = NetworkCipher()
    
    // 私有化init方法
    override init() {}
    
    // 网络数据传输 AES 加密Key
    var aes_key: String?

    // 网络数据传输 AES 加密IV
    var aes_iv: String?
    
    // 用于生成签名 signature = sort(token + timestamp + nonce) -> sha1
    var token: String?
    
//    func requestKeys(withCompleteHandler handler: @escaping (_ aes_key: String?, _ aes_iv: String?, _ token:String?)-> Void)
//    {
//        objc_sync_enter(self)
//        if let key = self.aes_key,
//           let iv = self.aes_iv,
//           let token = self.token
//        {
//            #if DEBUG
//                ANT_LOG_INFO("本地已经存在密钥")
//            #endif
//            DispatchQueue.main.safeAsync{
//                handler(key, iv, token)
//            }
//            return
//        }
//        
//        DispatchQueue.global(qos: .background).async{
//            #if DEBUG
//                ANT_LOG_INFO("从网络请求密钥：\(API(API_SYSTEM_GETAESKEY))")
//            #endif
//            if let data = try? Data(contentsOf: URL(string: API(API_SYSTEM_GETAESKEY))!)
//            {
//                let json = JSON(data: data)
//                self.aes_key = json["data"]["responsedata"]["aes_key"].string
//                self.aes_iv = json["data"]["responsedata"]["aes_iv"].string
//                self.token = json["data"]["responsedata"]["token"].string
//                #if DEBUG
//                    ANT_LOG_INFO("子线程从网络请求密钥成功：aes_key:\(self.aes_key) \naes_iv:\(self.aes_iv) \ntoken:\(self.token)")
//                #endif
//            }
//            DispatchQueue.main.async {
//                #if DEBUG
//                    ANT_LOG_INFO("从网络请求密钥返回主线程：aes_key:\(self.aes_key) \naes_iv:\(self.aes_iv) \ntoken:\(self.token)")
//                #endif
//                handler(self.aes_key, self.aes_iv, self.token)
//            }
//        }
//        objc_sync_exit(self)
//    }
    
}
