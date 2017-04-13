//
//  ZZGridViewCell.swift
//  ZZImagePicker
//
//  Created by duzhe on 16/4/27.
//  Copyright © 2016年 dz. All rights reserved.
//

import UIKit

typealias SelectRight=()->Void

typealias SelectImg=()->Void


open class ZZGridViewCell: UICollectionViewCell {

    @IBOutlet weak var imageView:UIImageView!
    @IBOutlet weak var selectedImageView:UIImageView!
    @IBOutlet weak var imageButton: UIButton!
    @IBOutlet weak var SelectedButton: UIButton!
    
    var selectRight:SelectRight?
    //下面这个方法需要传入上个界面的someFunctionThatTakesAClosure函数指针
    func selectRightBtn(closure:SelectRight?){
        //将函数指针赋值给myClosure闭包，该闭包中涵盖了someFunctionThatTakesAClosure函数中的局部变量等的引用
        selectRight = closure
    }

    
    var selectImg:SelectImg?
    //下面这个方法需要传入上个界面的someFunctionThatTakesAClosure函数指针
    func selectImgBtn(closure:SelectImg?){
        //将函数指针赋值给myClosure闭包，该闭包中涵盖了someFunctionThatTakesAClosure函数中的局部变量等的引用
        selectImg = closure
    }
    
    open override var isSelected: Bool {
        didSet{
            if isSelected {
                //selectedImageView.image = UIImage(named: "zz_image_cell_selected")
                SelectedButton.setImage(UIImage(named: "zz_image_cell_selected"), for: .normal)
                
                
            }else{
                //selectedImageView.image = UIImage(named: "zz_image_cell")
                SelectedButton.setImage(UIImage(named: "zz_image_cell"), for: .normal)

            }
        }
    }
    
    func showAnim() {
        UIView.animateKeyframes(withDuration: 0.4, delay: 0, options: UIViewKeyframeAnimationOptions.allowUserInteraction, animations: {
            
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.2, animations: {
                self.selectedImageView.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
            })
            UIView.addKeyframe(withRelativeStartTime: 0.2, relativeDuration: 0.4, animations: {
                self.selectedImageView.transform = CGAffineTransform.identity
            })
            }, completion: nil)
    }
    
    open override func awakeFromNib() {
        super.awakeFromNib()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        selectedImageView.isUserInteractionEnabled = false
        SelectedButton.addTarget(self, action: #selector(ZZGridViewCell.touch), for: .touchUpInside)

        imageButton.addTarget(self, action: #selector(ZZGridViewCell.touchImg), for: .touchUpInside)

    }
    
    func touch(){
       
        if (selectRight != nil){
            //闭包隐式调用someFunctionThatTakesAClosure函数：回调。
            selectRight!()
        }
    }
    
    
    func touchImg(){
        if (selectImg != nil){
            selectImg!()
        }
    }

}
