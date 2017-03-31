//
//  NetworkServerCode.swift
//  DaQu
//
//  Created by 刘伟 on 9/1/16.
//  Copyright © 2016 上海凌晋信息技术有限公司. All rights reserved.
//

import UIKit

/**
 * Define Response HTTP Status Code
 */
let RSC_OPERATION_SUCCESS = 200    // 操作成功
let RSC_BAD_REQUEST = 400          // 请求非法
let RSC_NOT_SIGN = 401             // 未签名
let RSC_SIGN_ERROR = 402           // 签名错误 （APP重新获取Key）
let RSC_ENCRYPT_KEY_IS_NULL = 403  // 服务器签名Key已失效（APP重新获取Key）

let RSC_NO_LOGIN = 404      // 未登录（若本地存在用户信息，则APP重新自动登录）
let RSC_LOGIN_EXPIRED = 405 // 登录过期（若本地存在用户信息，则APP重新自动登录）

let RSC_LOGIN_OTHER_DEVICE = 406 // 表示已在其他设备授权 请重新授权（APP重新弹出登录界面）
