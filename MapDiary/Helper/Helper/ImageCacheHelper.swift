//
//  ImageCacheHelper.swift
//  MapDiary
//
//  Created by canberk yılmaz on 2023-03-28.
//

import UIKit


class ThemeManager {
    // Recommendation #5: Implement an image cache of resized images inside `ThemeManager`
    private let imageCache = NSCache<NSString, UIImage>()
    
    private(set) var imageKeys: [NSString]
    
    init() {
        imageKeys = []
        for i in 1...40 {
            imageKeys.append(NSString(string: "image\(i)"))
        }
    }
    
    // Recommendation #2: make ThemeManager fetch just one image with a particular index.
    func fetchImage(atIndex index: Int, resizedTo size: CGSize, completion: @escaping (UIImage?, Int) -> Void) {
        guard 0 <= index, index < imageKeys.count else {
            assertionFailure("Image with invalid index requested")
            completion(nil, index)
            return
        }
        
        let imageKey = imageKeys[index]
         
        if let cachedImage = imageCache.object(forKey: imageKey) {
            completion(cachedImage, index)
            return
        }
        
        // Recommendation #3: Make image loading asynchronous, moving the work off the main queue.
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let self = self else {
                completion(nil, index)
                return
            }
            guard let image = UIImage(named: String(imageKey)) else {
                assertionFailure("Image is missing from the asset catalog")
                completion(nil, index)
                return
            }
            
            // Recommendation #4: After loading an image from disk, resize it appropriately
            let resizedImage = image.resize(targetSize: size)
            
            self.imageCache.setObject(resizedImage, forKey: imageKey)
            completion(resizedImage, index)
        }
    }
}
