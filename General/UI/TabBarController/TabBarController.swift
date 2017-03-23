//
//  TabBarController.swift
//  LinkimFoundation
//
//  Created by 刘伟 on 16/7/1.
//  Copyright © 2016年 CocoaPods. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {

    var tabBarDataSource:TabBarDataSource? // tabbar数据源
    
    var tabBarView:TabBarView? // 自定义的TabBar
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // 注册tabbar点击事件
        self.registerNotification(name: Notification_TabBar, selector: #selector(handleNotification(_:)))
        self.registerNotification(name: NOTIFICATION_HIDE, selector: #selector(handleNotification(_:)))
        self.registerNotification(name: NOTIFICATION_SHOW, selector: #selector(handleNotification(_:)))
        
        // 加载子界面
        self.initSubviews()
        
        // 移除系统生成的baritem
        self.removeSystemBarItem()
        
        // 加载自定义Tabbar
        self.initCustomTabbarView()
        
    }

    
    /**
     防止系统tabbar按钮显示
     */
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.removeSystemBarItem()
    }
    
    /**
     防止系统tabbar按钮显示
     */
    override func viewWillAppear(_ animated: Bool) {
        self.removeSystemBarItem()
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    func initSubviews()
    {
        self.tabBarDataSource = TabBarConfig.sharedInstance.dataSource
        if tabBarDataSource != nil
        {
            var controllers = [UIViewController]()
            for item in tabBarDataSource!.items {
                if let controller:UIViewController = NSObject.fromClassName(item.className) as? UIViewController
                {
                    let navigationController = BaseNavigationController(rootViewController: controller)
                    controllers.append(navigationController)
                }
            }
            self.viewControllers = controllers
        }
    }
    
    func removeSystemBarItem()
    {
        for systemTabbarItem in self.tabBar.subviews {
            if !systemTabbarItem.isKind(of: TabBarView.self) {
                systemTabbarItem.removeFromSuperview()
            }
        }
    }
    
    func initCustomTabbarView()
    {
        self.tabBarView = TabBarView(self.tabBarDataSource!.items)
        self.tabBarView!.topLineColor = UIColor(self.tabBarDataSource!.shadowColor)
        self.tabBarView!.backgroundColor = UIColor(self.tabBarDataSource!.backgroundColor)
        self.tabBar.addSubview(self.tabBarView!)
        self.tabBarView?.snp.makeConstraints( { (make) in
            make.edges.equalTo(self.tabBar)
        })
    }
    
    func handleNotification(_ notification:Notification)
    {
        if notification.isNotification(Notification_TabBar) {
            let tabBarNotify = notification.object as! TabBarNotification
            self.selectedIndex = tabBarNotify.index
        }
        else if notification.isNotification(NOTIFICATION_HIDE)
        {
            self.tabBar.isHidden = true
            self.tabBarView?.snp.remakeConstraints( { (make) in
                make.edges.equalTo(self.tabBar)
            })
        }
        else if notification.isNotification(NOTIFICATION_SHOW)
        {
            self.tabBar.isHidden = false
            self.tabBarView?.snp.remakeConstraints( { (make) in
                make.edges.equalTo(self.tabBar)
            })
        }
    }
    
    func currentNavigationController() -> BaseNavigationController {
        assert(self.viewControllers != nil, "viewControllers 不能为空",file: #function, line: #line)
        assert(self.viewControllers!.count > 0, "viewControllers 不能为空",file: #function, line: #line)
        return self.selectedViewController as! BaseNavigationController
    }

    deinit
    {
        self.unRegisterAllNotification()
    }
}
