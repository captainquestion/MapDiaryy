//
//  Record.swift
//  MapDiary
//
//  Created by canberk yılmaz on 2023-02-20.
//

import Foundation
import UIKit


class Record {
    
    var selectedImage: UIImage
    var recordTitle: String
    
    init(selectedImage: UIImage, recordTitle: String) {
        self.selectedImage = selectedImage
        self.recordTitle = recordTitle
    }
}
