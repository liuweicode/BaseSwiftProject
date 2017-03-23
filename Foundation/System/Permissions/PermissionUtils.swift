//
//  PermissionUtils.swift
//  Dancing
//
//  Created by 刘伟 on 11/11/2016.
//  Copyright © 2016 上海凌晋信息技术有限公司. All rights reserved.
//

import UIKit
import Photos
import AVFoundation
import CoreLocation

typealias PermissionGrantBlock = (_ granted:Bool) -> Void

class PermissionUtils: NSObject {

    // 检测相机权限
    class func checkCameraPermissions(_ finished: PermissionGrantBlock? = nil)
    {
        let authStatus:AVAuthorizationStatus = AVCaptureDevice.authorizationStatus(forMediaType: AVMediaTypeVideo)
        
        switch authStatus
        {
        case .denied, .restricted:
            finished?(false)
        case .authorized:
            finished?(true)
        case .notDetermined:
            AVCaptureDevice.requestAccess(forMediaType: AVMediaTypeVideo, completionHandler: { (granted) in
                DispatchQueue.main.async {
                    finished?(granted)
                }
            })
        }
    }
    
    // 检测音频权限
    class func checkAudioPermissions(_ finished: PermissionGrantBlock? = nil)
    {
        let authStatus:AVAuthorizationStatus = AVCaptureDevice.authorizationStatus(forMediaType: AVMediaTypeAudio)
        
        switch authStatus
        {
        case .denied, .restricted:
            finished?(false)
        case .authorized:
            finished?(true)
        case .notDetermined:
            AVCaptureDevice.requestAccess(forMediaType: AVMediaTypeAudio, completionHandler: { (granted) in
                DispatchQueue.main.async {
                    finished?(granted)
                }
            })
        }
    }
    
    // 检测相册权限
    class func checkPhotoLibraryPermissions(_ finished: PermissionGrantBlock? = nil)
    {
        let authStatus:PHAuthorizationStatus = PHPhotoLibrary.authorizationStatus()
        
        switch authStatus
        {
        case .denied, .restricted:
            finished?(false)
        case .authorized:
            finished?(true)
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization({ (status) in
                DispatchQueue.main.async {
                    switch status
                    {
                    case .denied, .restricted:
                        finished?(false)
                    case .authorized:
                        finished?(true)
                    case .notDetermined:
                        PermissionUtils.checkPhotoLibraryPermissions(finished)
                    }
                }
            })
            
        }
    }
    
    class func checkWhenInUseLocationPermissions(_ finished: PermissionGrantBlock? = nil)
    {
        LocationPermissions.shared.checkWhenInUseLocationPermissions(finished)
    }
    
    class func checkAlwaysLocationPermissions(_ finished: PermissionGrantBlock? = nil)
    {
        LocationPermissions.shared.checkAlwaysLocationPermissions(finished)
    }
}
