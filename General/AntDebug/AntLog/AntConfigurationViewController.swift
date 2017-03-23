//
//  AntConfigurationViewController.swift
//  SKFinance
//
//  Created by 刘伟 on 2/22/17.
//  Copyright © 2017 上海凌晋信息技术有限公司. All rights reserved.
//

import UIKit
import SnapKit

class AntConfigurationViewController: UIViewController {

    let textView: UITextView = {
        let tv = UITextView()
        tv.font = UIFont.systemFont(ofSize: 14)
        return tv
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setNavigationItem(withLeftObject: nil, rightObject: "打开调试", titleObject: "编译信息")
        
        self.view.addSubview(textView);
        textView.snp.makeConstraints { (make) in
            make.edges.equalTo(self.view)
        }
        
        var appInfo = "";
        
        var environment = ""
        
        #if DEBUG
            environment += " Debug"
        #endif
        
        #if INHOUSE
            environment += " InHouse"
        #endif
        
        #if SIT
            environment += " SIT"
        #endif
        
        #if UAT
            environment += " UAT"
        #endif
        
        #if APPSTORE
            environment += " AppStore"
        #endif
        
        appInfo += "Environment:\(environment)\n";
        
        appInfo += "Server: \(SAFE_STRING(NetworkURLConfig.shared.API_HOST))\n"
        
        appInfo += "API: \(SAFE_STRING(NetworkURLConfig.shared.API_METHOD_PATH))\n"
        
        //appInfo += "JPush Key: \(JPUSH_APP_KEY)\nJPush Channel: \(JPUSH_CHANNEL)\nJPush Is Production: \(JPUSH_IS_PRODUCTION)\n";
        
//        if let user = UserCenter.currentUser()
//        {
//            appInfo += "Registration ID: \(user.registration_id)\n"
//        }
        
        if let info = Bundle.main.infoDictionary {
            let executable = info[kCFBundleExecutableKey as String] as? String ?? "Unknown"
            appInfo += "Name:\(executable)\n"
            
            let bundle = info[kCFBundleIdentifierKey as String] as? String ?? "Unknown"
            appInfo += "BundleIdentifier: \(bundle)\n"
            
            let appVersion = info["CFBundleShortVersionString"] as? String ?? "Unknown"
            let appBuild = info[kCFBundleVersionKey as String] as? String ?? "Unknown"
            appInfo += "Version: \(appVersion)_\(appBuild)\n"
            
            let osNameVersion: String = {
                let version = ProcessInfo.processInfo.operatingSystemVersion
                let versionString = "\(version.majorVersion).\(version.minorVersion).\(version.patchVersion)"
                return "iOS \(versionString)"
            }()
            appInfo += "OS: \(osNameVersion)\n"
        }
        
        textView.text = appInfo;
    }

    override func rightTopAction(_ sender: Any) {
        AntDebugBar.sharedInstance.isHidden = false
    }
}
