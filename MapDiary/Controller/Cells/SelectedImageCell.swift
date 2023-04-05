//
//  SelectedImageCell.swift
//  MapDiary
//
//  Created by canberk yılmaz on 2023-03-01.
//

import UIKit

protocol PhotoCellDelegate: AnyObject{
    func delete(cell: SelectedImageCell)
}


class SelectedImageCell: UICollectionViewCell {
    
    @IBOutlet weak var deleteButtonOutlet: UIVisualEffectView!{
        didSet{
            deleteButtonOutlet.backgroundColor = UIColor.getColors.redColor

            deleteButtonOutlet.layer.cornerRadius = deleteButtonOutlet.bounds.width / 2
            deleteButtonOutlet.layer.masksToBounds = true
        }
    }
    @IBOutlet weak var imageInTheCell: UIImageView!
    
    weak var delegate: PhotoCellDelegate?
    
    func setupSelectedImageCell(cellImage: UIImage){
        
        let sizeCell = CGSize(width: imageInTheCell.frame.width, height: imageInTheCell.frame.height)
        
            let resizedImage = cellImage.resize(targetSize: sizeCell)
            imageInTheCell.image = resizedImage
        
       
    }
    @IBAction func deleteButtonCell(_ sender: UIButton) {

        delegate?.delete(cell: self)
    }
}
