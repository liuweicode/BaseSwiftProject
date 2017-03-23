//
//  CycleView.swift
//  LinkimFoundation
//
//  Created by 刘伟 on 16/7/7.
//  Copyright © 2016年 CocoaPods. All rights reserved.
//

import UIKit
import SnapKit

protocol CycleViewDataSource {
    
    /// 数据源数量
    func itemCount() -> NSInteger
    
    /// 自定义展示样式
    func collectionView(_ collectionView: UICollectionView, cellForItemAtIndexPath indexPath: IndexPath)->UICollectionViewCell
}

protocol CycleViewDelegate {
    
    func itemDidSelected(_ indexPath:IndexPath)
}

let maxSection:NSInteger = 300
let defaultSection:NSInteger = (maxSection - 1) / 2

class CycleView: UIView, UICollectionViewDataSource, UICollectionViewDelegate {

    /// 数据源
    var dataSource: CycleViewDataSource?
    
    /// 代理
    var delegate: CycleViewDelegate?
    
    /// 是否自动滚动 默认是
    var isAutoScroll: Bool = true
    
    /// 是否循环播放 默认是
    var isLoop: Bool = true
    
    /// 默认循环时间5s
    var timerInterval: TimeInterval = 5
    
    /// 翻页控件
    fileprivate var pageView: CyclePageBaseView?
    
    var didSetupConstraints = false
    
    let collectionView:UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumLineSpacing = 0
        flowLayout.scrollDirection = .horizontal
        
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: flowLayout)
        collectionView.backgroundColor = UIColor.clear
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.alwaysBounceHorizontal = true
        collectionView.bounces = true
        return collectionView
    }()
    
    fileprivate var itemCount:NSInteger = 0
    
    init()
    {
        super.init(frame: CGRect.zero)
        collectionView.dataSource = self
        collectionView.delegate = self
        addSubview(collectionView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
       
        let flowLayout = self.collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        flowLayout.itemSize = self.frame.size
        self.collectionView.contentInset = UIEdgeInsets.zero
        self.collectionView.contentOffset = CGPoint.zero
        
        self.settingSelectedItemWithRow(0)
        
        if self.isAutoScroll {
            _ = self.timer(selector: #selector(handleTimer(_:)), timeInterval: timerInterval,repeats: true)
        }
        super.layoutSubviews()
    }
    
    func settingSelectedItemWithRow(_ indexRow:NSInteger)
    {
        let count = self.dataSource?.itemCount() ?? 0
        if count > 0 && self.isLoop {
            ANT_LOG_INFO("\(defaultSection)")
            self.collectionView.scrollToItem(at: IndexPath(item: indexRow,section: defaultSection), at: UICollectionViewScrollPosition(), animated: false)
        }
    }
    
    override func updateConstraints() {
        
        if !didSetupConstraints {
            
            collectionView.snp.makeConstraints( { (make) in
                make.edges.equalTo(self)
            })
            
            didSetupConstraints = true
        }
        super.updateConstraints()
    }
    
    func registerClass(_ cls:AnyClass,identifier:String)
    {
        self.collectionView.register(cls, forCellWithReuseIdentifier: identifier)
    }
    
    func reloadData()
    {
        self.collectionView.reloadData()
    }
    
    func setPageView(_ pageView:CyclePageBaseView)
    {
        self.pageView?.removeFromSuperview()
        self.pageView = pageView
        self.addSubview(self.pageView!)
    }
    
    func getPageView() -> CyclePageBaseView? {
        return self.pageView
    }
    
    func setItemCount(_ itemCount:NSInteger)
    {
        self.itemCount = itemCount
        self.pageView?.setPageSize(itemCount)
    }
    
    func handleTimer(_ timer:Timer)
    {
        if self.itemCount == 0 {
            return
        }
        
        let visiablePath = self.collectionView.indexPathsForVisibleItems.first!
        var section = (visiablePath as NSIndexPath).section, row = (visiablePath as NSIndexPath).row
        
        if row == self.itemCount - 1 {
            row = 0
            section = section + 1
        }else{
            row = row + 1
        }
        
        self.collectionView.scrollToItem(at: IndexPath(item: row,section: section), at: .left, animated: true)
        
        if section == maxSection - 1 {
            self.collectionView.scrollToItem(at: IndexPath(item: row,section: defaultSection), at: UICollectionViewScrollPosition(), animated: false)
        }
    }
    
    // UICollectionView DataSource
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return self.isLoop ? maxSection : 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.itemCount = self.dataSource?.itemCount() ?? 0
        return self.itemCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return self.dataSource!.collectionView(collectionView, cellForItemAtIndexPath: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.delegate?.itemDidSelected(indexPath)
    }
    
    // UIScrollViewDelegate
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.resetPageIndex()
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        if self.isAutoScroll {
            self.cancelAllTimers()
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if self.isAutoScroll {
            _ = self.timer(selector: #selector(handleTimer(_:)), timeInterval: timerInterval,repeats: true)
        }
    }
    
    // 计算当前页
    func resetPageIndex()
    {
        let pageWidth = self.collectionView.frame.size.width
        if pageWidth == 0 { return }
        let page = floor((self.collectionView.contentOffset.x - pageWidth / 2) / pageWidth) + 1
        if let pageSize = self.pageView?.getPagetSize() , pageSize > 0{
            let pageIndex = Int(page.truncatingRemainder(dividingBy: CGFloat(pageSize)))
            self.pageView?.setPageIndex(pageIndex)
        }
    }
    
}
