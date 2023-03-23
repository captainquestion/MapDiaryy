//
//  RecordCell.swift
//  MapDiary
//
//  Created by canberk yılmaz on 2023-02-20.
//

import UIKit
//import SwipeCellKit

class RecordCell: UITableViewCell {

    @IBOutlet weak var selectedPhotoImageView: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var cellView: UIView!
}
