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

func NC_POST(_ target: NSObject) -> NetworkClient
{
    return NetworkClient(target: target, method: .http_post)
}

func NC_GET(_ target: NSObject) -> NetworkClient
{
    return NetworkClient(target: target, method: .http_get)
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
    case none = "none"         //无需解密
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
    /*
    var successFunction: Selector?
    var failFunction: Selector?
     */
    
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
    /*
    func send(method:NetworkRequestMethod, params:[String : Any]?, url:String, successFunction: Selector, failFunction: Selector ) -> NSNumber? {
        self.message.requestUrl = url
        self.message.requestData = params
        self.successFunction = successFunction
        self.failFunction = failFunction
        return self.send()
    }
     */
    
    func send(data:Data, url:String, successBlock:@escaping NetworkSuccessBlock, failBlock:@escaping NetworkFailBlock ) -> NSNumber? {
        self.message.requestUrl = url
        self.message.requestData = data
        self.successBlock = successBlock
        self.failBlock = failBlock
        return self.send()
    }
    
    fileprivate func send() -> NSNumber?
    {
        switch self.method {
        case .http_post:
            self.task = self.POST()
        case .http_get:
            self.task = self.GET()
        }
        return self.clientId
    }
    
    fileprivate func POST() -> Request? {
        let networkHandler = NetworkHandler.shared
        networkHandler.isEncrypt = isEncrypted()
        let manager = SessionManager.myDefaultSessionManager
        manager.adapter = networkHandler
        manager.retrier = networkHandler
        
        let url = URL(string: self.message.requestUrl!)!
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        
        if let jsonParam: [String : Any] = self.message.requestData as? [String : Any]
        {
            do {
                urlRequest.httpBody = try JSONSerialization.data(withJSONObject: jsonParam, options: [])
            } catch {
                #if DEBUG
                    ANT_LOG_NETWORK_ERROR("JSONSerialization Error")
                #endif
            }
        }
        else if let dataParam: Data = self.message.requestData as? Data
        {
            urlRequest.httpBody = dataParam
        }
        
        let request = manager.request(urlRequest).responseData
            {[weak self] (dataResponse) in
                
                //debugPrint(dataResponse)
                
                guard let strongSelf = self else { return }
                
                strongSelf.doCommonResponse(dataResponse: dataResponse)
        }
        
        //debugPrint(request)
        
        return request
    }
    
    fileprivate func GET() -> Request? {
        
        let networkHandler = NetworkHandler.shared
        networkHandler.isEncrypt = isEncrypted()
        let manager = SessionManager.myDefaultSessionManager
        manager.adapter = networkHandler
        manager.retrier = networkHandler
        
        let url = URL(string: self.message.requestUrl!)!
        var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false)
        if let jsonParam: [String : Any] = self.message.requestData as? [String : Any]
        {
            var queryItems = [URLQueryItem]()
            
            jsonParam.enumerated().forEach({ (offset, element) in
                let queryItem = URLQueryItem(name: element.key, value: "\(element.value)")
                queryItems.append(queryItem)
            })
            if urlComponents?.queryItems == nil {
                urlComponents?.queryItems = queryItems
            }else{
                urlComponents?.queryItems! += queryItems
            }
        }
        
        var urlRequest = URLRequest(url: urlComponents!.url!)
        urlRequest.httpMethod = "GET"
        self.message.requestUrl = urlRequest.url?.absoluteString
        
        let request = manager.request(urlRequest).responseData
            {[weak self] (dataResponse) in
                
                //debugPrint(dataResponse)
                
                guard let strongSelf = self else { return }
                
                strongSelf.doCommonResponse(dataResponse: dataResponse)
        }
        
        //debugPrint(request)
        
        return request
    }
    
    fileprivate func doOperationData(_ decodedData:Data, dataResponse: DataResponse<Data>)
    {
        #if DEBUG
            debug_log_response(decodedData: decodedData, dataResponse: dataResponse)
        #endif
        
        let json = JSON(data: decodedData)
        
        // 设置响应数据
        self.message.responseJson = json
        
        let ret = json["ret"].intValue
        
        if ret == RSC_OPERATION_SUCCESS
        {
            if json["data"]["state"].boolValue
            {
                // 设置最后一次接口操作时间
                NetworkClient.setSessionTime(Date().timeIntervalSince1970)
                // 操作成功
                self.success()
            }
            else{
                // 操作失败
                let code = json["data"]["code"].intValue
                let msg = json["msg"].stringValue
                self.message.networkError = .operationError(code: code, reason: msg)
                self.failure()
            }
        }
        else{
            let msg = json["msg"].stringValue
            self.message.networkError = .operationError(code: ret, reason: msg)
            self.failure()
        }
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
            self.message.networkError = .network(error: dataResponse.result.error)
            self.failure()
            
            #if DEBUG
                ANT_LOG_NETWORK_ERROR("网络错误 \(String(describing: self.message.requestUrl))\nresponse error is:\n\(SAFE_STRING(dataResponse.result.error?.localizedDescription))")
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
                    self.message.networkError = .operationError(code: -1, reason: "响应不合法")
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
                    self.message.networkError = .operationError(code: -1, reason: "响应不合法")
                    self.failure()
                }else{
                    self.doOperationData(responseData, dataResponse: dataResponse)
                }
            }
        }
        else{
            // 响应体没有数据
            self.message.networkError = .operationError(code: -1, reason: "未知数据")
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
        if let decodedData = OpenSSLUtil.rsaDecode(dataResponse.data!)
        {
            self.doOperationData(decodedData, dataResponse: dataResponse)
        }
        else{
            // 数据揭秘失败
            self.message.networkError = .operationError(code: -1, reason: "数据解密失败")
            self.failure()
            
            #if DEBUG
                debug_log_decrypt_error(dataResponse: dataResponse)
            #endif
        }
    }
    
    // 使用AES-256解密并处理数据
    func doProcessAESResponse(dataResponse: DataResponse<Data>)
    {
        if let key = NetworkCipher.shared.aes_key, let iv = NetworkCipher.shared.aes_iv
        {
            if let decodedData = OpenSSLUtil.aes_256_decrypt(dataResponse.data!, key:key, iv: iv)
            {
                self.doOperationData(decodedData, dataResponse: dataResponse)
            }
            else{
                // 数据揭秘失败
                self.message.networkError = .operationError(code: -1, reason: "数据解密失败")
                self.failure()
                
                #if DEBUG
                    debug_log_decrypt_error(dataResponse: dataResponse)
                #endif
            }
        }
        else{
            // 数据揭秘失败
            self.message.networkError = .operationError(code: -1, reason: "数据解密失败")
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
