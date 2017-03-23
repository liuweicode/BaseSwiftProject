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

    var completionBlock: AMapLocatingCompletionBlock!
    lazy var locationManager = AMapLocationManager()
    var permissionCheckView: AlertView?
    
    let companyLab: UILabel = {
        let lab = UILabel.lightGrayLabel(fontsize: 17)
        lab.text = "Linkim Inc."
        return lab
    }()
    
    let logoImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        return view
    }()
    
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
        
        activityIndicatorView.startAnimating()
        
        logoImageView.alpha = 0
        logoImageView.image = UIImage(named: "launch_logo")
        
        UIView.animate(withDuration: 1, animations: {
            self.logoImageView.alpha = 1
        }, completion: {(finshed) -> Void in
            //_ = self.timer(selector: #selector(self.handleTimer(_:)), timeInterval: 0.8)
            //APPCONTROLLER.setupLogin()
        })
        
        initCompleteBlock()
        configLocationManager()
        addObservers()
    }
    
    deinit {
        ANT_LOG_INFO("deinit")
        removeObservers()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.checkPermissionAndDoNext()
    }
    
    func checkPermissionAndDoNext() {
        
        if self.permissionCheckView != nil
        {
            self.permissionCheckView?.close()
            self.permissionCheckView = nil
        }
        
        PermissionUtils.checkAlwaysLocationPermissions {[weak self] (guarded) in
            
            guard let strongSelf = self else { return }
            
            if guarded
            {
                strongSelf.locAction()
            }else{
                
                // 提示用户去打开用户定为权限
                let ok = AlertViewButtonItem(inLabel: "确定", inAction: {
                    if let url = URL(string: UIApplicationOpenSettingsURLString)
                    {
                        if(UIApplication.shared.canOpenURL(url)) {
                            UIApplication.shared.open(url, options: [:], completionHandler: nil)
                        }
                    }
                })
                strongSelf.permissionCheckView = AlertView(title: nil, message: "请在[系统设置>隐私>定位服务]中打开定位服务", cancelButtonItem: ok, otherButtonItems: nil)
                strongSelf.permissionCheckView!.show()
            }
        }
    }
    
    private func addObservers()
    {
        self.registerNotification(name: NSNotification.Name.UIApplicationDidBecomeActive.rawValue, selector: #selector(applicationDidBecomeActive(_:)), object: nil)
    }
    
    private func removeObservers()
    {
        self.unRegisterNotification(NSNotification.Name.UIApplicationDidBecomeActive.rawValue)
    }
    
    func applicationDidBecomeActive(_ notification:Notification)
    {
        self.checkPermissionAndDoNext()
    }

    //MARK: - Initialization
    
    func initCompleteBlock() {
        
        completionBlock = {[weak self](location: CLLocation?, regeocode: AMapLocationReGeocode?, error: Error?) in
            
            guard let _ = self else {
                return
            }
            
            if let error = error {
                
                let error = error as NSError
                
                ANT_LOG_ERROR("locError:{\(error.code) - \(error.localizedDescription)};")
                
                /*
                if error.code == AMapLocationErrorCode.locateFailed.rawValue {
                    return;
                }
                 */
            }
            
            if let location = location
            {
                ANT_LOG_INFO("获取到经纬度：lat:\(location.coordinate.latitude); lon:\(location.coordinate.longitude); accuracy:\(location.horizontalAccuracy)m")
                UserCenter.currentCoordinate = location.coordinate
            }else{
                ANT_LOG_WARN("没有获取到经纬度")
            }
        }
    }
    
    //MARK: - Action Handle
    func configLocationManager() {
        
        //locationManager.delegate = self
        
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        
        locationManager.pausesLocationUpdatesAutomatically = false
        
        locationManager.allowsBackgroundLocationUpdates = true
    }
    
    func locAction() {
        //定位超时时间，最低2s，此处设置为2s
        locationManager.locationTimeout = 2
        locationManager.requestLocation(withReGeocode: false, completionBlock: completionBlock)
        _ = self.timer(selector: #selector(self.handleTimer(_:)), timeInterval: 2.5)
    }
    
    func cleanUpAction() {
        locationManager.stopUpdatingLocation()
        //locationManager.delegate = nil
    }
    
    func handleTimer(_ timer:Timer)
    {
        self.cleanUpAction()
        
        if let location = UserCenter.currentCoordinate
        {
            ANT_LOG_INFO("最终获取到了用户位置:\(location.longitude),\(location.latitude)")
        }else{
            ANT_LOG_WARN("最终没有获取到用户位置")
        }
        
        self.goNextStep()
    }
    
    func goNextStep()
    {
        if UserDefaults.standard.object(forKey: "is_guide_show1") == nil
        {
            APPCONTROLLER.setupGuide()
            return
        }
        
        if let user = UserCenter.currentUser()
        {
            // 自动登录
            self.doAutoLogin(user.user_ids, auto_login_secret: user.auto_login_secret)
        }else{
            APPCONTROLLER.setMain()
        }
    }
}

extension LogoViewController
{
    fileprivate func doAutoLogin(_ user_ids:String, auto_login_secret:String)
    {
        let param = [
            "user_ids":user_ids,
            "auto_login_secret":auto_login_secret
        ];
        
        _ = NC_POST(self).send(params: param, url: API(service: API_USER_AUTOSIGN), successBlock: { (message) in
            
            // 保存用户信息
            let appUser = AppUser(json: message.responseJson["data"]["responsedata"]["user_info"])
            UserCenter.saveUser(appUser)
            
            APPCONTROLLER.setMain()
            
        }) { (message) in
            // 自动登录失败进入删除用户信息 并跳转到主界面
            UserCenter.removeUser()
            APPCONTROLLER.setMain()
        }
    }
}

/*
extension LogoViewController: AMapLocationManagerDelegate
{
    
}
*/
