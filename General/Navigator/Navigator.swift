//
//  Navigator.swift
//  BingLiYun
//
//  Created by 刘伟 on 09/12/2016.
//  Copyright © 2016 上海凌晋信息技术有限公司. All rights reserved.
//

import UIKit

let NavRouter = Navigator.shared

class Navigator: NSObject {
    
    fileprivate var _navigationController: UINavigationController?
    
    fileprivate var _urlMapping = [String:String]()
    // 单例
    static let shared = Navigator()
    
    private override init() {
        super.init()
    }
    
    var navigationController: UINavigationController?
        {
        get{
            return _navigationController
        }
        set{
            self._navigationController = newValue
        }
    }
    
    func setURLMapping(plistName:String)
    {
        _urlMapping.removeAll()
        
        guard let plistPath = Bundle.main.path(forResource: plistName, ofType: "plist") else { return }
        
        guard let controllerDicts = NSDictionary(contentsOfFile: plistPath) as? [String:String] else { return }
        
        for (key, val) in controllerDicts
        {
            _urlMapping[key] = val
        }
        
        #if DEBUG
            do{
                let mappingData = try JSONSerialization.data(withJSONObject: _urlMapping, options: .prettyPrinted)
                let mappingDict = try JSONSerialization.jsonObject(with: mappingData, options: .allowFragments)
                ANT_LOG_INFO("Navigator url mapping:\n \(mappingDict)")
            } catch {
                ANT_LOG_NETWORK_ERROR(error.localizedDescription)
            }
        #endif
    }
    
    func open(action:RouterAction)
    {
        if self.navigationController == nil
        {
            self.navigationController = APPCONTROLLER.currentNavigationController()
        }
        
        guard let navigationController = self.navigationController else {
            assert(false, "Navigator#navigationController has not been set to a UINavigationController instance",file: #function, line: #line)
            return
        }
        
        if let controller = self.matchViewController(action: action)
        {
            navigationController.pushViewController(controller, animated: true)
        }
        
    }
    
    // 寻找匹配的ViewController
    func matchViewController(action:RouterAction) -> UIViewController? {
        
        var controller: UIViewController?
        
        for (key, val) in _urlMapping
        {
            if action.url?.host == key
            {
                if let foundVC:UIViewController = NSObject.fromClassName(val) as? UIViewController
                {
                    controller = foundVC
                    break
                }
            }
        }
        return controller
    }
    
    
}
