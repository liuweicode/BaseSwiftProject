//
//  AppController.swift
//  Dancing
//
//  Created by 刘伟 on 28/10/2016.
//  Copyright © 2016 上海凌晋信息技术有限公司. All rights reserved.
//

import UIKit

let APPCONTROLLER = AppController.sharedInstance

class AppController: NSObject {
    
    // 单例类
    static let sharedInstance = AppController()
    
    // 私有化init方法
    override init() {}
    
    /**
     设置启动Logo等待页
     */
    func setupLogo()
    {
        let rootVC = LogoViewController()
        let delegate = UIApplication.shared.delegate as! AppDelegate
        delegate.window?.rootViewController = rootVC
        delegate.window?.makeKeyAndVisible()
    }
    
    /**
     测试
     */
    func setupTest()
    {
        let rootVC = ApiTestViewController()
        let navi = BaseNavigationController(rootViewController: rootVC)
        let delegate = UIApplication.shared.delegate as! AppDelegate
        if let snapShot = delegate.window?.snapshotView(afterScreenUpdates: true)
        {
            navi.view.addSubview(snapShot)
            delegate.window!.rootViewController = navi
            UIView.animate(withDuration: 0.8, animations: {
                snapShot.layer.opacity = 0
                //snapShot.layer.transform = CAtransfor//CATransform3DMakeScale(1.5, 1.5, 1.5)
            }, completion: { (finished) in
                snapShot.removeFromSuperview()
            })
        }else{
            delegate.window!.rootViewController = navi
        }
        NavRouter.navigationController = navi
        
        delegate.window?.makeKeyAndVisible()
    }
    
    
    /**
     设置引导页
     */
    func setupGuide()
    {
        let rootVC = GuideViewController()
        let delegate = UIApplication.shared.delegate as! AppDelegate
        UIView.transition(with: delegate.window!, duration: 0.8, options: .transitionCrossDissolve, animations: {
            delegate.window?.rootViewController = rootVC
            }, completion: nil)
        delegate.window?.makeKeyAndVisible()
    }
    
    /**
     设置登录页
     */
    func setupLogin()
    {
        let rootVC = LoginViewController()
        let navi = BaseNavigationController(rootViewController: rootVC)
        let delegate = UIApplication.shared.delegate as! AppDelegate
        if let snapShot = delegate.window?.snapshotView(afterScreenUpdates: true)
        {
            navi.view.addSubview(snapShot)
            delegate.window!.rootViewController = navi
            UIView.animate(withDuration: 0.8, animations: { 
                snapShot.layer.opacity = 0
                //snapShot.layer.transform = CAtransfor//CATransform3DMakeScale(1.5, 1.5, 1.5)
                }, completion: { (finished) in
                   snapShot.removeFromSuperview()
            })
        }else{
            delegate.window!.rootViewController = navi
        }
        NavRouter.navigationController = navi
        
        delegate.window?.makeKeyAndVisible()
    }
    
    func presentLogin()
    {
        let loginVC = LoginViewController()
        loginVC.isPresent = true
        let navi = BaseNavigationController(rootViewController: loginVC)
        self.currentViewController().present(navi, animated: true, completion: nil)
    }
    
    // 设置主页
    func setMain()
    {
        let rootVC = TabBarController()
        let delegate = UIApplication.shared.delegate as! AppDelegate
        if let snapShot = delegate.window?.snapshotView(afterScreenUpdates: true)
        {
            rootVC.view.addSubview(snapShot)
            delegate.window!.rootViewController = rootVC
            UIView.animate(withDuration: 0.8, animations: {
                snapShot.layer.opacity = 0
                snapShot.layer.transform = CATransform3DMakeScale(0.25, 0.25, 0.25)
                }, completion: { (finished) in
                    snapShot.removeFromSuperview()
            })
        }else{
            delegate.window!.rootViewController = rootVC
        }
        delegate.window?.makeKeyAndVisible()
 
        
//        let rootVC = MainMapViewController()
//        let delegate = UIApplication.shared.delegate as! AppDelegate
//        if let snapShot = delegate.window?.snapshotView(afterScreenUpdates: true)
//        {
//            rootVC.view.addSubview(snapShot)
//            delegate.window!.rootViewController = rootVC
//            UIView.animate(withDuration: 0.8, animations: {
//                snapShot.layer.opacity = 0
//                snapShot.layer.transform = CATransform3DMakeScale(0.25, 0.25, 0.25)
//            }, completion: { (finished) in
//                snapShot.removeFromSuperview()
//            })
//        }else{
//            delegate.window!.rootViewController = rootVC
//        }
//        delegate.window?.makeKeyAndVisible()
    }
    
    func showLogin()
    {
        let rootVC = LoginViewController()
        let navi = BaseNavigationController(rootViewController: rootVC)
        self.currentViewController().present(navi, animated: true, completion: nil)
    }
    
    func currentNavigationController() -> BaseNavigationController {
        let delegate = UIApplication.shared.delegate as! AppDelegate
        let vc = delegate.window!.rootViewController
        
        if vc is BaseNavigationController
        {
            return vc as! BaseNavigationController
        }
        else if vc is TabBarController
        {
            return (vc as! TabBarController).currentNavigationController()
        }
        assert(false, "没有导航控制器",file: #function, line: #line)
        
        return BaseNavigationController(rootViewController: self.currentViewController())
    }
    
    func currentViewController() -> UIViewController {
        return self.currentNavigationController().viewControllers.last!
    }
    
    func pushViewController(_ viewController: UIViewController, animated: Bool = true)
    {
        viewController.hidesBottomBarWhenPushed = true
        self.currentNavigationController().pushViewController(viewController, animated: animated)
    }
    
    func popViewController(animated:Bool = true)
    {
        self.currentNavigationController().popViewController(animated: animated)
    }
}
