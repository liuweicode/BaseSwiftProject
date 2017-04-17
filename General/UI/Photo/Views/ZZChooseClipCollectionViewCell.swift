//
//  ZZChooseClipCollectionViewCell.swift
//  BaseSwiftProject
//
//  Created by 杨柳 on 2017/4/17.
//  Copyright © 2017年 上海凌晋信息技术有限公司. All rights reserved.
//

import UIKit

extension CGSize{
    /** 按比例缩放 */
    func chooseRatioSize(_ ratio: CGFloat) -> CGSize{
        return CGSize(width: self.width / ratio, height: self.height / ratio)
    }
}

func chooseDecisionShowSize(_ imgSize: CGSize) ->CGSize{
    let heightRatio = imgSize.height / UIScreen.main.bounds.size.height
    let widthRatio = imgSize.width / UIScreen.main.bounds.size.width
    if heightRatio > 1 && widthRatio>1 {return imgSize.chooseRatioSize(max(heightRatio, widthRatio))}
    if heightRatio > 1 && widthRatio <= 1 {return imgSize.chooseRatioSize(heightRatio)}
    if heightRatio <= 1 && widthRatio > 1 {return imgSize.chooseRatioSize(widthRatio)}
    if heightRatio <= 1 && widthRatio < 1 {return imgSize.chooseRatioSize(max(widthRatio,heightRatio))}
    return imgSize
}

class ZZChooseClipCollectionViewCell: UICollectionViewCell {
    
    var imageView:UIImageView!
    var scrollView:UIScrollView!
    
    var selectHeight = UIScreen.main.bounds.size.width
    var moreHeight:CGFloat! = 0.0000
    var WIDTH = UIScreen.main.bounds.size.width
    var HEIGHT = UIScreen.main.bounds.size.height
    
    override init(frame:CGRect){
        super.init(frame: frame)
        UIApplication.shared.isStatusBarHidden = true

        scrollView = UIScrollView(frame: self.contentView.bounds)
        self.contentView.addSubview(scrollView)
        scrollView.contentSize = CGSize(width: WIDTH, height: 2*HEIGHT - selectHeight)
        scrollView.delegate = self
        scrollView.contentOffset = CGPoint(x: 0, y: (HEIGHT - selectHeight)/2)
        scrollView.maximumZoomScale = 3.0
        scrollView.minimumZoomScale = 1.0
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
       
        imageView = UIImageView()
        imageView.frame = CGRect(x: 0, y: (HEIGHT - selectHeight)/2, width: WIDTH, height: HEIGHT)
        imageView.contentMode = .scaleAspectFit
        scrollView.addSubview(imageView)
        
        imageView.contentMode = .scaleAspectFit
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(ZZChooseClipCollectionViewCell.chooseDoubleTapImg))
        doubleTap.numberOfTouchesRequired = 1
        doubleTap.numberOfTapsRequired = 2
        self.imageView.addGestureRecognizer(doubleTap)
        self.imageView.isUserInteractionEnabled = true
        
        self.makeGraphicsAlpha()
        

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func calSize(){
        scrollView.zoomScale = 1.0
        guard let image = self.imageView.image else {return }
        let size = image.size
        let mbSize = chooseDecisionShowSize(size)
        print(mbSize)
        imageView.frame.size = mbSize
        imageView.center = scrollView.center
        
    }
    
    func chooseDoubleTapImg(_ ges:UITapGestureRecognizer){

        if scrollView.zoomScale == 1.0 {
            UIView.animate(withDuration: 0.5, animations: {
                self.scrollView.zoomScale = 3.0
            })
            
        }else{
            UIView.animate(withDuration: 0.5, animations: {
                self.scrollView.zoomScale = 1.0
            })
        }
    }
    
    func makeGraphicsAlpha(){
        
        UIGraphicsBeginImageContextWithOptions(UIScreen.main.bounds.size, false, 0)
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.5).cgColor)
        context?.fill(UIScreen.main.bounds)
        context?.addRect(CGRect(x: 0, y: (HEIGHT-selectHeight)/2, width: WIDTH , height: selectHeight))
        context?.setBlendMode(.clear)
        context?.fillPath()
        
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        let selectarea = UIImageView(image: img)
        selectarea.frame.origin = CGPoint(x: 0, y: 0)
        self.contentView.addSubview(selectarea)
        
        
        
    }
    
    var imageSize:CGSize?{
        
        didSet {
            print(imageSize!)
            
            //重设contentoffset
            let finalSize = CGSize(width: WIDTH, height: (imageSize?.height)! * WIDTH / (imageSize?.width)! - selectHeight + HEIGHT)
            scrollView.contentSize = finalSize
            
            let contentY = Float(finalSize.height - selectHeight)
            scrollView.contentOffset = CGPoint(x: 0, y:Int(fabsf(contentY)/2))
            imageView.frame = CGRect(x: CGFloat(0), y: CGFloat(Int(fabsf(contentY)/2)), width: WIDTH, height: HEIGHT)
            
            moreHeight = scrollView.contentSize.height - ScreenHeight
        }
    }
    
    
    
}

extension ZZChooseClipCollectionViewCell:UIScrollViewDelegate{
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.imageView
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        var xcenter = scrollView.center.x
        var ycenter = scrollView.center.y
        xcenter = scrollView.contentSize.width > scrollView.frame.size.width ? scrollView.contentSize.width/2:xcenter
        ycenter = scrollView.contentSize.height > scrollView.frame.size.height ? scrollView.contentSize.height/2:ycenter
        imageView.center = CGPoint(x: xcenter, y: ycenter)
    }
}




