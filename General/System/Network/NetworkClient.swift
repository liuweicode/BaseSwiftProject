//
//  NetworkClient.swift
//  Pods
//
//  Created by 刘伟 on 16/6/30.
//
//

import UIKit
import Alamofire
import SwiftyJSON

func NC_POST(_ target: NSObject, _ method: NetworkRequestMethod = .http_post) -> NetworkClient
{
    return NetworkClient(target: target, method: method)
}

enum NetworkCallbackType
{
    // 指定接收者及回调
    case target
    // 实现协议函数接收回调
    case delegate
    // block方式接收回调
    case block
}

enum NetworkDataEncryptType : String
{
    case rsa_2048 = "RSA-2048"
    case aes_256 = "AES-256"
    case none = "none" //无需解密
}

enum NetworkRequestMethod : Int {
    case http_post, http_get
}

typealias NetworkSuccessBlock = (_ message:NetworkMessage) -> Void
typealias NetworkFailBlock = (_ message:NetworkMessage) -> Void

var clientNO:UInt = 1

class NetworkClient : NSObject {
    
    // 请求类型 POST / GET
    var method:NetworkRequestMethod
    
    // 超时时间
    //let networkTimeout:TimeInterval = 30
    
    // 请求任务
    var task:Request?
    
    // 当前任务标识
    var clientId:NSNumber
    
    // 网络数据封装
    lazy var message = NetworkMessage()
    
    // 回调者
    fileprivate var target:NSObject
    
    // 回调方式
    fileprivate var callbackType: NetworkCallbackType = .delegate
    
    // Block 方式回调
    var successBlock:NetworkSuccessBlock?
    var failBlock:NetworkFailBlock?
    
    // Selector 方式回调
    var successFunction: Selector?
    var failFunction: Selector?
    
    init(target obj:NSObject, method meth: NetworkRequestMethod = .http_post) {
        target = obj
        method = meth
        clientNO = clientNO + 1
        clientId = NSNumber(value: clientNO as UInt)
        super.init()
        NetworkClientManager.shared.addClient(client: self, forClientId: clientId)
    }
    
    
    /// 发送http请求, 使用block方式进行回调
    ///
    /// - Parameters:
    ///   - method: 请求方式 POST／GET
    ///   - params: 请求参数
    ///   - url: 请求URL
    ///   - successBlock: 成功回调
    ///   - failBlock: 失败回调
    /// - Returns: 当前任务标识ID，可用于取消请求
    func send(params:[String : Any]?, url:String, successBlock:@escaping NetworkSuccessBlock, failBlock:@escaping NetworkFailBlock ) -> NSNumber? {
        self.message.requestUrl = url
        self.message.requestData = params
        self.successBlock = successBlock
        self.failBlock = failBlock
        return self.send()
    }
    
    
    /// 发送http请求, 使用Selector方式进行回调
    ///
    /// - Parameters:
    ///   - method: 请求方式 POST／GET
    ///   - params: 请求参数
    ///   - url: 请求URL
    ///   - successFunction: 成功回调
    ///   - failFunction: 失败回调
    /// - Returns: 当前任务标识ID，可用于取消请求
    func send(method:NetworkRequestMethod, params:[String : Any]?, url:String, successFunction: Selector, failFunction: Selector ) -> NSNumber? {
        self.message.requestUrl = url
        self.message.requestData = params
        self.successFunction = successFunction
        self.failFunction = failFunction
        return self.send()
    }
    
    func uploadFile(data:Data, url:String, successBlock:@escaping NetworkSuccessBlock, failBlock:@escaping NetworkFailBlock ) -> NSNumber? {
        self.message.requestUrl = url
        self.message.requestData = data
        self.successBlock = successBlock
        self.failBlock = failBlock
        return self.upload()
    }
    
    fileprivate func send() -> NSNumber?
    {
        #if DEBUG
            ANT_LOG_INFO("\n>>>>>> 请求接口:\(SAFE_STRING(self.message.requestUrl))")
        #endif
        // 请求密钥接口直接发送请求
        if SAFE_STRING(self.message.requestUrl) == API(service: API_SYSTEM_GETAESKEY){
            #if DEBUG
                ANT_LOG_INFO("\n>>>>>> 请求的是获取密钥接口，所以不需要验证本地密钥，直接发送请求")
            #endif
            return self.doSend()
        }
        
        #if DEBUG
            ANT_LOG_INFO("\n>>>>>> 验证本地是否已经存在密钥")
        #endif
        
        // 其他接口，先判断本地有没有密钥，如果有，直接发送请求
        if NetworkCipher.sharedInstance.aes_key != nil && NetworkCipher.sharedInstance.aes_iv != nil && NetworkCipher.sharedInstance.token != nil
        {
            #if DEBUG
                ANT_LOG_INFO("\n>>>>>> 本地已经存在密钥 直接发送请求")
            #endif
            
            return self.doSend()
        }
        
        #if DEBUG
            ANT_LOG_INFO("\n>>>>>> 本地没有密钥 向服务器获取...")
        #endif
        // 如果没有则先去请求密钥
        self.doRequestKeys(successBlock: { (message) in
            // 继续之前的请求
            #if DEBUG
                ANT_LOG_INFO("\n>>>>>> 密钥获取成功 继续发送之前的请求:\(self.message.requestUrl)")
            #endif
            _ = self.doSend()
            
        }, failBlock: {(message)in
            NetworkClientManager.shared.removeClientWithId((self.clientId))
            // 获取密钥失败
            #if DEBUG
                ANT_LOG_INFO("\n>>>>>> 密钥获取失败 返回上层回调, error:\(message.networkError)")
            #endif
            // 删除用户信息
            UserCenter.removeUser()
            self.message = message
            // 提示用户登录
            self.message.networkError = .serverError(ret:.other, msg:"网络错误")
            self.failure()
        })
        
        return self.clientId
    }
    
    fileprivate func doSend() -> NSNumber?
    {
        switch self.method {
        case .http_post:
            self.task = self.POST()
        case .http_get:
            self.task = self.GET()
        }
        return self.clientId
    }
    
    fileprivate func getRequestHeaders() -> HTTPHeaders
    {
        // 时间戳
        let timestamp = String(Int(Date().timeIntervalSince1970))
        // 随机数
        let nonce = NetworkUtils.generateRandNumber()
        // 签名
        let signature = NetworkUtils.generateSignature(timestamp, random: nonce)
        
        var headers = HTTPHeaders()
        headers["X-LJ-T"] = timestamp
        headers["X-LJ-N"] = nonce
        headers["X-LJ-SIGN"] = signature
        
//        headers["timestamp"] = timestamp
//        headers["nonce"] = nonce
//        headers["signature"] = signature
        headers["Content-Type"] = "application/octet-stream"
        
        #if DEBUG
            ANT_LOG_INFO("headers: => \(headers)")
        #endif
        return headers
    }
    
    fileprivate func POST() -> Request? {
        
        let manager = NetworkSessionManager.shared.manager
        
        let params = self.message.requestData as? [String : Any]
        
        let method = HTTPMethod.post
        
        let encoding = NetworkRequestDataEncoding()
        
        return manager.request(self.message.requestUrl!,
                               method: method,
                               parameters: params,
                               encoding: encoding,
                               headers: getRequestHeaders()).responseData
            {[weak self] (dataResponse) in
            
                guard let strongSelf = self else { return }
                
                strongSelf.doCommonResponse(dataResponse: dataResponse)
            }
    }
    
    fileprivate func GET() -> Request? {
        // TODO enhancement
        return nil
    }
    
    fileprivate func doOperationData(_ decodedData:Data, dataResponse: DataResponse<Data>)
    {
        #if DEBUG
            debug_log_response(decodedData: decodedData, dataResponse: dataResponse)
        #endif
        
        let json = JSON(data: decodedData)
        
        // 设置响应数据
        self.message.responseJson = json
        
        let ret = NetworkResponseCode(rawValue:json["ret"].intValue) ?? .other
        
        switch ret
        {
        // 操作成功
        case .operation_success:
            if json["data"]["state"].boolValue
            {
                // 设置最后一次接口操作时间
                NetworkClient.setSessionTime(Date().timeIntervalSince1970)
                
                //self.message.responseData =
                
                // 操作成功
                self.success()
            }else{
                // 操作失败
                let code = json["data"]["code"].intValue
                let msg = json["msg"].stringValue
                self.message.networkError = .operationError(code: code, msg:msg)
                self.failure()
            }
        // 未签名 | 签名错误 | 未登录 | 登录过期 | 服务器加解密key失效
        case .unsigned, .signature_error, .not_logged_in, .login_state_expired, .encryption_key_invalid:
            // 判断本地有没有登录 -> 取密钥 -> 自动登录 -> 再次请求原先请求的接口
            //                          -> 到登录界面
            
            #if DEBUG
                let msg = json["msg"].stringValue
                ANT_LOG_NETWORK_ERROR("\(msg)")
            #endif
            
            //判断本地是否有登录信息
            if let loginUser = UserCenter.currentUser()
            {
                self.doRequestKeys(successBlock: { (message) in
                    // 自动登录
                    self.doAutoLogin(loginUser.user_ids, auto_login_secret: loginUser.auto_login_secret)
                }, failBlock: { (message) in
                    // 获取密钥失败
                    #if DEBUG
                        ANT_LOG_NETWORK_ERROR("自动获取密钥失败 errorcode:\(message.networkError)")
                    #endif
                    // 删除用户信息
                    UserCenter.removeUser()
                    self.message = message
                    // 提示用户登录
                    self.message.networkError = .serverError(ret:.not_logged_in, msg:"登录失效,请重新登录。")
                    self.failure()
                })
                
            }
            else{
                // 如果登录用户不存在，则直接报错
                let msg = json["msg"].stringValue
                self.message.networkError = .serverError(ret:ret, msg:msg)
                self.failure()
            }
        // 表示已在其他设备授权请重新授权 | 请求非法 | 账号已被禁用 | 其他未知错误
        case .logged_in_on_another_device, .request_invalid, .id_forbidden, .other:
            let msg = json["msg"].stringValue
            self.message.networkError = .serverError(ret:ret, msg:msg)
            self.failure()
        }
        
    }
    
    func doRequestKeys(successBlock:@escaping NetworkSuccessBlock, failBlock:@escaping NetworkFailBlock)
    {
        _ = NC_POST(self.target, self.method).send(params: nil, url: API(service: API_SYSTEM_GETAESKEY), successBlock: { (message) in
            
            NetworkCipher.sharedInstance.aes_key = message.responseJson["data"]["responsedata"]["aes_key"].string
            NetworkCipher.sharedInstance.aes_iv = message.responseJson["data"]["responsedata"]["aes_iv"].string
            NetworkCipher.sharedInstance.token = message.responseJson["data"]["responsedata"]["token"].string
            successBlock(message)
        }) { (message) in
            failBlock(message)
        }
    }
    
    fileprivate func doAutoLogin(_ user_ids:String, auto_login_secret:String)
    {
        let param: [String : Any] = [
            "user_ids":user_ids,
            "auto_login_secret":auto_login_secret
        ];
        
        _ = NC_POST(self.target, self.method).send(params: param, url: API(service: API_USER_AUTOSIGN), successBlock: { (message) in
            
            // 保存用户信息
            let appUser = AppUser(json: message.responseJson["data"]["responsedata"]["user_info"])
            UserCenter.saveUser(appUser)
            
            // 重新发送之前的请求
            #if DEBUG
                ANT_LOG_NETWORK_REQUEST("重新发送之前的请求")
            #endif
            
            _ = NC_POST(self.target, self.method).send(params:self.message.requestData as? [String : Any] , url: self.message.requestUrl!, successBlock: self.successBlock!, failBlock: self.failBlock!)
            
        }) { (message) in
            #if DEBUG
                ANT_LOG_NETWORK_ERROR("自动登录失败errorcode:\(message.networkError)")
            #endif
            // 删除用户信息
            UserCenter.removeUser()
            self.message = message
            // 提示用户登录
            self.message.networkError = .serverError(ret:.not_logged_in, msg:"登录失效,请重新登录。")
            self.failure()
        }
    }
    
    // MARK: Upload
    fileprivate func upload() -> NSNumber?
    {
        switch self.method {
        case .http_post:
            self.task = self.postUpload()
        case .http_get:
            ANT_LOG_NETWORK_ERROR("GET UPLOAD")
        }
        return self.clientId
    }
    
    fileprivate func postUpload() -> Request? {
        
        // 时间戳
        let timestamp = String(Int(Date().timeIntervalSince1970))
        // 随机数
        let nonce = NetworkUtils.generateRandNumber()
        // 签名
        let signature = NetworkUtils.generateSignature(timestamp, random: nonce)
        
        // 请求头信息
        var headers = HTTPHeaders()
        headers["X-LJ-T"] = timestamp
        headers["X-LJ-N"] = nonce
        headers["X-LJ-SIGN"] = signature
        
        
        var bodyData:Data? = nil
        
        if let requestParamData = self.message.requestData as? Data, let key = NetworkCipher.sharedInstance.aes_key, let iv = NetworkCipher.sharedInstance.aes_iv
        {
            bodyData = FSOpenSSL.aes_encrypt(requestParamData as Data, key: key, iv: iv)
        }
        
        if bodyData == nil { bodyData = Data() }
        
        #if DEBUG
            ANT_LOG_NETWORK_REQUEST("Request Upload URL:\(self.message.requestUrl!)\nRequest Headers:\(headers)\nRequest body：\(bodyData)")
        #endif
        
        let manager = NetworkSessionManager.shared.manager
        
        return manager.upload(bodyData!, to: self.message.requestUrl!, method: .post, headers: headers)
            .responseData(completionHandler: {[weak self] (dataResponse) in

                guard let strongSelf = self else { return }
                
                strongSelf.doCommonResponse(dataResponse: dataResponse)
                
            })
    }
    
    fileprivate func success()
    {
        self.successBlock?(self.message)
    }
    
    fileprivate func failure()
    {
        self.failBlock?(self.message)
    }
    
    // 取消请求
    func cancel() {
        self.task?.cancel()
    }
    
    // 获取调用者
    func requestReceive() -> NSObject {
        return self.target
    }

    /**
     设置最后一次会话时间
     
     - parameter time: 时间
     */
    private class func setSessionTime(_ time:TimeInterval)
    {
        UserDefaults.standard.set(time, forKey: "SessionTime")
        UserDefaults.standard.synchronize()
    }
    
    /**
     会话是否失效
     
     - returns: true/false
     */
    private class func isSessionExpired() -> Bool
    {
        let lastTime = UserDefaults.standard.double(forKey: "SessionTime")
        
        let currentTime = Date().timeIntervalSince1970
        
        // 如果小于10分钟，则在有效期内，否则失效
        if currentTime - lastTime < (60 * 10) {
            return false
        }
        
        return true
    }
}

extension NetworkClient
{
    func doCommonResponse(dataResponse: DataResponse<Data>)
    {
        // 是否有错误
        if dataResponse.result.isFailure
        {
            let error = dataResponse.result.error as! NSError
            self.message.networkError = .httpError(code:error.code, description:error.description)
            self.failure()
            
            #if DEBUG
                ANT_LOG_NETWORK_ERROR("网络错误 \(self.message.requestUrl)\nresponse error is:\n\(error.description)")
            #endif
        }
        else{
            // 处理响应结果
            self.doProcessResponse(dataResponse: dataResponse)
        }
        // 最后移除当前请求
        NetworkClientManager.shared.removeClientWithId(self.clientId)
    }
    
    func isEncrypted() -> Bool
    {
        if let url = URL(string: self.message.requestUrl!), let query = url.parseQuery()
        {
            if let encrypt = query["encrypt"] as? String
            {
                if encrypt == "no"
                {
                    return false
                }
            }
        }
        return true
    }
    
    // 处理响应结果
    func doProcessResponse(dataResponse: DataResponse<Data>)
    {
        if let responseData = dataResponse.data, responseData.count > 0
        {
            
            if isEncrypted()
            {
                // 如果是字符串，说明已经报错了
                if let htmlText = String(bytes: responseData, encoding: String.Encoding.utf8)
                {
                    ANT_LOG_NETWORK_ERROR("返回服务器未知数据：\(htmlText)")
                    self.message.networkError = .responseDataError(msg: "响应不合法")
                    self.failure()
                    return
                }
            }
            
            if let encryptType = self.checkEncryptType(dataResponse: dataResponse)
            {
                switch encryptType
                {
                case .rsa_2048:
                    self.doProcessRSAResponse(dataResponse: dataResponse)
                case .aes_256:
                    self.doProcessAESResponse(dataResponse: dataResponse)
                case .none:
                    self.doOperationData(responseData, dataResponse: dataResponse)
                }
            }else{
                if isEncrypted()
                {
                    // Encrypt 不合法
                    self.message.networkError = .responseDataError(msg: "响应不合法")
                    self.failure()
                }else{
                    self.doOperationData(responseData, dataResponse: dataResponse)
                }
            }
        }
        else{
            // 响应体没有数据
            self.message.networkError = .responseDataError(msg: "未知数据")
            self.failure()
        }
    }
    
    // 检查响应头是否合法 返回空说明不合法
    private func checkEncryptType(dataResponse: DataResponse<Data>) -> NetworkDataEncryptType?
    {
        // 获取响应头
        if let responseHeaders = dataResponse.response?.allHeaderFields
        {
            if let encrypt = responseHeaders["Encrypt"] as? String
            {
                // 需要解密数据
                if encrypt == "YES/RSA-2048"
                {
                    return NetworkDataEncryptType.rsa_2048
                }
                else if encrypt == "YES/AES-256"{
                    // 使用AES-256解密
                    return NetworkDataEncryptType.aes_256
                }
                else if encrypt == "NO"{
                    // 无需解密数据
                    return NetworkDataEncryptType.none
                }
                else{
                    // Encrypt 不合法
                    return nil
                }
            }
            else{
                // 响应头里面没有 Encrypt 说明响应不合法
                return nil
            }
        }else{
            // 没有响应头 说明响应不合法
            return nil
        }
    }
    
    // 使用RSA-2048解密并处理数据
    func doProcessRSAResponse(dataResponse: DataResponse<Data>)
    {
        if let decodedData = FSOpenSSL.rsaDecode(dataResponse.data!)
        {
            self.doOperationData(decodedData, dataResponse: dataResponse)
        }
        else{
            // 数据揭秘失败
            self.message.networkError = .decryptDataError(msg:"数据解密失败")
            self.failure()
            
            #if DEBUG
                debug_log_decrypt_error(dataResponse: dataResponse)
            #endif
        }
    }
    
    // 使用AES-256解密并处理数据
    func doProcessAESResponse(dataResponse: DataResponse<Data>)
    {
        if let key = NetworkCipher.sharedInstance.aes_key, let iv = NetworkCipher.sharedInstance.aes_iv
        {
            if let decodedData = FSOpenSSL.aes_decrypt(dataResponse.data!, key:key, iv: iv)
            {
                self.doOperationData(decodedData, dataResponse: dataResponse)
            }
            else{
                // 数据揭秘失败
                self.message.networkError = .decryptDataError(msg:"数据解密失败")
                self.failure()
                
                #if DEBUG
                    debug_log_decrypt_error(dataResponse: dataResponse)
                #endif
            }
        }
        else{
            // 数据揭秘失败
            self.message.networkError = .decryptDataError(msg:"数据解密失败")
            self.failure()
            
            #if DEBUG
                debug_log_decrypt_error(dataResponse: dataResponse)
            #endif
        }
    }
    
    func debug_log_response(decodedData:Data, dataResponse: DataResponse<Data>)
    {
        
        #if DEBUG
            
//            if SAFE_STRING(self.message.requestUrl) == API(service: API_CHARGINGSTATION_STATIONSAROUND)
//                || SAFE_STRING(self.message.requestUrl) == API(service: API_CHARGINGSTATION_STATIONSBYREGION)
//            {
//                ANT_LOG_INFO("不打印信息")
//                return
//            }
            
            
            let responseHeaders: [AnyHashable : Any] = dataResponse.response?.allHeaderFields ?? [AnyHashable : Any]()
            do {
                // 解密后打印到控制台
                let responseDataDicts = try JSONSerialization.jsonObject(with: decodedData, options: .allowFragments)
                let jsonData = try JSONSerialization.data(withJSONObject: responseHeaders, options: .prettyPrinted)
                let responseHeaderDicts = try JSONSerialization.jsonObject(with: jsonData, options: .allowFragments)
                ANT_LOG_NETWORK_RESPONSE("\(self.message.requestUrl!)\nresponse head is:\n\(responseHeaderDicts)\nbody is:\n\(responseDataDicts)")
            } catch {
                ANT_LOG_NETWORK_ERROR(error.localizedDescription)
                if let htmlText = String(bytes: decodedData, encoding: String.Encoding.utf8)
                {
                    ANT_LOG_NETWORK_ERROR("HTML数据是：\(htmlText)")
                }
            }
        #endif
    }
    
    func debug_log_decrypt_error(dataResponse: DataResponse<Data>)
    {
        #if DEBUG
            let responseHeaders: [AnyHashable : Any] = dataResponse.response?.allHeaderFields ?? [AnyHashable : Any]()
            do{
                let responseHeaderJsonData = try JSONSerialization.data(withJSONObject: responseHeaders, options: .prettyPrinted)
                let responseHeaderDicts = try JSONSerialization.jsonObject(with: responseHeaderJsonData, options: .allowFragments)
                ANT_LOG_NETWORK_ERROR("数据解密失败 \(self.message.requestUrl)\nresponse head is:\n\(responseHeaderDicts)\nbody is:\n\(dataResponse.data)")
            } catch {
                ANT_LOG_NETWORK_ERROR(error.localizedDescription)
            }
        #endif
    }
    
   

}
