//
//  ViewController.swift
//  ZZImagePicker
//
//  Created by duzhe on 16/4/12.
//  Copyright © 2016年 dz. All rights reserved.
//  示例  _ = self.zz_presentPhotoVC(3)多张重写此方法(返回assets)
//  单张多写一个通知 NotificationCenter.default.addObserver(返回UIImage)

import UIKit
import Photos
var imageView:UIImageView!
var thumbnailSize:CGSize!

var assetss:([PHAsset])!

var collection:UICollectionView!

class TestPhotoViewController: UIViewController{
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "测试"
        imageView = UIImageView(frame: UIScreen.main.bounds)
        view.addSubview(imageView)
        
        let button = UIBarButtonItem(title: "测试", style: .plain, target: self, action: #selector(goPhoto(_:)))
        self.navigationItem.rightBarButtonItem = button
        
        NotificationCenter.default.addObserver(self, selector: #selector(didFinishClippingPhoto(dic:)), name: NSNotification.Name(rawValue: "ZZCollectionCell"), object: nil)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func goPhoto(_ sender: AnyObject) {
        
        _ = self.zz_presentPhotoVC(3) { (assets:([PHAsset])) in
            assetss = assets
            
            let layer = UICollectionViewFlowLayout()
            layer.itemSize = CGSize(width: UIScreen.main.bounds.size.width / CGFloat(4.1), height: UIScreen.main.bounds.size.width / CGFloat(4.1))
            
            collection = UICollectionView(frame: CGRect(x: 0, y: 64, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height), collectionViewLayout: layer)
            collection.tag = 10
            collection.delegate = self
            collection.dataSource = self
            collection.backgroundColor = .white
            collection.register(UICollectionViewCell.classForCoder(), forCellWithReuseIdentifier: "call")
            self.view.addSubview(collection)
            collection.reloadData()
        }
        
    }
    
    func didFinishClippingPhoto(dic: Notification) {
        //设置1张的回调 
        let imgv = UIImageView(frame: CGRect(x: 0, y: 100, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width))
        imgv.image = dic.userInfo?["image"] as? UIImage
        imgv.contentMode = .scaleAspectFit
        view.addSubview(imgv)

    }
}


extension TestPhotoViewController:UICollectionViewDelegate,UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return assetss.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "call", for: indexPath) as UICollectionViewCell
        
        let images = UIImageView(frame: cell.contentView.bounds)
        cell.contentView.addSubview(images)
        
        thumbnailSize = CGSize(width:UIScreen.main.bounds.size.width / CGFloat(assetss.count) , height:UIScreen.main.bounds.size.width / CGFloat(assetss.count))
        let option = PHImageRequestOptions();
        option.deliveryMode = PHImageRequestOptionsDeliveryMode.opportunistic;
        option.isSynchronous = true;
        
        PHCachingImageManager.default().requestImage(for: assetss[indexPath.row],                                              targetSize:thumbnailSize,                                                     contentMode: PHImageContentMode.aspectFill, options: option, resultHandler: { (result, info) in
            
            images.image = result!
        })
        return cell
        
    }
}







