//
//  NetworkSessionManager.swift
//  BingLiYun
//
//  Created by 刘伟 on 06/01/2017.
//  Copyright © 2017 上海凌晋信息技术有限公司. All rights reserved.
//

import UIKit
import Alamofire

class NetworkSessionManager {
    
    fileprivate var _manager: Alamofire.SessionManager?
    
    var manager: Alamofire.SessionManager
    {
        get{
            if _manager == nil
            {
                let serverTrustPolicies: [String: ServerTrustPolicy] =
                    [  NetworkURLConfig.shared.API_HOST: .performDefaultEvaluation(validateHost: true),
                       "insecure.expired-apis.com": .disableEvaluation
                    ]
                let configuration = URLSessionConfiguration.default
                configuration.httpAdditionalHeaders = SessionManager.defaultHTTPHeaders
                configuration.httpMaximumConnectionsPerHost = 10
                configuration.httpShouldSetCookies = true
                configuration.httpCookieStorage = HTTPCookieStorage.shared
                _manager = Alamofire.SessionManager(configuration: configuration, serverTrustPolicyManager: ServerTrustPolicyManager(policies: serverTrustPolicies))
            }
            return _manager!
        }
    }
    
    // 单例类
    static let shared = NetworkSessionManager()
    
    // 私有化init方法
    fileprivate init() {
        #if DEBUG
            self.manager.adapter = self
        #endif
    }
}

extension NetworkSessionManager: RequestAdapter {
    
    /// Inspects and adapts the specified `URLRequest` in some manner if necessary and returns the result.
    ///
    /// - parameter urlRequest: The URL request to adapt.
    ///
    /// - throws: An `Error` if the adaptation encounters an error.
    ///
    /// - returns: The adapted `URLRequest`.
    func adapt(_ urlRequest: URLRequest) throws -> URLRequest {
        
        #if DEBUG
            // 这里只是打印测试
            ANT_LOG_INFO("这里只是打印测试")
            let requestHeaders = urlRequest.allHTTPHeaderFields == nil ? [String : String]()
                : urlRequest.allHTTPHeaderFields!
            do{
                let requestHeaderJsonData = try JSONSerialization.data(withJSONObject: requestHeaders, options: .prettyPrinted)
                let requestHeaderDicts = try JSONSerialization.jsonObject(with: requestHeaderJsonData, options: .allowFragments)
                
                var requestParamDicts: Any = ""
                
                if let bodyData = urlRequest.httpBody, let key = NetworkCipher.sharedInstance.aes_key, let iv = NetworkCipher.sharedInstance.aes_iv
                {
                    
                    if let decodedData = FSOpenSSL.aes_decrypt(bodyData, key: key, iv: iv)
                    {
                        requestParamDicts = try JSONSerialization.jsonObject(with: decodedData, options: .allowFragments)
                    }
                }
                ANT_LOG_NETWORK_REQUEST("Request URL:\(urlRequest.url!.absoluteString)\nRequest Headers:\(requestHeaderDicts)\nRequest Params：\(requestParamDicts)")
            } catch {
                ANT_LOG_NETWORK_ERROR(error.localizedDescription)
            }
        #endif
        
        return urlRequest
    }
    
    
}
