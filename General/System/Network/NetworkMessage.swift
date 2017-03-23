//
//  NetworkMessage.swift
//  Pods
//
//  Created by 刘伟 on 16/6/30.
//
//

import UIKit
import SwiftyJSON

// 网络数据封装
class NetworkMessage: NSObject {

    /************ 请求数据 ************/
 
    // 请求地址
    var requestUrl: String?

    
    // 请求参数
    var requestData: Any?
    
//    // 请求数据 一般用在图片上传中
//    var paramData: Data?
//    
//    // 请求体数据
//    var data:Data?
    
    /************ 响应的数据 ************/
 
    //lazy var response = NetworkResponse()
    
    // response body 数据
    private var _responseJson: JSON?
    
    var responseJson: JSON
    {
        set{
            _responseJson = newValue
        }
        get{
            if _responseJson == nil
            {
                _responseJson = JSON(data: Data())
            }
            return _responseJson!
        }
    }
    
    var responseData: Data?
    
    
    // 错误
    var networkError: NetworkErrorType?
    
    // 用户自定义数据,与网络数据无关
    var userInfo: Any?
    
    // 数据标识
    var tag: NSInteger?
    
    
}
