//
//  ZZAssetPreviewVCViewController.swift
//  ZZImagePicker
//  预览
//  Created by duzhe on 16/5/3.
//  Copyright © 2016年 dz. All rights reserved.
//

import UIKit
import Photos

typealias ImageSelected = (_ array:[PHAsset])->Void

class ZZAssetPreviewVC: UIViewController ,UICollectionViewDelegate, UIScrollViewDelegate{
    
    
    var assets:[PHAsset]
    open var collectionView:UICollectionView!
    
    /// 带缓存的图片管理对象
    var imageManager:PHCachingImageManager
    var assetGridThumbnailSize:CGSize!
    
    
    /// 进入即显示的界面，在点击单页预览整个相册的时候才有
    public var currentInde:NSIndexPath? = NSIndexPath(item: 0, section: 0)
    var isCollectionLoaded:Bool? = false
    var isFirst:Bool! = true
    
    
    /// 已选中的照片数组
    var selectedImg:[PHAsset]!
    
    /// 最多可以选择的个数
    var maxSelected:Int = 9

    /// 右上角选中图标，可以直接在此处进行选中与否状态(利用block回调)
    var rgBarBtnItem:UIButton!
    
    var imageSelected:ImageSelected?
    func imageSelectedArray(array:ImageSelected?){
        imageSelected = array
    }
    
    
    /// 初始化存储照片信息数组
    init(assets:[PHAsset],maxSelected:Int){
        self.assets = assets
        self.imageManager = PHCachingImageManager()
        self.maxSelected = maxSelected
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func scrollToItem(_ index:NSIndexPath){
        if isCollectionLoaded! {
            collectionView.scrollRectToVisible(CGRect(origin: CGPoint(x: UIScreen.main.bounds.size.width * CGFloat(index.row), y: 0), size:UIScreen.main.bounds.size), animated: false)
        }
    }
   
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.black
        //self.selectedImg = NSMutableArray(capacity: 10)
        
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.itemSize = self.view.bounds.size
        layout.scrollDirection = .horizontal
        self.automaticallyAdjustsScrollViewInsets = false
        // automaticallyAdjustsScrollViewInsets这个属性默认将controller上所有的scrollView都向下偏移64，由于笔者被其所坑，找了三天bug才找出它来，所以一定要慎用此属性。
        collectionView = UICollectionView(frame: self.view.bounds, collectionViewLayout: layout)
        self.view.addSubview(collectionView)
        collectionView.backgroundColor = UIColor.black
        self.collectionView.register(ZZPhotoPreviewCell.self, forCellWithReuseIdentifier: "ZZPhotoPreviewCell")
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.isPagingEnabled = true
        
        var img = UIImage(named: "zz_image_cell")
        img=img?.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        rgBarBtnItem = UIButton(frame: CGRect(x: 0, y: 0, width: 50, height: 30))
        rgBarBtnItem.addTarget(self, action: #selector(ZZAssetPreviewVC.setSelecte), for: .touchUpInside)
        rgBarBtnItem.setImage(img, for: .normal)
        let item = UIBarButtonItem(customView: rgBarBtnItem)
        self.navigationItem.rightBarButtonItem = item
        
        // Do any additional setup after loading the view.
    }
    fileprivate var context = 0
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        // 计算出小图大小 （ 为targetSize做准备 ）
        let scale = UIScreen.main.scale
        let cellSize = (self.collectionView.collectionViewLayout as! UICollectionViewFlowLayout).itemSize
        assetGridThumbnailSize = CGSize(width: cellSize.width*scale , height: cellSize.height*scale)
        UIApplication.shared.isStatusBarHidden = true

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        UIApplication.shared.isStatusBarHidden = false

    }
    
    /// 点击左上角确定是否选择该图片
    func setSelecte(){
        //改变右上角对号状态，并且数组删除对应元素
        let a = collectionView.indexPathsForVisibleItems.last?.row
        if self.selectedImg.contains(self.assets[a!]) {
            
            self.selectedImg.remove(at:self.selectedImg.index(of: self.assets[a!])!)
            rgBarBtnItem.setImage(UIImage(named:"zz_image_cell"), for: .normal)
            if (imageSelected != nil){
                self.imageSelected!(self.selectedImg)
            }
        }
        
        else if !self.selectedImg.contains(self.assets[a!]) {

            if selectedImg.count >= self.maxSelected {
                let alter = UIAlertController(title: "提示", message: "最多可选\(self.maxSelected)张", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "好的", style: UIAlertActionStyle.default, handler: nil)
                alter.addAction(okAction)
                self.present(alter, animated: true, completion: nil)
                return
            }
            
            self.selectedImg.append(self.assets[a!])
            rgBarBtnItem.setImage(UIImage(named:"zz_image_cell_selected"), for: .normal)
            if (imageSelected != nil){
                self.imageSelected!(self.selectedImg)
            }

        }
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}



extension ZZAssetPreviewVC:UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ZZPhotoPreviewCell", for:  indexPath) as! ZZPhotoPreviewCell
        let asset = self.assets[(indexPath as NSIndexPath).row]
        self.imageManager.requestImage(for: asset, targetSize: assetGridThumbnailSize, contentMode: PHImageContentMode.aspectFill, options: nil) { (image, nfo) in
            cell.imageView.image = image
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.assets.count
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        if let cell = cell as? ZZPhotoPreviewCell{
            self.navigationItem.title = "\((indexPath as NSIndexPath).row+1) / \(self.assets.count)"
            
            self.rgBarBtnItem.setImage(UIImage(named: self.selectedImg.contains(self.assets[indexPath.row]) ? "zz_image_cell_selected":"zz_image_cell"), for: .normal)
            
            //rgBarBtnItem.tintColor = self.selectedImg.contains(self.assets[indexPath.row]) ? UIColor.green:UIColor.gray
            
            cell.calSize()
            
        }
        if !indexPath.isEmpty && isFirst!{
            self.isCollectionLoaded = true
            isFirst = false
            if (currentInde != nil) {
                self.scrollToItem(currentInde!)
            }
        }
    }
    

    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)

    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        //停止滚动的时候修改当前页，以及是否被选中
        self.navigationItem.title = "\((collectionView.indexPathsForVisibleItems.last?.row)! + 1) / \(self.assets.count)"
        
    }

    
}


