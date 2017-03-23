//
//  Object+Extention.swift
//  Pods
//
//  Created by 刘伟 on 16/7/4.
//
//

import UIKit

public extension NSObject {
    
    public class func fromClassName(_ className : String) -> NSObject {
        let className = Bundle.main.infoDictionary!["CFBundleName"] as! String + "." + className
        let aClass = NSClassFromString(className) as! UIViewController.Type
        return aClass.init()
    }
    
}
