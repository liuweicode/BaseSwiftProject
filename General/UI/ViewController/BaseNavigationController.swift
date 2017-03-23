//
//  BaseNavigationController.swift
//  DaQu
//
//  Created by 刘伟 on 8/26/16.
//  Copyright © 2016 上海凌晋信息技术有限公司. All rights reserved.
//

import UIKit
import JZNavigationExtension

class BaseNavigationController: UINavigationController, UIGestureRecognizerDelegate {
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.delegate = self
    }
    
    override init(rootViewController: UIViewController)
    {
        super.init(rootViewController: rootViewController)
        self.delegate = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.jz_fullScreenInteractivePopGestureEnabled = true
    }
    
    deinit {
        self.unRegisterAllNotification()
    }
    
    // MARK: - UIGestureRecognizerDelegate
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return self.childViewControllers.count == 1 ? false : true
    }
    
}

extension BaseNavigationController: UINavigationControllerDelegate
{
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool)
    {
        let delegate = UIApplication.shared.delegate as! AppDelegate
        
        // when a push occurs, wire the interaction controller to the to- view controller
        guard let _ = delegate.navigationControllerInteractionController else {
            return
        }
        delegate.navigationControllerInteractionController?.wire(to: viewController, for: .pop)
    }
    
//    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool)
//    {
//        
//    }
    
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationControllerOperation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning?
    {
        let delegate = UIApplication.shared.delegate as! AppDelegate
        if let _ = delegate.navigationControllerAnimationController
        {
            delegate.navigationControllerAnimationController?.reverse = operation == .pop
        }
        return delegate.navigationControllerAnimationController
    }
    
    func navigationController(_ navigationController: UINavigationController, interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning?
    {
        let delegate = UIApplication.shared.delegate as! AppDelegate
        
        return ((delegate.navigationControllerInteractionController != nil) && delegate.navigationControllerInteractionController!.interactionInProgress) ? delegate.navigationControllerInteractionController : nil
    }

    
//    func navigationControllerSupportedInterfaceOrientations(_ navigationController: UINavigationController) -> UIInterfaceOrientationMask
//    {
//    
//    }
//    
//    func navigationControllerPreferredInterfaceOrientationForPresentation(_ navigationController: UINavigationController) -> UIInterfaceOrientation
//    {
//    
//    }
//    

    
}
