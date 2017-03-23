//
//  PhotoPickerViewController.swift
//  BingLiYun
//
//  Created by 刘伟 on 08/12/2016.
//  Copyright © 2016 上海凌晋信息技术有限公司. All rights reserved.
//

import UIKit

typealias PhotosSelectedFinished = (_ photos:[PhotoModel]?) -> Void

class PhotoPickerViewController: BaseViewController {

    
    var selectPhotoOfMax: Int = 1 // 一次最多选择多少张图片
    
    
    func showIn(vc:UIViewController, completedHandle:PhotosSelectedFinished)
    {
        PermissionUtils.checkPhotoLibraryPermissions({ (granted) in
            if granted
            {
                let photoGridViewController = PhotoGridViewController()
                let navi = BaseNavigationController(rootViewController: photoGridViewController)
                
                vc.present(navi, animated: true, completion: nil)
                
            }else{
                let ok = AlertViewButtonItem(inLabel: "确定")
                let alertView = AlertView(title: nil, message: "手机相册访问权限提示", cancelButtonItem: ok, otherButtonItems: nil)
                alertView.show()
            }
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

}
