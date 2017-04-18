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

        scrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        //self.contentView.addSubview(scrollView)
        scrollView.contentSize = CGSize(width: WIDTH, height: 2*HEIGHT - selectHeight)
        scrollView.delegate = self
//        scrollView.contentOffset = CGPoint(x: 0, y: (HEIGHT - selectHeight)/2)
        scrollView.maximumZoomScale = 3.0
        scrollView.minimumZoomScale = 1.0
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
       
        imageView = UIImageView()
        imageView.frame = CGRect(x: 0, y: (HEIGHT - selectHeight)/2, width: WIDTH, height: HEIGHT)
        //scrollView.addSubview(imageView)
        
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(ZZChooseClipCollectionViewCell.chooseDoubleTapImg))
        doubleTap.numberOfTouchesRequired = 1
        doubleTap.numberOfTapsRequired = 2
        self.imageView.addGestureRecognizer(doubleTap)
        self.imageView.isUserInteractionEnabled = true
        
        

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
        
        
        // 获取上下文 size表示图片大小 false表示透明 0表示自动适配屏幕大小
        UIGraphicsBeginImageContextWithOptions(UIScreen.main.bounds.size, false, 0)
        
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.5).cgColor)
        context?.fill(UIScreen.main.bounds)
        context?.addRect(CGRect(x: 0, y: (HEIGHT - selectHeight)/2, width: WIDTH , height: selectHeight))
        context?.setBlendMode(.clear)
        context?.fillPath()
        
        // 绘制框框
        context?.setBlendMode(.color)
        context?.setStrokeColor(UIColor.white.cgColor)
        context?.setLineWidth(1.0)
        context?.stroke(CGRect(x: 0, y: (HEIGHT - selectHeight)/2 - 1 , width: WIDTH , height: selectHeight + 2*1))
        context?.strokePath()
        
        
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        let selectarea = UIImageView(image: img)
        selectarea.frame.origin = CGPoint(x: 0, y: 0)
        self.contentView.addSubview(selectarea)
        
        
    }
    
    var imageSize:CGSize?{
        
        didSet {
            print(imageSize!)
            
            scrollView.backgroundColor = UIColor.black
            
            
            guard let imageView = imageView else {
                return
            }
            self.contentView.backgroundColor = UIColor.white
            imageView.contentMode = .scaleAspectFit
            scrollView.delegate = self
            imageView.center = scrollView.center
            

            
            if (imageSize?.width)! > WIDTH {
                imageView.frame.size = CGSize(width: WIDTH, height: imageView.bounds.height / imageView.bounds.width * WIDTH)
                imageView.center = scrollView.center
            }
            if (imageSize?.width)! > HEIGHT{
                imageView.frame.size = CGSize(width: HEIGHT, height: imageView.bounds.width / imageView.bounds.height * HEIGHT)
                imageView.center = scrollView.center
            }

            self.contentView.addSubview(scrollView)
            scrollView.addSubview(imageView)
            
            let topInsert = (imageView.frame.size.height - selectHeight)/2
            let bottomInsert = (HEIGHT - imageView.frame.size.height)/2
            
            scrollView.contentSize = CGSize(width: WIDTH, height: HEIGHT + imageView.frame.height / 2)
            scrollView.contentInset = UIEdgeInsets(top: topInsert, left: 0, bottom: -bottomInsert, right: 0)
            
            self.makeGraphicsAlpha()

        }
    }
}

// MARK: - UI
extension ZZChooseClipCollectionViewCell{
    
    open func clipImage()->UIImage?{
        
        let rect  = UIScreen.main.bounds
        
        // 记录屏幕缩放比
        let scal = UIScreen.main.scale
        
        // 上下文
        UIGraphicsBeginImageContextWithOptions(rect.size, true, 0)
        
        let context = UIGraphicsGetCurrentContext()
        
        UIApplication.shared.keyWindow?.layer.render(in: context!)
        
        // 截全屏
        guard let img = UIGraphicsGetImageFromCurrentImageContext()?.cgImage,
            let result = img.cropping(to: CGRect(x: scal * 1, y: (HEIGHT - selectHeight)/2 * scal, width: (self.WIDTH - 2*CGFloat(1)) * scal, height: selectHeight * scal))   else{
                return nil
        }
        // 关闭上下文
        UIGraphicsEndImageContext()
        
        return UIImage(cgImage: result, scale: scal, orientation: .up)
        
    }
    
}

// MARK: - ScrollViewDelegate
extension ZZChooseClipCollectionViewCell:UIScrollViewDelegate{
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.imageView
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        
        //当捏或移动时，需要对center重新定义以达到正确显示位置
        var centerX = scrollView.center.x
        var centerY = scrollView.center.y
        centerX = scrollView.contentSize.width > scrollView.frame.size.width ? scrollView.contentSize.width / 2 : centerX
        centerY = scrollView.contentSize.height > scrollView.frame.size.height ?scrollView.contentSize.height / 2 : centerY
        self.imageView?.center = CGPoint(x: centerX, y: centerY)
        
        guard let imgView = imageView else {
            return
        }
        
        let topInsert = (imgView.frame.size.height - selectHeight)/2
        let bottomInsert = (HEIGHT - imgView.frame.size.height)/2
        scrollView.contentSize = CGSize(width: imgView.frame.width, height: HEIGHT + imgView.frame.height / 2)
        scrollView.contentInset = UIEdgeInsets(top: topInsert, left: 0, bottom: -bottomInsert, right: 0)
        
    }
}





