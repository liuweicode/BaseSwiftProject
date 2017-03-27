//
//  NetworkServerCode.swift
//  DaQu
//
//  Created by 刘伟 on 9/1/16.
//  Copyright © 2016 上海凌晋信息技术有限公司. All rights reserved.
//

import UIKit

enum NetworkResponseCode: Int
{
    case operation_success = 200       // 操作成功
    case other = -1                    // 其他
    case request_invalid = 400;        // 请求非法
    case unsigned = 401;               // 未签名
    case signature_error = 402;        // 签名错误
    case not_logged_in = 403;          // 未登录
    case id_forbidden = 404;           // 账号已被禁用
    case login_state_expired = 405;          // 表示登录过期
    case logged_in_on_another_device = 406;  // 表示已在其他设备授权 请重新授权
    case encryption_key_invalid = 407; // 服务器当前Session中aes_key|aes_iv没有 说明失效了
}


let NETWORK_RESPONSE_STATUS_CODE = 401 
