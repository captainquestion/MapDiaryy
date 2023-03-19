//
//  Helper.swift
//  MapDiary
//
//  Created by canberk yılmaz on 2023-03-18.
//

import UIKit
import UniformTypeIdentifiers

extension UIImage {
    func resize(targetSize: CGSize) -> UIImage {
        return UIGraphicsImageRenderer(size:targetSize).image { _ in
            self.draw(in: CGRect(origin: .zero, size: targetSize))
        }
    }
}

extension URL {
    
    /// Used for limiting memory usage when opening new photos from user's library.
    ///
    /// Photos could consume a lot of memory when loaded into `UIImage`s. A 2000 by 2000 photo
    /// roughly will consume 2000 x 2000 x 4 bytes = 16MB. A 10 000 by 10 000 photo will consume
    /// 10000 * 10000 * 4 = 400MB which is a lot, give that in your app
    /// you could pick up more than one photo (consider picking 10-15 photos)
    var asSmallImage: UIImage? {
        
            let sourceOptions = [kCGImageSourceShouldCache: false] as CFDictionary
      
            guard let source = CGImageSourceCreateWithURL(self as CFURL, sourceOptions) else { return nil }
            
            let downsampleOptions = [
                kCGImageSourceCreateThumbnailFromImageAlways: true,
                kCGImageSourceCreateThumbnailWithTransform: true,
                kCGImageSourceThumbnailMaxPixelSize: 2_000,
            ] as CFDictionary

            guard let cgImage = CGImageSourceCreateThumbnailAtIndex(source, 0, downsampleOptions) else { return nil }

            let data = NSMutableData()
           
           
        guard let imageDestination = CGImageDestinationCreateWithData(data, UTType.png.identifier as CFString, 1, nil) else { return nil }
            
            // Don't compress PNGs, they're too pretty
            let destinationProperties = [kCGImageDestinationLossyCompressionQuality: cgImage.isPNG ? 1.0 : 0.75] as CFDictionary
            CGImageDestinationAddImage(imageDestination, cgImage, destinationProperties)
            CGImageDestinationFinalize(imageDestination)
            
            let image = UIImage(data: data as Data)
            return image
    }
}

extension CGImage {
    
    /// Gives info whether or not this `CGImage` represents a png image
    /// By observing its UT type.
    var isPNG: Bool {
        if #available(iOS 14.0, *) {
        
            return (utType as String?) == UTType.png.identifier
        } else {
       
            return utType == UTType.png.identifier as CFString
        }
    }
}


