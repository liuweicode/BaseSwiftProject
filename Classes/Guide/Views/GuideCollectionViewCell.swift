//
//  GuideCollectionViewCell.swift
//  Dancing
//
//  Created by 刘伟 on 28/10/2016.
//  Copyright © 2016 上海凌晋信息技术有限公司. All rights reserved.
//

import UIKit
import SnapKit

class GuideCollectionViewCell: BaseCollectionViewCell {

    private var image: String?
    
    var imageView:UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        return imageView
    }()
    
    var button: UIButton = {
        let button = UIButton.blueButton()
        button.setTitle("进入", for: .normal)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 4
        return button
    }()
    
    override func settingLayout() {
        contentView.addSubview(imageView)
        imageView.snp.makeConstraints { (make) in
            make.edges.equalTo(self)
        }
        
        contentView.addSubview(button)
        button.snp.makeConstraints { (make) in
            make.bottom.equalTo(self).offset(-30)
            make.left.equalTo(contentView).offset(20)
            make.right.equalTo(contentView).offset(-20)
            make.height.equalTo(44)
        }
        
        button.addTarget(self, action: #selector(onButtonClick(_:)), for: .touchUpInside)
    }
    
    func onButtonClick(_ sender: UIButton)
    {
        UserDefaults.standard.set("YES", forKey: "is_guide_show1")
        UserDefaults.standard.synchronize()
        
        if let user = UserCenter.currentUser()
        {
            // 自动登录
            self.doAutoLogin(user.user_ids, auto_login_secret: user.auto_login_secret)
        }else{
            APPCONTROLLER.setMain()
        }
    }

    func setImage(_ image:String)
    {
        self.image = image
        imageView.image = UIImage(named: image)
    }
    
    fileprivate func doAutoLogin(_ user_ids:String, auto_login_secret:String)
    {
        let param = [
            "user_ids":user_ids,
            "auto_login_secret":auto_login_secret
        ];
        
        ToastView.showProgressLoading()
        
        _ = NC_POST(self).send(params: param, url: API(service: API_USER_AUTOSIGN), successBlock: { (message) in
            
            ToastView.hide()
            
            // 保存用户信息
            let appUser = AppUser(json: message.responseJson["data"]["responsedata"]["user_info"])
            UserCenter.saveUser(appUser)

            APPCONTROLLER.setMain()
            
        }) { (message) in
            ToastView.hide()
            // 自动登录失败进入登录界面
            UserCenter.removeUser()
            APPCONTROLLER.setupLogo()
        }
    }
    
}
