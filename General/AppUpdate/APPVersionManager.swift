//
//  APPVersionManager.swift
//  BingLiYun
//
//  Created by 刘伟 on 30/11/2016.
//  Copyright © 2016 上海凌晋信息技术有限公司. All rights reserved.
//

import UIKit

class APPVersionManager: NSObject {

    fileprivate var updateInfoModel: APPUpdateInfoModel?
    
    fileprivate var isCheckNewVersionFailed = false
    
    fileprivate var checkupdateAlertView: AlertView?
    
    fileprivate let reachability = Reachability()!
    
    fileprivate var isUserCanceled = false
    
    // 单例
    static let sharedInstance = APPVersionManager()
    
    private override init() {
        super.init()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.reachabilityChanged),name: ReachabilityChangedNotification,object: reachability)
        do{
            try reachability.startNotifier()
        }catch{
            #if DEBUG
                ANT_LOG_ERROR("不能启动网络监听:\(error.localizedDescription)")
            #endif
        }
    }
    
    @objc fileprivate func reachabilityChanged(note: NSNotification) {
        
        let reachability = note.object as! Reachability
        
        if reachability.isReachable {
            #if DEBUG
                if reachability.isReachableViaWiFi {
                    ANT_LOG_INFO("Reachable via WiFi")
                } else {
                    ANT_LOG_INFO("Reachable via Cellular")
                }
            #endif
            if self.isCheckNewVersionFailed
            {
                self.checkAppHasNewVersion()
            }
        } else {
            #if DEBUG
                ANT_LOG_INFO("Network not reachable")
            #endif
            
        }
    }
    
    func checkAppHasNewVersion()
    {
        if isUserCanceled
        {
            // 用户取消了更新 则本次不再提示
            return
        }
        
        guard let info = Bundle.main.infoDictionary else {
            return
        }
        
        guard let appBuild = info[kCFBundleVersionKey as String] as? String else {
            return
        }
        
        if let _ = self.updateInfoModel
        {
            self.showUpdateView(appBuild: appBuild)
            return
        }
        
        
        
        let param = [
            "code":"\(appBuild)",
            "client_type":"ios"
        ];
        
        _ = NC_POST(self).send(params: param as [String : AnyObject]?, url: API(service: API_SYSTEM_GETVERSION), successBlock: { (message) in
            
            self.isCheckNewVersionFailed = false
            
            self.updateInfoModel = APPUpdateInfoModel(json: message.responseJson["data"]["responsedata"])
            
            DispatchQueue.main.async {
                self.showUpdateView(appBuild: appBuild)
            }
            
        }) { (message) in
            self.isCheckNewVersionFailed = true
        }
    }
    
    fileprivate func showUpdateView(appBuild:String)
    {
        if self.checkupdateAlertView != nil { return }
        
        guard let updateInfo = self.updateInfoModel else { return }
        
        if Int(appBuild)! >= updateInfo.code
        {
            return
        }
        
        guard let url = URL(string: updateInfo.app_url) else {
            return
        }
        
        switch updateInfo.is_force {
            case .optional:
                let cancel = AlertViewButtonItem(inLabel: "稍后下载", inAction: {
                    self.checkupdateAlertView = nil
                    self.isUserCanceled = true
                })
                let ok = AlertViewButtonItem(inLabel: "下载新版本", inAction: {
                    if UIApplication.shared.canOpenURL(url)
                    {
                        if #available(iOS 10.0, *) {
                            UIApplication.shared.open(url, options: [:], completionHandler: nil)
                        } else {
                            // Fallback on earlier versions
                            UIApplication.shared.openURL(url)
                        }
                    }
                    self.checkupdateAlertView = nil
                })
                self.checkupdateAlertView = AlertView(title: "有新版本更新(\(updateInfo.version))", message: updateInfo.instruction, cancelButtonItem: cancel, otherButtonItems: ok)
            case .forcing:
                let ok = AlertViewButtonItem(inLabel: "下载新版本", inAction: {
                    if UIApplication.shared.canOpenURL(url)
                    {
                        if #available(iOS 10.0, *) {
                            UIApplication.shared.open(url, options: [:], completionHandler: nil)
                        } else {
                            // Fallback on earlier versions
                            UIApplication.shared.openURL(url)
                        }
                    }
                    self.checkupdateAlertView = nil
                })
                self.checkupdateAlertView = AlertView(title: "有新版本更新(\(updateInfo.version))", message: updateInfo.instruction, cancelButtonItem: ok, otherButtonItems: nil)
        }
        
        self.checkupdateAlertView?.show()
    }
}
