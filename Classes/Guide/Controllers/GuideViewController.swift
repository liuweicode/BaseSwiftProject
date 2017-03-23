//
//  GuideViewController.swift
//  Dancing
//
//  Created by 刘伟 on 28/10/2016.
//  Copyright © 2016 上海凌晋信息技术有限公司. All rights reserved.
//

import UIKit

class GuideViewController: BaseViewController {

    lazy var rootView = GuideView()
    
    lazy var dataSource = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initData()
        rootView.cycleView.dataSource = self
        rootView.cycleView.delegate = self
        rootView.pageView.setPageSize(self.dataSource.count)
        view.addSubview(rootView)
        rootView.snp.makeConstraints { (make) in
            make.edges.equalTo(view)
        }
    }

    func initData()
    {
        for i in 1...3
        {
//            if UIScreen.sizeType() == .screen3_5Inch
//            {
//                self.dataSource.append("guide_\(i)_3.5.jpg")
//            }else{
                self.dataSource.append("guide_\(i).jpg")
//            }
        }
    }
}

extension GuideViewController:CycleViewDataSource, CycleViewDelegate
{
    // CycleViewDataSource
    func itemCount() -> NSInteger {
        return self.dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAtIndexPath indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: GuideCollectionViewCell.self), for: indexPath) as! GuideCollectionViewCell
        cell.setImage(self.dataSource[indexPath.row])
        cell.button.isHidden = !(indexPath.row == 2)
        return cell
    }
    
    // CycleViewDelegate
    func itemDidSelected(_ indexPath: IndexPath) {
        print("itemDidSelected:\(indexPath.section) \(indexPath.row)")
    }
}
