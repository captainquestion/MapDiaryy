////
////  test123.swift
////  MapDiary
////
////  Created by canberk yılmaz on 2023-03-29.
////
//
//import Foundation
//import  UIKit
//let imageCache = NSCache<NSString, UIImage>
//final class MyCacheableImageView:UIImageView
//{
//    var imageUrlString:String?
//    func downloadImageUsingCacheWithURLString(_ URLString: String, placeHolder: UIImage?) {
//        imageUrlString = URLString
//        self.image = nil
//        if let cachedImage = imageCache.object(forKey: NSString(string: URLString)) {
//            self.image = cachedImage
//            return
//        }
//        guard URLString.count > 10 else { // url will atleast have https:// hence comparing with 10
//            self.image = placeHolder
//            return
//        }
//        if let url = URL(string: URLString) {
//            URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
//                if error != nil {
//                    DispatchQueue.main.async {
//                        self.image = placeHolder
//                    }
//                    return
//                }
//                DispatchQueue.main.async {
//                    if let data = data {
//                        if let downloadedImage = UIImage(data: data){
//                            imageCache.setObject(downloadedImage, forKey: NSString(string: URLString))
//                            if self.imageUrlString == URLString
//                            {
//                                self.image = downloadedImage
//                                Restaurant.saveImagePermanantlyOnCoreData(image: downloadedImage, url:URLString)
//                            }
//                        }
//                    }
//                }
//            }).resume()
//        }
//    }
//}
