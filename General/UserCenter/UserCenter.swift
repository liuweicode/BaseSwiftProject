//
//  UserCenter.swift
//  DaQu
//
//  Created by 刘伟 on 9/5/16.
//  Copyright © 2016 上海凌晋信息技术有限公司. All rights reserved.
//

import UIKit

class UserCenter: NSObject {

    fileprivate static var _currentUser: AppUser?
    
    /**
     保存当前登录用户
     
     - parameter user: 用户
     */
    class func saveUser(_ user:AppUser)
    {
        let data = NSKeyedArchiver.archivedData(withRootObject: user)
        let userFilePath = Sandbox.documentPath + "/User"
        let fileManage = FileManager.default
        
        do {
            
            if fileManage.fileExists(atPath: userFilePath) {
                try fileManage.removeItem(atPath: userFilePath)
            }
            
            try data.write(to: URL(fileURLWithPath: userFilePath), options: [.atomic])
            
            _currentUser = user
            
            #if DEBUG
                ANT_LOG_INFO("保存用户成功")
            #endif
        }catch{
            #if DEBUG
                ANT_LOG_ERROR("保存用户失败")
                ANT_LOG_ERROR(error.localizedDescription)
            #endif
        }
    }
    
    /**
     获取当前登录用户
     
     - returns: 如果没有登录，则为空
     */
    class func currentUser() -> AppUser?
    {
        if nil != _currentUser {
            return _currentUser!
        }
        
        let userFilePath = Sandbox.documentPath + "/User"
        let fileManage = FileManager.default
        if fileManage.fileExists(atPath: userFilePath) {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: userFilePath))
                
                if let user = NSKeyedUnarchiver.unarchiveObject(with: data) as? AppUser
                {
                    if user.user_ids != "" {
                        _currentUser = user
                        return _currentUser
                    }
                }
            } catch {
                #if DEBUG
                    ANT_LOG_ERROR("读取当前用户失败")
                    ANT_LOG_ERROR(error.localizedDescription)
                #endif
            }
        }
        return nil
    }
    
    /**
     删除当前登录用户
     */
    class func removeUser()
    {
        _currentUser = nil
        let userFilePath = Sandbox.documentPath + "/User"
        let fileManage = FileManager.default
        if fileManage.fileExists(atPath: userFilePath) {
            do{
                try fileManage.removeItem(atPath: userFilePath)
                
                #if DEBUG
                    ANT_LOG_INFO("删除当前用户成功")
                #endif
            }catch{
                #if DEBUG
                    ANT_LOG_ERROR("删除当前用户失败")
                    ANT_LOG_ERROR(error.localizedDescription)
                #endif
            }
        }
    }

}
