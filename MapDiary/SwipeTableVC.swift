////
////  SwipeTableVC.swift
////  MapDiary
////
////  Created by canberk yılmaz on 2023-03-07.
////
//
//import UIKit
////import SwipeCellKit
//import CoreData
//
//
//class SwipeTableVC: UITableViewController, SwipeTableViewCellDelegate {
//
//    let modelView = ModelView()
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//
//    }
//
//
//
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//
//        let cell = tableView.dequeueReusableCell(withIdentifier: "cellID", for: indexPath) as! RecordCell
//        let records = modelView.itemsArray[indexPath.row]
//        let imagesArray = modelView.imagesFromCoreData(object: records.images)!
//        let sizeCell = CGSize(width: cell.selectedPhotoImageView.frame.width, height: cell.selectedPhotoImageView.frame.height)
//        //UIGraphicsGetCurrentContext()?.interpolationQuality = . high
//
////        let imagesResized = resizeImage(image: imagesArray[0], targetSize: sizeCell)
//        let imagesResizedExtention = imagesArray[0].resize(targetSize: sizeCell)
//       cell.selectedPhotoImageView.image = imagesResizedExtention ?? UIImage(named: "asd")
//
//
//        cell.titleLabel.text = modelView.itemsArray[indexPath.row].name
//        cell.delegate = self
//
//        return cell
//
//
//    }
//
//    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
//
//        guard orientation == .right else { return nil }
//
//        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
//
//            self.modelView.deleteItems(int: indexPath.row)
//
//
//        }
//        deleteAction.image = UIImage(systemName: "delete.left.fill")
//
//        return [deleteAction]
//
//    }
//
//    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
//        var options = SwipeOptions()
//        options.expansionStyle = .destructive
//        options.transitionStyle = .border
//        return options
//    }
//
//    
//
//
//}
//
//extension UIImage {
//
//    func resize(targetSize: CGSize) -> UIImage {
//        return UIGraphicsImageRenderer(size:targetSize).image { _ in
//            self.draw(in: CGRect(origin: .zero, size: targetSize))
//        }
//    }
//
//}
//
//
//
////
////
////    func updateDB(at indexPath: IndexPath){
////
////    }
//
////    func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage? {
////        let size = image.size
////
////        let widthRatio  = targetSize.width  / size.width
////        let heightRatio = targetSize.height / size.height
////
////        // Figure out what our orientation is, and use that to form the rectangle
////        var newSize: CGSize
////        if(widthRatio > heightRatio) {
////            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
////        } else {
////            newSize = CGSize(width: size.width * widthRatio, height: size.height * widthRatio)
////        }
////
////        // This is the rect that we've calculated out and this is what is actually used below
////        let rect = CGRect(origin: .zero, size: newSize)
////
////        // Actually do the resizing to the rect using the ImageContext stuff
////        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
////        image.draw(in: rect)
////        let newImage = UIGraphicsGetImageFromCurrentImageContext()
////        UIGraphicsEndImageContext()
////
////        return newImage
////    }
////
