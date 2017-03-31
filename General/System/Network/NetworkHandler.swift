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

enum EncryptionKeyIsNull: Error {case null}

class NetworkHandler: RequestAdapter, RequestRetrier
{
    var isEncrypt: Bool = true // 是否需要加密请求体数据
    
    private typealias RefreshCompletion = (_ succeeded: Bool, _ aes_key: String?, _ aes_iv: String?, _ token: String?) -> Void
    private typealias AutoLoginCompletion = (_ succeeded: Bool, _ user:AppUser?) -> Void
    
    private let sessionManager: SessionManager = {
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = SessionManager.defaultHTTPHeaders
        return SessionManager(configuration: configuration)
    }()
    
    private let tokenLock = NSLock()
    private var isTokenRefreshing = false
    private var tokenRequestsToRetry: [RequestRetryCompletion] = []
    
    private let loginLock = NSLock()
    private var isAutoLogining = false
    private var loginRequestsToRetry: [RequestRetryCompletion] = []
    
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
        tokenLock.lock() ;
        loginLock.lock() ;
        defer { tokenLock.unlock() }
        defer { loginLock.unlock() }
        
        if error is EncryptionKeyIsNull
        {
            // 如果错误是加密 key 为空，则需要获取加密 key
            doRefreshTokens(completion)
            return
        }
        // 401 表示加密 key 不合法 需要重新获取，需要与服务器一致
        if let response = request.task?.response as? HTTPURLResponse
        {
            if response.statusCode == RSC_SIGN_ERROR || response.statusCode == RSC_ENCRYPT_KEY_IS_NULL
            {
                // 签名错误 重新获取加解密Key
                #if DEBUG
                    ANT_LOG_WARN("⚠️⚠️⚠️签名错误 重新获取加解密Key")
                #endif
                doRefreshTokens(completion)
            }
            else if response.statusCode == RSC_NO_LOGIN || response.statusCode == RSC_LOGIN_EXPIRED
            {
                // 未登录或者登录过期 如果本地存在用户自动登录密钥 则进行自动登录
                #if DEBUG
                    ANT_LOG_ERROR("⚠️⚠️⚠️未登录或者登录过期 如果本地存在用户自动登录密钥 则进行自动登录")
                #endif
                
                if let user = UserCenter.currentUser()
                {
                    doAutoLogin(user.user_ids, user.auto_login_secret, completion)
                }else{
                    completion(false, 0.0)
                }
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
        tokenRequestsToRetry.append(completion)
        
        if !isTokenRefreshing {
            refreshTokens { [weak self] succeeded, aes_key, aes_iv, token in
                guard let strongSelf = self else { return }
                
                strongSelf.tokenLock.lock() ; defer { strongSelf.tokenLock.unlock() }
                
                if let key = aes_key, let iv = aes_iv, let tk = token {
                    NetworkCipher.shared.set(aes_key: key, aes_iv: iv, token: tk)
                    #if DEBUG
                        ANT_LOG_INFO("\n❤️❤️❤️密钥获取成功:\naes_key:\(key) \naes_iv:\(iv) \ntoken:\(tk)")
                    #endif
                }
                
                strongSelf.tokenRequestsToRetry.forEach { $0(succeeded, 0.0) }
                strongSelf.tokenRequestsToRetry.removeAll()
            }
        }
    }
    
    // MARK: - Private - Refresh Tokens
    private func refreshTokens(completion: @escaping RefreshCompletion) {
        guard !isTokenRefreshing else { return }
        
        isTokenRefreshing = true
        
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
                
                guard let decodedData = OpenSSLUtil.rsaDecode(responseData) else
                {
                    completion(false, nil, nil, nil)
                    return
                }
                
                let json = JSON(data: decodedData)
                
                if json["ret"].intValue != RSC_OPERATION_SUCCESS
                {
                    completion(false, nil, nil, nil)
                    return
                }
                
                 guard let key = json["data"]["responsedata"]["aes_key"].string ,let iv = json["data"]["responsedata"]["aes_iv"].string, let token = json["data"]["responsedata"]["token"].string else {
                    completion(false, nil, nil, nil)
                    return
                }
                
                completion(true, key, iv, token)
                
                strongSelf.isTokenRefreshing = false
        }
    }
    
    private func autoLogin(_ user_ids:String, _ auto_login_secret:String, _ completion: @escaping AutoLoginCompletion) {
        guard !isAutoLogining else { return }
        
        isAutoLogining = true
        
        let param: [String : Any] = [
            "user_ids":user_ids,
            "auto_login_secret":auto_login_secret
        ];
        
        sessionManager.request(API(service: API_USER_AUTOSIGN), method: .post, parameters: param, encoding: JSONEncoding.default)
            .responseData{[weak self] (dataResponse) in
                
                guard let strongSelf = self else { return }
                
                // 是否有错误
                if dataResponse.result.isFailure
                {
                    completion(false, nil)
                    return
                }
                
                guard let responseData = dataResponse.data, responseData.count > 0 else
                {
                    completion(false, nil)
                    return
                }
                
                guard let key = NetworkCipher.shared.aes_key, let iv = NetworkCipher.shared.aes_iv else{
                    completion(false, nil)
                    return
                }
                
                guard let decodedData = OpenSSLUtil.aes_256_decrypt(responseData, key: key, iv: iv) else
                {
                    completion(false, nil)
                    return
                }
                
                let json = JSON(data: decodedData)
                
                if json["ret"].intValue != RSC_OPERATION_SUCCESS
                {
                    completion(false, nil)
                    return
                }
                
                let appUser = AppUser(json: json["data"]["responsedata"]["user_info"])
                
                if String.isBlankOrNil(sourceS: appUser.user_ids)
                {
                    completion(false, nil)
                    return
                }
                
                completion(true, appUser)
                
                strongSelf.isAutoLogining = false
        }
    }
    
    private func doAutoLogin(_ user_ids:String, _ auto_login_secret:String, _ completion: @escaping RequestRetryCompletion)
    {
        loginRequestsToRetry.append(completion)
        
        if !isAutoLogining {
            
            autoLogin(user_ids, auto_login_secret, {[weak self] (succeeded, appUser) in
              
                guard let strongSelf = self else { return }
                
                strongSelf.loginLock.lock() ; defer { strongSelf.loginLock.unlock() }
                
                if let user = appUser {
                    
                    UserCenter.saveUser(user)
                    
                    #if DEBUG
                        ANT_LOG_INFO("\n❤️❤️❤️自动登录成功")
                    #endif
                }
                
                strongSelf.loginRequestsToRetry.forEach { $0(succeeded, 0.0) }
                strongSelf.loginRequestsToRetry.removeAll()
            })
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
        
        if let body = OpenSSLUtil.aes_256_encrypt(originBody, key: aes_key, iv: aes_iv)
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
                        if let decodedData = OpenSSLUtil.aes_256_decrypt(bodyData, key: key, iv: iv)
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
