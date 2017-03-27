//
//  NetworkHandler.swift
//  JiChongChong
//
//  Created by 刘伟 on 3/24/17.
//  Copyright © 2017 上海凌晋信息技术有限公司. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

//enum BackendError: Error {
//    case network(error: Error)
//    case jsonSerialization(error: Error)
//    case xmlSerialization(error: Error)
//    case objectSerialization(reason: String)
//    case encryptionKeyIsNull // 加密密钥为空
//}

enum EncryptionKeyIsNull: Error {case null}

// 请求重试最大次数
let REQUEST_RETRY_MAX_COUNT = 3

class NetworkHandler: RequestAdapter, RequestRetrier
{
    var isEncrypt: Bool = true // 是否需要加密请求体数据
    var requestRetryCount = 0
    
    private typealias RefreshCompletion = (_ succeeded: Bool, _ aes_key: String?, _ aes_iv: String?, _ token: String?) -> Void
    
    private let sessionManager: SessionManager = {
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = SessionManager.defaultHTTPHeaders
        return SessionManager(configuration: configuration)
    }()
    
    private let lock = NSLock()
    
    private var isRefreshing = false
    private var requestsToRetry: [RequestRetryCompletion] = []
    
    func adapt(_ urlRequest: URLRequest) throws -> URLRequest
    {
        guard let key = NetworkCipher.shared.aes_key, let iv = NetworkCipher.shared.aes_iv else
        {
            #if DEBUG
                ANT_LOG_INFO("没有密钥 需要获取密钥")
            #endif
            throw EncryptionKeyIsNull.null
        }
        
        var urlRequest = urlRequest
        
        // 设置请求头
        setRequestHTTPHeaders(&urlRequest)
        
        if isEncrypt {
            // 请求体加密
            setRequestDataBody(&urlRequest, key, iv)
        }
        
        #if DEBUG
            logRequestJsonInfo(urlRequest)
        #endif
        
        return urlRequest
    }
    
    func should(_ manager: SessionManager, retry request: Request, with error: Error, completion: @escaping RequestRetryCompletion)
    {   
        lock.lock() ; defer { lock.unlock() }
        
        if requestRetryCount > REQUEST_RETRY_MAX_COUNT
        {
            // 如果重试次数大于最大重试次数，则取消重试
            completion(false, 0.0)
            return
        }
        if error is EncryptionKeyIsNull
        {
            // 如果错误是加密 key 为空，则需要获取加密 key
            doRefreshTokens(completion)
            return
        }
        // 401 表示加密 key 不合法 需要重新获取，需要与服务器一致
        if let response = request.task?.response as? HTTPURLResponse
        {
            if response.statusCode == NETWORK_RESPONSE_STATUS_CODE
            {
                doRefreshTokens(completion)
            }
            else
            {
                completion(false, 0.0)
            }
        }
        else
        {
            completion(false, 0.0)
        }
    }
    
    private func doRefreshTokens(_ completion: @escaping RequestRetryCompletion)
    {
        requestsToRetry.append(completion)
        
        if !isRefreshing {
            refreshTokens { [weak self] succeeded, aes_key, aes_iv, token in
                guard let strongSelf = self else { return }
                
                strongSelf.lock.lock() ; defer { strongSelf.lock.unlock() }
                
                if let key = aes_key, let iv = aes_iv, let tk = token {
                    NetworkCipher.shared.set(aes_key: key, aes_iv: iv, token: tk)
                    #if DEBUG
                        ANT_LOG_INFO("密钥获取成功:aes_key:\(key) aes_iv:\(iv) token:\(tk)")
                    #endif
                }
                
                strongSelf.requestsToRetry.forEach { $0(succeeded, 0.0) }
                strongSelf.requestsToRetry.removeAll()
            }
        }
    }
    
    // MARK: - Private - Refresh Tokens
    private func refreshTokens(completion: @escaping RefreshCompletion) {
        guard !isRefreshing else { return }
        
        isRefreshing = true
        
        sessionManager.request(API(service: API_SYSTEM_GETAESKEY), method: .post, parameters: nil, encoding: JSONEncoding.default)
            .responseData{[weak self] (dataResponse) in
                
                guard let strongSelf = self else { return }
                
                // 是否有错误
                if dataResponse.result.isFailure
                {
                    completion(false, nil, nil, nil)
                    return
                }
                
                guard let responseData = dataResponse.data, responseData.count > 0 else
                {
                    completion(false, nil, nil, nil)
                    return
                }
                
                guard let decodedData = FSOpenSSL.rsaDecode(responseData) else
                {
                    completion(false, nil, nil, nil)
                    return
                }
                
                let json = JSON(data: decodedData)
                
                if json["ret"].intValue != NetworkResponseCode.operation_success.rawValue
                {
                    completion(false, nil, nil, nil)
                    return
                }
                
                 guard let key = json["data"]["responsedata"]["aes_key"].string ,let iv = json["data"]["responsedata"]["aes_iv"].string, let token = json["data"]["responsedata"]["token"].string else {
                    completion(false, nil, nil, nil)
                    return
                }
                
                completion(true, key, iv, token)
                
                strongSelf.isRefreshing = false
        }
    }
    
    fileprivate func setRequestHTTPHeaders( _ urlRequest: inout URLRequest)
    {
        // 时间戳
        let timestamp = String(Int(Date().timeIntervalSince1970))
        // 随机数
        let nonce = NetworkUtils.generateRandNumber()
        // 签名
        let signature = NetworkUtils.generateSignature(timestamp, random: nonce)
        
        urlRequest.setValue(timestamp, forHTTPHeaderField: "X-LJ-T");
        urlRequest.setValue(nonce, forHTTPHeaderField: "X-LJ-N");
        urlRequest.setValue(signature, forHTTPHeaderField: "X-LJ-SIGN");
        urlRequest.setValue("application/octet-stream", forHTTPHeaderField: "Content-Type");
    }
    
    fileprivate func setRequestDataBody( _ urlRequest: inout URLRequest, _ aes_key: String, _ aes_iv: String)
    {
        guard let originBody = urlRequest.httpBody else {
            return
        }
        
        if let body = FSOpenSSL.aes_encrypt(originBody, key: aes_key, iv: aes_iv)
        {
            urlRequest.httpBody = body
        }
    }
    
    
    fileprivate func logRequestJsonInfo(_ urlRequest: URLRequest)
    {
        let requestHeaders = urlRequest.allHTTPHeaderFields == nil ? [String : String]()
            : urlRequest.allHTTPHeaderFields!
        do{
            let requestHeaderJsonData = try JSONSerialization.data(withJSONObject: requestHeaders, options: .prettyPrinted)
            let requestHeaderDicts = try JSONSerialization.jsonObject(with: requestHeaderJsonData, options: .allowFragments)
            
            var requestParamDicts: Any = ""
            
            if let bodyData = urlRequest.httpBody
            {
                if isEncrypt
                {
                    if let key = NetworkCipher.shared.aes_key, let iv = NetworkCipher.shared.aes_iv
                    {
                        if let decodedData = FSOpenSSL.aes_decrypt(bodyData, key: key, iv: iv)
                        {
                            do{
                                requestParamDicts = try JSONSerialization.jsonObject(with: decodedData, options: .allowFragments)
                            } catch {
                                requestParamDicts = "\(decodedData.count) bytes"
                            }
                        }else{
                            requestParamDicts = "解密失败"
                        }
                    }else{
                        requestParamDicts = "没有加解密密钥"
                    }
                }else{
                    do{
                        requestParamDicts = try JSONSerialization.jsonObject(with: bodyData, options: .allowFragments)
                    } catch {
                        requestParamDicts = "\(bodyData.count) bytes"
                    }
                }
            }
            ANT_LOG_NETWORK_REQUEST("Request URL:\(urlRequest.url!.absoluteString)\nRequest Headers:\(requestHeaderDicts)\nRequest Params：\(requestParamDicts)")
        } catch {
            ANT_LOG_NETWORK_ERROR(error.localizedDescription)
        }
    }
    
    fileprivate func logRequestDataInfo(_ urlRequest: URLRequest)
    {
        let requestHeaders = urlRequest.allHTTPHeaderFields == nil ? [String : String]()
            : urlRequest.allHTTPHeaderFields!
        do{
            let requestHeaderJsonData = try JSONSerialization.data(withJSONObject: requestHeaders, options: .prettyPrinted)
            let requestHeaderDicts = try JSONSerialization.jsonObject(with: requestHeaderJsonData, options: .allowFragments)
            
            let bodyDataLength = urlRequest.httpBody == nil  ? 0 : urlRequest.httpBody!.count
            
            ANT_LOG_NETWORK_REQUEST("Request URL:\(urlRequest.url!.absoluteString)\nRequest Headers:\(requestHeaderDicts)\nRequest Data Length：\(bodyDataLength)")
        } catch {
            ANT_LOG_NETWORK_ERROR(error.localizedDescription)
        }
    }
}
