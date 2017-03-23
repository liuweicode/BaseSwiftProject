//
//  LogoViewController.swift
//  Dancing
//
//  Created by 刘伟 on 28/10/2016.
//  Copyright © 2016 上海凌晋信息技术有限公司. All rights reserved.
//

import UIKit
import SnapKit

class LogoViewController: BaseViewController {
    
    let companyLab: UILabel = {
        let lab = UILabel.lightGrayLabel(fontsize: 17)
        lab.text = "Linkim Inc."
        return lab
    }()
    
    let logoImageView: UIImageView = {
        let view = UIImageView()
        view.backgroundColor = UIColor.red
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    //    let requestBtn: UIButton = {
    //        let button = UIButton(type: .custom)
    //        button.setTitleColor(UIColor.white, for: .normal)
    //        button.setBackgroundImage(UIImage.imageWithColor(COLOR_BUTTON_BLUE), for: .normal)
    //        button.setBackgroundImage(UIImage.imageWithColor(COLOR_BUTTON_BLUE.alphaValue(0.8)), for: .highlighted)
    //        button.setBackgroundImage(UIImage.imageWithColor(COLOR_BUTTON_GRAY), for: .disabled)
    //        button.setTitle(DLocalizedString("重新加载"), for: .normal)
    //        button.layer.masksToBounds = true
    //        button.layer.cornerRadius = 4
    //        return button
    //    }()
    
    fileprivate let activityIndicatorView: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
        activityIndicator.hidesWhenStopped = true
        return activityIndicator
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(companyLab)
        companyLab.snp.makeConstraints { (make) in
            make.centerX.equalTo(view)
            make.bottom.equalTo(view).offset(-40)
            make.width.height.greaterThanOrEqualTo(0)
        }
        
        view.addSubview(logoImageView)
        logoImageView.snp.makeConstraints { (make) in
            make.centerX.equalTo(view)
            make.centerY.equalTo(view).offset(-40)
            make.width.equalTo(view).multipliedBy(0.8)
            make.height.equalTo(logoImageView.snp.width).multipliedBy(0.3)
        }
        
        view.addSubview(activityIndicatorView)
        activityIndicatorView.snp.makeConstraints { (make) in
            make.top.equalTo(logoImageView.snp.bottom).offset(40)
            make.width.height.equalTo(view.snp.width).multipliedBy(0.13)
            make.centerX.equalTo(view)
        }
        
        //        view.addSubview(requestBtn)
        //        requestBtn.snp.makeConstraints { (make) in
        //            make.center.equalTo(activityIndicatorView.snp.center)
        //            make.width.equalTo(view.snp.width).multipliedBy(0.7)
        //            make.height.equalTo(44)
        //        }
        //
        //        requestBtn.isHidden = true
        //        requestBtn.alpha = 0
        //requestBtn.addTarget(self, action: #selector(onRerequestBtnClick(_:)), for: .touchUpInside)
        
        activityIndicatorView.startAnimating()
        
        
        UIView.animate(withDuration: 1, animations: {
            self.logoImageView.alpha = 1
        }, completion: {(finshed) -> Void in
            _ = self.timer(selector: #selector(self.handleTimer(_:)), timeInterval: 0.8)
            //APPCONTROLLER.setupLogin()
        })
    }
    
//    fileprivate func doAutoLogin(_ user_ids:String, auth_login_secret:String, org_ids:String)
//    {
//        let param = [
//            "user_ids":user_ids,
//            "auth_login_secret":auth_login_secret,
//            "org_ids":org_ids
//        ];
//        
//        _ = NC_POST(self).send(params: param, url: API(API_USER_AUTOSIGN), successBlock: { (message) in
//            
//            // 保存用户信息
//            let appUser = AppUser(json: message.responseJson["data"]["responsedata"]["user_info"])
//            UserCenter.saveUser(appUser)
//            
//            let appOrganization = AppOrganization(json:message.responseJson["data"]["responsedata"]["org_info"])
//            UserCenter.saveOrganization(appOrganization)
//            
//            APPCONTROLLER.setMain()
//            
//        }) { (message) in
//            //ToastView.showError(message.networkError!)
//            // 自动登录失败进入登录界面
//            UserCenter.removeUser()
//            UserCenter.removeOrganization()
//            APPCONTROLLER.setupLogo()
//        }
//    }
    
    //    func onRerequestBtnClick(_ sender:UIButton)
    //    {
    //        activityIndicatorView.startAnimating()
    //        self.requestBtn.isHidden = true
    //        self.requestBtn.alpha = 0
    //        //self.requestToken()
    //    }
    
    func handleTimer(_ timer:Timer)
    {
        if UserDefaults.standard.object(forKey: "is_guide_show1") == nil
        {
            APPCONTROLLER.setupGuide()
            return
        }
        
        APPCONTROLLER.setupLogin()
        
//        //self.requestToken()
//        if let user = UserCenter.currentUser()
//        {
//            let org_ids = UserCenter.getOrganizationId()
//            
//            // 自动登录
//            self.doAutoLogin(user.user_ids, auth_login_secret: user.auth_login_secret, org_ids: org_ids)
//        }else{
//            APPCONTROLLER.setupLogin()
//        }
    }
    
    //    func requestToken()
    //    {
    //        // session 15  API->解密-> 刷新时间
    //        // user 10 409->auto login
    //        _ = NC_POST(self).send(method: .post, params: nil, url: API(API_SYSTEM_GETAESKEY), successBlock: { (message) in
    //
    //            self.activityIndicatorView.stopAnimating()
    //
    //            NetworkCipher.sharedInstance.aes_key = message.responseJson["data"]["responsedata"]["aes_key"].string
    //            NetworkCipher.sharedInstance.aes_iv = message.responseJson["data"]["responsedata"]["aes_iv"].string
    //            NetworkCipher.sharedInstance.token = message.responseJson["data"]["responsedata"]["token"].string
    //
    //            if let user = UserCenter.currentUser(), let org = UserCenter.currentOrganization()
    //            {
    //                // 自动登录
    //                self.doAutoLogin(user.user_ids, auth_login_secret: user.auth_login_secret, org_ids: org.org_ids)
    //            }else{
    //                APPCONTROLLER.setupLogin()
    //            }
    //
    //        }) { (message) in
    //            self.activityIndicatorView.stopAnimating()
    //            ToastView.showError(message.networkError!)
    //            self.requestBtn.isHidden = false
    //            UIView.animate(withDuration: 0.8, animations: {
    //                self.requestBtn.alpha = 1
    //            })
    //            
    //            // 获取密钥失败
    //            ANT_LOG_ERROR("获取密钥失败 errorcode:\(message.networkError)")
    //        }
    //    }
}
