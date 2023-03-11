//
//  PhotoVC.swift
//  MapDiary
//
//  Created by canberk yılmaz on 2023-03-09.
//

import UIKit
import ImageViewer_swift

class PhotoVC: UIViewController {

    var imagesArrayPVC = [UIImage]()
    @IBOutlet weak var imageViewP: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        imageViewP.setupImageViewer(images: imagesArrayPVC)
    }

}
