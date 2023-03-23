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
    
    @IBOutlet weak var imageInTheCell: UIImageView!
    
    weak var delegate: PhotoCellDelegate?
    
    
    @IBAction func deleteButtonCell(_ sender: UIButton) {
        print("Button Pressed !")
        delegate?.delete(cell: self)
    }
}
