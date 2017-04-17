//
//  ZZChooseClipViewController.swift
//  BaseSwiftProject
//
//  Created by 杨柳 on 2017/4/17.
//  Copyright © 2017年 上海凌晋信息技术有限公司. All rights reserved.
//

import UIKit
import Photos

class ZZChooseClipViewController: UIViewController {

    let asset:PHAsset
    
    var collection:UICollectionView!
    
    var cancel = UIButton()
    var sure = UIButton()
    
    /// 点击完成时的回调
    var completeHandler:((_ assets:[PHAsset])->())?

    init(asset:PHAsset){
        self.asset = asset
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let layout =  UICollectionViewFlowLayout()
        layout.itemSize = UIScreen.main.bounds.size
        
        collection = UICollectionView(frame: UIScreen.main.bounds, collectionViewLayout: layout)
        collection.delegate = self
        collection.dataSource = self
        collection.register(ZZChooseClipCollectionViewCell.classForCoder(), forCellWithReuseIdentifier: "ZZPhotoChooseCell")
        view.addSubview(collection)
        
        cancel = UIButton (type: .custom)
        cancel.setTitle("取消", for: .normal)
        cancel.setTitleColor(.white, for: .normal)
        cancel.backgroundColor = .clear
        cancel.frame = CGRect(x: 10, y: ScreenHeight - 90, width: 50, height: 30)
        cancel.addTarget(self, action: #selector(backToChoose), for: .touchUpInside)
        self.view.addSubview(cancel)

        
        sure = UIButton (type: .custom)
        sure.setTitle("确定", for: .normal)
        sure.setTitleColor(.white, for: .normal)
        sure.backgroundColor = .clear
        sure.frame = CGRect(x:ScreenWidth - 60, y: ScreenHeight - 90, width: 50, height: 30)
        sure.addTarget(self, action: #selector(goToSure), for: .touchUpInside)
        self.view.addSubview(sure)
        
    }
    
    func backToChoose(){
        self.navigationController?.popViewController(animated: true)
    }
    
    func goToSure(){
        self.navigationController?.dismiss(animated: true, completion: {
            var assets:[PHAsset] = []
            assets.append(self.asset)
            self.completeHandler?([self.asset])
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated) 
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        UIApplication.shared.isStatusBarHidden = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}

extension ZZChooseClipViewController:UICollectionViewDataSource,UICollectionViewDelegate{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ZZPhotoChooseCell", for: indexPath) as! ZZChooseClipCollectionViewCell
        
        let option = PHImageRequestOptions();
        option.deliveryMode = PHImageRequestOptionsDeliveryMode.opportunistic;
        option.isSynchronous = true;
        PHCachingImageManager.default().requestImage(for: asset,                                              targetSize:UIScreen.main.bounds.size,                                                     contentMode: PHImageContentMode.aspectFill, options: option, resultHandler: { (result, info) in
            cell.imageView?.image = result!
            cell.imageSize = result!.size
        })

        
        return cell
    }
    
    
    
    
}






