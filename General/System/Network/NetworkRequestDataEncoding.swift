////
////  NetworkRequestDataEncoding.swift
////  BingLiYun
////
////  Created by 刘伟 on 06/01/2017.
////  Copyright © 2017 上海凌晋信息技术有限公司. All rights reserved.
////
//
//import UIKit
//import Alamofire
//
//class NetworkRequestDataEncoding: ParameterEncoding {
//
//    // MARK: Encoding
//    public func encode(_ urlRequest: URLRequestConvertible, with parameters: Parameters?) throws -> URLRequest
//    {
//        var urlRequest = try urlRequest.asURLRequest()
//        
//        if let params = parameters {
//            
//            if let requestParamData = try? JSONSerialization.data(withJSONObject: params),let key = NetworkCipher.shared.aes_key, let iv = NetworkCipher.shared.aes_iv
//            {
//                urlRequest.httpBody = FSOpenSSL.aes_encrypt(requestParamData, key: key, iv: iv)
//            }
//        }
//        
//        return urlRequest
//    }
//    
//}
