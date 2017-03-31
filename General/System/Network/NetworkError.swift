//
//  NetworkError.swift
//  Pods
//
//  Created by 刘伟 on 16/7/1.
//
//

import UIKit

//enum NetworkErrorType {
//    
//    // 访问网络时 返回的网络错误 比如404，超时等
//    case httpError(code: Int, description: String)
//    
//    // 访问接口时 服务器返回的错误 错误代码由服务器定义 NetworkServerCode.swift
//    //case serverError(ret: NetworkResponseCode, msg: String)
//    // 数据解密错误
//    case decryptDataError(msg: String)
//    // 返回的数据未知
//    case responseDataError(msg: String)
//    // 调用接口操作失败 
//    case operationError(code: Int, msg: String)
//}

enum BackendError: Error {
    case network(error: Error?)
    case operationError(code:Int, reason: String)
}
