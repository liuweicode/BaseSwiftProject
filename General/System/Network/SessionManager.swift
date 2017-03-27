//
//  SessionManager.swift
//  JiChongChong
//
//  Created by 刘伟 on 3/24/17.
//  Copyright © 2017 上海凌晋信息技术有限公司. All rights reserved.
//

import UIKit
import Alamofire

extension Alamofire.SessionManager
{

    static let myDefaultSessionManager: SessionManager = {
       
        let serverTrustPolicies: [String: ServerTrustPolicy] =
            [  NetworkURLConfig.shared.API_HOST: .performDefaultEvaluation(validateHost: true),
               "insecure.expired-apis.com": .disableEvaluation
        ]
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = SessionManager.defaultHTTPHeaders
        configuration.httpMaximumConnectionsPerHost = 10
        configuration.timeoutIntervalForRequest = 30
        configuration.httpShouldSetCookies = true
        configuration.httpCookieStorage = HTTPCookieStorage.shared
        return Alamofire.SessionManager(configuration: configuration, serverTrustPolicyManager: ServerTrustPolicyManager(policies: serverTrustPolicies))
    }()

}

