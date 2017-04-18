//
//  ZZAssetGridViewController.swift
//  ZZImagePicker
//
//  Created by duzhe on 16/4/27.
//  Copyright © 2016年 dz. All rights reserved.
//

import UIKit
import Photos

let zz_sw:CGFloat = UIScreen.main.bounds.width
let zz_sh:CGFloat = UIScreen.main.bounds.height

class ZZAssetGridViewController: UIViewController {
    
    @IBOutlet weak var collectionView:UICollectionView!
    @IBOutlet weak var toolBar:UIToolbar!

    @IBOutlet weak var preview: UIBarButtonItem!
    @IBOutlet weak var sendItem: UIBarButtonItem!
    
    /// 后去到的结果 存放的PHAsset
    var assetsFetchResults:PHFetchResult<PHAsset>!
    
    /// 带缓存的图片管理对象
    var imageManager:PHCachingImageManager!
    
    /// 小图大小
    var assetGridThumbnailSize:CGSize!
    
    /// 预缓存Rect
    var previousPreheatRect:CGRect!
    
    /// 最多可以选择的个数
    public var maxSelected:Int = 9
    
    /// 记录选中的数组
    var selectedArray:NSMutableArray!
    
    /// 点击完成时的回调
    var completeHandler:((_ assets:[PHAsset])->())?
    
    lazy var selectedLayer:ZZImageSelectedLabel = {
        let tmpLayer = ZZImageSelectedLabel(toolBar:self.toolBar)
        return tmpLayer
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        if assetsFetchResults == nil {
            // 如果没有传入值 则获取所有资源
            let allPhotosOptions = PHFetchOptions()
            allPhotosOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
            allPhotosOptions.predicate = NSPredicate(format: "mediaType = %d", PHAssetMediaType.image.rawValue)
            assetsFetchResults = PHAsset.fetchAssets(with: PHAssetMediaType.image,options: allPhotosOptions)
            
        }
        
        // 初始化和重置缓存
        self.imageManager = PHCachingImageManager()
        self.resetCachedAssets()

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.selectedArray = NSMutableArray(capacity: 10)
        self.collectionView.backgroundColor = UIColor.white

        // 获取流布局对象并设置itemSize 设置允许多选
        let layout = (self.collectionView.collectionViewLayout as! UICollectionViewFlowLayout)
        layout.itemSize = CGSize(width: UIScreen.main.bounds.size.width/4-1,height: UIScreen.main.bounds.size.width/4-1)
        self.collectionView.allowsMultipleSelection = true
        
        if self.maxSelected == 1 {
            self.collectionView.snp.makeConstraints { (make) in
            make.bottom.equalTo(self.view)
            }
        }
        
        let rightBarItem = UIBarButtonItem(title: "取消", style: UIBarButtonItemStyle.plain, target: self, action: #selector(ZZAssetGridViewController.cancel))
        self.navigationItem.rightBarButtonItem = rightBarItem
        
        self.preview.action = #selector(ZZAssetGridViewController.previewImage)
        self.sendItem.action = #selector(ZZAssetGridViewController.finishSelect)
        
        self.disableItems()
        
        self.navigationController?.navigationBar.tintColor = UIColor.black
        

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.shared.statusBarStyle = .default
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        // 计算出小图大小 （ 为targetSize做准备 ）
        let scale = UIScreen.main.scale
        let cellSize = (self.collectionView.collectionViewLayout as! UICollectionViewFlowLayout).itemSize
        assetGridThumbnailSize = CGSize( width: cellSize.width*scale , height: cellSize.height*scale)
        if self.maxSelected == 1 {
            self.toolBar.isHidden = true
            self.collectionView.frame = CGRect(x: 0, y: 0, width: ScreenWidth, height: UIScreen.main.bounds.size.height)
            self.collectionView.reloadData()
            
        }

    }
    
    // 是否页面加载完毕 ， 加载完毕后再做缓存 否则数值可能有误
    var didLoad = false
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)

        didLoad = true
    }
    
    fileprivate func enableItems(){
        preview.isEnabled = true
        sendItem.isEnabled = true
    }
    
    fileprivate func disableItems(){
        preview.isEnabled = false
        sendItem.isEnabled = false
    }

    
    /**
    重置缓存
     */
    func resetCachedAssets(){
        self.imageManager.stopCachingImagesForAllAssets()
        self.previousPreheatRect = CGRect.zero
    }
    
    /**
     取消
     */
    func cancel() {
        UIApplication.shared.statusBarStyle = .lightContent
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
    
    /**
     获取已选择个数
     
     - returns: count
     */
    func selectedCount() -> Int {
        return self.collectionView.indexPathsForSelectedItems?.count ?? 0
    }
}

extension ZZAssetGridViewController{

    // TODO - 预览
    func previewImage() {
        // 预览
        var assets:[PHAsset] = []
        if let indexPaths = self.selectedArray{
            for indexPath in indexPaths{
                assets.append(assetsFetchResults[(indexPath as! NSIndexPath).row] )
            }
        }
        
        let vc = ZZAssetPreviewVC(assets:assets , maxSelected:self.maxSelected)
        vc.selectedImg = assets
        
        vc.imageSelectedArray { (array) in
            let select:(NSMutableArray) = []
            for asset:PHAsset in array {
                select.add(NSIndexPath(item: self.assetsFetchResults.index(of: asset), section: 0))
            }
            self.selectedArray = select
            self.checkSelect()
            self.collectionView.reloadData()
            
        }

        self.navigationController?.pushViewController(vc, animated: true)
    }

    /**
     点击完成，取出已选择的图片资源 调用闭包
     */
    func finishSelect(){
        var assets:[PHAsset] = []
        if let indexPaths = self.selectedArray{
            for indexPath in indexPaths{
                assets.append(assetsFetchResults[(indexPath as! NSIndexPath).row] )
            }
        }
        self.selectedArray.removeAllObjects()
        self.selectedArray = nil
        self.navigationController?.dismiss(animated: true, completion: {
            
            self.completeHandler?(assets)
        })
    }
    
    
    /// 点击单张图片预览整个相册
    func previewAllImage(_ index:NSIndexPath){
        // 预览
        var assets:[PHAsset] = []
            for a in 0...self.assetsFetchResults.count-1{
                let indexPath = NSIndexPath(item: a as NSInteger, section: 0)
                assets.append(assetsFetchResults[(indexPath as NSIndexPath).row] )
        }
        
        let vc = ZZAssetPreviewVC(assets:assets , maxSelected:self.maxSelected)
        
        
        //去除被选中的图片(做预览右上角的勾勾)
        var selected:[PHAsset] = []
        if let indexPaths = self.selectedArray{
            for indexPath in indexPaths{
                selected.append(assetsFetchResults[(indexPath as! NSIndexPath).row] )
            }
        }

        vc.currentInde = index
        vc.selectedImg = selected
        
        vc.imageSelectedArray { (array) in
            let select:(NSMutableArray) = []
            for asset:PHAsset in array {
                select.add(NSIndexPath(item: self.assetsFetchResults.index(of: asset), section: 0))
            }
            self.selectedArray = select
            self.checkSelect()
            self.collectionView.reloadData()
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    func checkSelect(){

        if self.selectedArray.count == 0{
            self.disableItems()
        }
        
        if self.selectedArray.count > 0 && self.selectedArray.count < self.maxSelected{
            self.enableItems()
        }
        
        if self.selectedArray.count > maxSelected{
            
        }
        
        self.selectedLayer.num = self.selectedArray.count
        
    }
    
}


//MARK: - UICollectionViewDataSource,UICollectionViewDelegate
extension ZZAssetGridViewController:UICollectionViewDataSource,UICollectionViewDelegate{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.assetsFetchResults.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ZZGridViewCell
        let asset = self.assetsFetchResults[(indexPath as NSIndexPath).row]
        
        self.imageManager.requestImage(for: asset, targetSize: assetGridThumbnailSize, contentMode: PHImageContentMode.aspectFill, options: nil) { (image, nfo) in
            cell.imageView.image = image
        }
        
        
        
        //设置进入状态(右上角是否被点击)
        cell.isSelected = self.selectedArray.contains(indexPath) ? true:false
        
        //点击右上角
        cell.selectRightBtn(closure: { 

            //根据是否点选进行判断
            if !cell.isSelected{
                self.selectedArray.add(indexPath)
                let sc = self.selectedArray.count
                if sc > self.maxSelected {
                    // 如果选择的个数大于最大选择数 设置为不选中状态
                    self.selectedArray.removeLastObject()
                    self.selectedLayer.tooMoreAnimate()
                }else{
                    self.selectedLayer.num = sc
                    if sc > 0 && !self.sendItem.isEnabled{
                        self.enableItems()
                    }
                    cell.showAnim()
                    cell.isSelected = cell.isSelected ? false:true
                }
            }
            else if cell.isSelected{
                self.selectedArray.removeObject(at: self.selectedArray.index(of: indexPath))
                let sc = self.selectedArray.count
                self.selectedLayer.num = sc
                if sc == 0{
                    self.disableItems()
                }
                cell.showAnim()
                cell.isSelected = cell.isSelected ? false:true
            }
            
        })
        
        //点击整个图片预览
        cell.selectImgBtn {
            
            if self.maxSelected == 1{
                let asset = self.assetsFetchResults[(indexPath as NSIndexPath).row]
                
                let chooseC = ZZChooseClipViewController(asset: asset)
                chooseC.delegate = self as? SwiftyPhotoClipperDelegate
                self.modalPresentationStyle = UIModalPresentationStyle.custom
                self.navigationController?.pushViewController(chooseC, animated: true)
                
                
                return
            }
            
            self.previewAllImage(indexPath as NSIndexPath)

        }
        
        if self.maxSelected == 1 {
            cell.selectedImageView.isHidden = true
            cell.SelectedButton.isHidden = true
        }
        
        return cell
    }
  
    /**
     在滚动中不断更新缓存
     */
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.updateCachedAssets()
    }
    
    /**
     更新缓存资源
     */
    func updateCachedAssets()  {
        
        let isViewVisible = self.isViewLoaded && didLoad
        
        if !isViewVisible{
            // 没有加载完成前 取的数据有误
            return
        }
        
        var preheatRect = self.collectionView.bounds
        preheatRect = preheatRect.insetBy(dx: 0, dy: -0.5*preheatRect.height)
        
        let delta = abs(preheatRect.midY - self.previousPreheatRect.midY)
        if delta > self.collectionView.bounds.height / 3.0{
            
            var addedIndexPaths = [IndexPath]()
            var removedIndexPaths = [IndexPath]()
            self.computeDifferenceBetweenRect(self.previousPreheatRect, andRect: preheatRect, removedHandler: { (removedRect) in
                    let indexPaths = self.collectionView.zz_indexPathsForElementsInRect(removedRect)
                    removedIndexPaths = removedIndexPaths.filter({ (indexPath) -> Bool in
                        return !indexPaths.contains(indexPath)
                    })
                }, addedHandler: { (addedRect) in
                    let indexPaths = self.collectionView.zz_indexPathsForElementsInRect(addedRect)
                    indexPaths.forEach({ (indexPath) in
                        addedIndexPaths.append(indexPath)
                    })
            })
            
            let assetsToStartCaching = self.assetsAtIndexPaths(addedIndexPaths)
            let assetsToStopCaching = self.assetsAtIndexPaths(removedIndexPaths)
            
            self.imageManager.startCachingImages(for: assetsToStartCaching, targetSize: assetGridThumbnailSize, contentMode: PHImageContentMode.aspectFill, options: nil)
            self.imageManager.stopCachingImages(for: assetsToStopCaching, targetSize: assetGridThumbnailSize, contentMode: PHImageContentMode.aspectFill, options: nil)
            
            self.previousPreheatRect = preheatRect
        }
    }
    
    func computeDifferenceBetweenRect(_ oldRect:CGRect, andRect newRect:CGRect,removedHandler:((_ removedRect:CGRect)->())?,addedHandler:((_ addedRect:CGRect)->())?) {
        
        if newRect.intersects(oldRect){ //判断两个矩形是否相交
            
            let oldMaxY = oldRect.maxY
            let oldMinY = oldRect.minY
            let newMaxY = newRect.maxY
            let newMinY = newRect.minY
            if newMaxY>oldMaxY{
                let rectToAdd = CGRect(x: newRect.origin.x, y: oldMaxY , width: newRect.size.width, height: newMaxY-oldMaxY)
                addedHandler?(rectToAdd)
            }
            
            if oldMinY > newMinY {
                let rectToAdd = CGRect(x: newRect.origin.x, y: newMinY, width: newRect.size.width, height: (oldMinY - newMinY))
                addedHandler?(rectToAdd)
            }
            
            if newMaxY < oldMaxY {
                let rectToRemove = CGRect(x: newRect.origin.x, y: newMaxY, width: newRect.size.width, height: (oldMaxY - newMaxY))
                removedHandler?(rectToRemove);
            }
            
            if oldMinY < newMinY {
                let rectToRemove = CGRect(x: newRect.origin.x, y: oldMinY, width: newRect.size.width, height: (newMinY - oldMinY))
                removedHandler?(rectToRemove)
            }
            
        }else{
            addedHandler?(newRect);
            removedHandler?(oldRect);
        }
    }
    
    func assetsAtIndexPaths(_ indexPaths:[IndexPath]) -> [PHAsset] {
        var assets = [PHAsset]()
        for indexPath in indexPaths{
            let asset = self.assetsFetchResults[(indexPath as NSIndexPath).row]
            assets.append(asset)
        }
        return assets
    }
    
}



