//
//  LocationPermissions.swift
//  JiChongChong
//
//  Created by 刘伟 on 3/7/17.
//  Copyright © 2017 上海凌晋信息技术有限公司. All rights reserved.
//

import UIKit
import CoreLocation

enum CheckLocationPermissionType {
    case whenInUse
    case always
}

class LocationPermissions: NSObject, CLLocationManagerDelegate {

    private var _locationManager: CLLocationManager?;
    private var _checkType = CheckLocationPermissionType.always
    
    private func getLocationManager() -> CLLocationManager {
        if _locationManager == nil
        {
            _locationManager = CLLocationManager()
            _locationManager!.delegate = self
        }
        return _locationManager!
    }
    
    // 单例类
    static let shared = LocationPermissions()
    
    // 私有化init方法
    private override init() {
        super.init()
    }
    
    
    private var completeHandle: PermissionGrantBlock?
    
    func checkWhenInUseLocationPermissions(_ finished: PermissionGrantBlock? = nil)
    {
        if CLLocationManager.locationServicesEnabled()
        {
            let status = CLLocationManager.authorizationStatus()
            switch status {
            case .denied, .restricted:
                finished?(false)
            case .authorizedAlways:
                finished?(true)
            case .authorizedWhenInUse:
                finished?(true)
            case .notDetermined:
                completeHandle = finished
                _checkType = .whenInUse
                self.getLocationManager().requestWhenInUseAuthorization()
            }
        }else{
            finished?(false)
        }
    }
    
    func checkAlwaysLocationPermissions(_ finished: PermissionGrantBlock? = nil)
    {
        if CLLocationManager.locationServicesEnabled()
        {
            let status = CLLocationManager.authorizationStatus()
            switch status {
            case .denied, .restricted:
                finished?(false)
            case .authorizedAlways:
                finished?(true)
            case .authorizedWhenInUse:
                finished?(true)
            case .notDetermined:
                completeHandle = finished
                _checkType = .always
                self.getLocationManager().requestAlwaysAuthorization()
            }
        }else{
            finished?(false)
        }
    }
    
    // MARK: - locationManager
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        _locationManager?.delegate = nil
        _locationManager = nil

        switch status {
            case .denied, .restricted:
                completeHandle?(false)
            case .authorizedAlways:
                completeHandle?(true)
            case .authorizedWhenInUse:
                if _checkType == .always {
                    completeHandle?(false)
                }else{
                    completeHandle?(true)
                }
            case .notDetermined:
                ANT_LOG_INFO("notDetermined will never be executed")
            }
    }

}
