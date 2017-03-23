//
//  UIImageView+Cache.swift
//  Pods
//
//  Created by Vic on 16/7/4.
//
//

import Foundation
import UIKit
import SDWebImage

typealias CacheImageCompletedBlock = (_ image: UIImage?, _ error: NSError?) -> Void
typealias CacheImageProgressBlock  = (_ receivedSize: Int, _ expectedSize: Int) -> Void

public enum LoadImageAnimationType: Int {
    case animationNone
    case animationFadeIn
}

extension UIImageView {
    
    public func cacheWith(_ urlString: String, placeholderImage: UIImage? = nil)
    {
        #if DEBUG
            ANT_LOG_INFO("请求图片:\(urlString)")
        #endif
        
        if String.isBlankOrNil(sourceS: urlString)
        {
            self.image = placeholderImage
            return
        }
        if let url = URL(string: urlString)
        {
            if let myPlaceholderImage = placeholderImage
            {
                self.sd_setImage(with: url, placeholderImage: myPlaceholderImage)
            }else{
                self.sd_setImage(with: url)
            }
        }else{
            self.image = placeholderImage
        }
    }
    
    public func cacheWith(_ urlString: String, block: @escaping SDWebImageCompletionBlock)
    {
        #if DEBUG
            ANT_LOG_INFO("请求图片:\(urlString)")
        #endif
        
        if let url = URL(string: urlString)
        {
            self.sd_setImage(with: url, completed: { (image, error, type, url) in
                block(image, error, type, url)
            })
            //self.sd_setImage(with: url, completed: block)
        }else{
            block(nil, NSError(domain: "url is null", code: 0, userInfo: nil), SDImageCacheType.none, nil)
        }
    }
    
//    /**
//     异步加载一张图片
//     
//     - parameter URL:                        图片URL
//     - parameter placeholderImage:           默认图片
//     - parameter filter:                     过滤器
//     - parameter progress:                   下载进度
//     - parameter progressQueue:              处理队列
//     - parameter imageTransition:            动画
//     - parameter runImageTransitionIfCached: 如果图片被缓存是否执行过渡动画
//     - parameter completion:                 完成回调
//     */
//    public func cacheWith(
//            URLRequest urlRequest: URLRequestConvertible, placeholderImage: UIImage? = default, filter: ImageFilter? = default, progress: AlamofireImage.ImageDownloader.ProgressHandler? = default, progressQueue: DispatchQueue = default, imageTransition: UIImageView.ImageTransition = default, runImageTransitionIfCached: Bool = default, completion: (@escaping (Alamofire.DataResponse<UIImage>) -> Swift.Void)? = default)
//    {
//        self.af_setImage(withURLRequest: <#T##URLRequestConvertible#>, placeholderImage: <#T##UIImage?#>, filter: <#T##ImageFilter?#>, progress: <#T##ImageDownloader.ProgressHandler?##ImageDownloader.ProgressHandler?##(Progress) -> Void#>, progressQueue: <#T##DispatchQueue#>, imageTransition: <#T##UIImageView.ImageTransition#>, runImageTransitionIfCached: <#T##Bool#>, completion: <#T##((DataResponse<UIImage>) -> Void)?##((DataResponse<UIImage>) -> Void)?##(DataResponse<UIImage>) -> Void#>)
//        
//        self.af_setImageWithURL(URL, placeholderImage: placeholderImage, filter: filter, progress: progress, progressQueue: progressQueue, imageTransition: imageTransition, runImageTransitionIfCached: runImageTransitionIfCached, completion: completion)
//    }
}
