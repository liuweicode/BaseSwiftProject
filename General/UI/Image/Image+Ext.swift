//
//  Image+Ext.swift
//  DaQu
//
//  Created by 刘伟 on 9/5/16.
//  Copyright © 2016 上海凌晋信息技术有限公司. All rights reserved.
//

import UIKit

extension UIImage
{

    // 调整图片大小
    func resizeImageTo(_ targetSize: CGSize) -> UIImage {
        
        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height
        
        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
        }
        
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        self.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    
    class func imageHasAlpha(_ image:UIImage) -> Bool {
        let alpha = image.cgImage?.alphaInfo;
        return (alpha == CGImageAlphaInfo.first ||
            alpha == CGImageAlphaInfo.last ||
            alpha == CGImageAlphaInfo.premultipliedFirst ||
            alpha == CGImageAlphaInfo.premultipliedLast);
    }
    
    // 图片压缩
    func compressData(byLimitedSize maxImageSize:Int, completeHandle completed:@escaping (_ data:Data?) -> Void)
    {
        DispatchQueue.global(qos: .background).async {
         
            var compression:CGFloat = 1.0
            
            var imageData = UIImageJPEGRepresentation(self, compression)
            
            if imageData == nil
            {
                DispatchQueue.main.async {
                    completed(nil)
                }
                return
            }
            
            var size = imageData!.count
            
            while size > maxImageSize {
                
                compression -= 0.05
                
                imageData = UIImageJPEGRepresentation(self, compression)
                
                if imageData == nil
                {
                    break
                }
                
                size = imageData!.count
                
                #if DEBUG
                    ANT_LOG_INFO("获取压缩图片 压缩比例：\(compression) 图片大小:\(size)")
                #endif
            }
            
            #if DEBUG
                ANT_LOG_INFO("最终获取压缩图片 压缩比例：\(compression) 图片大小:\(size)")
            #endif
            
            DispatchQueue.main.async {
                completed(imageData)
            }
        }
    }
    
    // 图片压缩
    func compressData(byLimitedSize maxImageSize:Int) -> Data?
    {
        var compression:CGFloat = 1.0
        
        var imageData = UIImageJPEGRepresentation(self, compression)
        
        if imageData == nil
        {
            return nil
        }
        
        var size = imageData!.count
        
        while size > maxImageSize {
            
            compression -= 0.05
            
            imageData = UIImageJPEGRepresentation(self, compression)
            
            if imageData == nil
            {
                break
            }
            
            size = imageData!.count
            
            #if DEBUG
                ANT_LOG_INFO("获取压缩图片 压缩比例：\(compression) 图片大小:\(size)")
            #endif
        }
        
        #if DEBUG
            ANT_LOG_INFO("最终获取压缩图片 压缩比例：\(compression) 图片大小:\(size)")
        #endif
        
        return imageData
    }

    
    // 从视频中
    func imagesFromVideo(pathToVideo: String, completionHandler:(_ images:[UIImage]?)->Void)
    {
        
    }
    
}
