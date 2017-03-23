//
//  UIScreen+Extension.swift
//  Pods
//
//  Created by Vic on 16/7/5.
//
//

import UIKit

//屏幕宽度
public let ScreenWidth = UIScreen.main.bounds.width
//屏幕高度
public let ScreenHeight = UIScreen.main.bounds.height
// 状态栏高度
public let StatusBarHeight:CGFloat = UIApplication.shared.statusBarFrame.size.height
// 导航栏高度
public let NavigationBarHeight:CGFloat = 44
// 状态栏＋导航栏
public let Status_Navigation_Height:CGFloat = (StatusBarHeight + NavigationBarHeight)

public enum ScreenSizeType : Int {
    case screen3_5Inch = 0
    case screen4Inch
    case screen4_7Inch
    case screen5_5Inch
    case unknownSize
}

extension UIScreen {
    
    /**
     屏幕尺寸类型，仅支持iphone系列
     
     - returns: ScreenSizeType
     */
    public class func sizeType() -> ScreenSizeType {
        
        switch ScreenHeight {
        case 480:
            return .screen3_5Inch
        case 568:
            return .screen4Inch
        case 667:
            return UIScreen.main.scale == 3.0 ? .screen5_5Inch : .screen4_7Inch
        case 736:
            return .screen5_5Inch
        default:
            return .unknownSize
        }
    }
    
    static public func isEqualToScreenSize(_ size: ScreenSizeType) -> Bool {
        return size == UIScreen.sizeType() ? true : false;
    }
    
    static public func isLargerThanScreenSize(_ size: ScreenSizeType) -> Bool {
        return size.rawValue < UIScreen.sizeType().rawValue ? true : false;
    }
    
    static public func isSmallerThanScreenSize(_ size: ScreenSizeType) -> Bool {
        return size.rawValue > UIScreen.sizeType().rawValue ? true : false;
    }
}
