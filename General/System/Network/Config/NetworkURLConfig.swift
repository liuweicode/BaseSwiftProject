//
//  NetworkURLConfig.swift
//  DaQu
//
//  Created by 刘伟 on 9/1/16.
//  Copyright © 2016 上海凌晋信息技术有限公司. All rights reserved.
//

import UIKit

//let API_ENCRYPTED = false

// API接口
func API(service action:String, notEncrypt notencrypt: Bool = false, isPrintSql printSql:Bool = false) -> String
{
    var api = NetworkURLConfig.shared.apiPathOfRelativeString(action)
    
    // 打印sql语句
    if printSql
    {
        api +=  "&__sql__=1"
    }
    // 不加密
    if notencrypt {
        api += "&encrypt=no"
    }
    
    return  api
}

class NetworkURLConfig: NSObject {
    
    // https / http
    var API_PROTOCPL: String!
    // 主机地址
    var API_HOST: String!
    // 接口地址
    var API_METHOD_PATH: String!
    
    // 帮助与支持
    var html_help_doc: String!
    // 问题反馈
    var html_feedback: String!
    // 关于冰梨云
    var html_about: String!
    
    // 单例类
    static let shared = NetworkURLConfig()
    
    // 私有化init方法
    private override init() {
        super.init()
        
        #if APPSTORE
            /****************** 正式线上环境禁止修改 !!!!!!! **************************/
            changeApiEnvironmentToPRO()
        #else
            #if UAT
                changeApiEnvironmentToUAT()
            #else
                #if SIT
                    changeApiEnvironmentToSIT()
                #else
                    changeApiEnvironmentToDEV()
                #endif
            #endif
        #endif
    }
    
    // API接口地址
    func apiPathOfRelativeString(_ path:String) -> String {
        return API_PROTOCPL + API_HOST + API_METHOD_PATH + path + "&client=ios"
    }
    
    // 切换到开发环境
    func changeApiEnvironmentToDEV()
    {
        ANT_LOG_INFO("开发环境")
        // 协议
        API_PROTOCPL = "http://"
        // 主机地址
        API_HOST = "192.168.199.228"
        // 接口地址
        API_METHOD_PATH = "/jichongchong/Public/v1/index.php?service="
        
        // 帮助与支持
        html_help_doc = "http://192.168.199.228/jichongchong/Public/v1/help.php"
        // 问题反馈
        html_feedback = "http://192.168.199.228/jichongchong/Public/v1/feedback.php"
        // 关于冰梨云
        html_about = "http://192.168.199.228/jichongchong/Public/v1/about.php"

    }
    
    // 切换到SIT环境
    func changeApiEnvironmentToSIT()
    {
        ANT_LOG_INFO("SIT环境")
        // 协议
        API_PROTOCPL = "http://"
        // 主机地址
        API_HOST = "api.jcc.linkim.com.cn"
        // 接口地址
        API_METHOD_PATH = "/Public/v1/index.php?service="
        
        // 帮助与支持
        html_help_doc = "http://api.jcc.linkim.com.cn/Public/v1/help.php"
        // 问题反馈
        html_feedback = "http://api.jcc.linkim.com.cn/Public/v1/feedback.php"
        // 关于冰梨云
        html_about = "http://api.jcc.linkim.com.cn/Public/v1/about.php"
    }
    
    // 切换到UAT环境
    func changeApiEnvironmentToUAT()
    {
        ANT_LOG_INFO("UAT环境")
        // 协议
        API_PROTOCPL = "http://"
        // 主机地址
        API_HOST = "api.jcc.linkim.com.cn"
        // 接口地址
        API_METHOD_PATH = "/Public/v1/index.php?service="
        
        // 帮助与支持
        html_help_doc = "http://api.jcc.linkim.com.cn/Public/v1/help.php"
        // 问题反馈
        html_feedback = "http://api.jcc.linkim.com.cn/Public/v1/feedback.php"
        // 关于冰梨云
        html_about = "http://api.jcc.linkim.com.cn/Public/v1/about.php"
    }
    
    // 切换到生产环境
    func changeApiEnvironmentToPRO()
    {
        ANT_LOG_INFO("生产环境")
        // 协议
        API_PROTOCPL = "http://"
        // 主机地址
        API_HOST = "api.jcc.linkim.com.cn"
        // 接口地址
        API_METHOD_PATH = "/Public/v1/index.php?service="
        
        // 帮助与支持
        html_help_doc = "http://api.jcc.linkim.com.cn/Public/v1/help.php"
        // 问题反馈
        html_feedback = "http://api.jcc.linkim.com.cn/Public/v1/feedback.php"
        // 关于冰梨云
        html_about = "http://api.jcc.linkim.com.cn/Public/v1/about.php"
    }
    
    
}
