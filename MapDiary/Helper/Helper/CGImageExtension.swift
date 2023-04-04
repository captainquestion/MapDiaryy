//
//  CGImageExtension.swift
//  MapDiary
//
//  Created by canberk yılmaz on 2023-03-27.
//

import UIKit
import UniformTypeIdentifiers


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
