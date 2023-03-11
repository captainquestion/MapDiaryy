//
//  SwipeTableVC.swift
//  MapDiary
//
//  Created by canberk yılmaz on 2023-03-07.
//

import UIKit
import SwipeCellKit
import CoreData


class SwipeTableVC: UITableViewController, SwipeTableViewCellDelegate {
    
    let modelView = ModelView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellID", for: indexPath) as! RecordCell
        let records = modelView.itemsArray[indexPath.row]
        let imagesArray = modelView.imagesFromCoreData(object: records.images)!
        
        cell.selectedPhotoImageView.image = imagesArray[0]
        cell.titleLabel.text = modelView.itemsArray[indexPath.row].name
        
        cell.delegate = self
        
        return cell
        
        
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        
        guard orientation == .right else { return nil }
        
        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            
            self.modelView.deleteItems(int: indexPath.row)

            
        }
        deleteAction.image = UIImage(systemName: "delete.left.fill")
        
        return [deleteAction]
        
    }
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeOptions()
        options.expansionStyle = .destructive
        options.transitionStyle = .border
        return options
    }
    
    
//
//
//    func updateDB(at indexPath: IndexPath){
//
//    }

}
    

