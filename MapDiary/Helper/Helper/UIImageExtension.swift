//
//  UIImageExtension.swift
//  MapDiary
//
//  Created by canberk yılmaz on 2023-03-27.
//

import UIKit



extension UIImage {
    func resize(targetSize: CGSize) -> UIImage {
        let widthRatio  = (targetSize.width  / size.width)
        let heightRatio = (targetSize.height / size.height)
        let effectiveRatio = max(widthRatio, heightRatio)
        let newSize = CGSize(width: size.width * effectiveRatio, height: size.height * effectiveRatio)
        let rect = CGRect(origin: .zero, size: newSize)
        
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0)
        self.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
}
