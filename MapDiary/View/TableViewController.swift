//
//  ViewController.swift
//  MapDiary
//
//  Created by canberk yılmaz on 2023-02-10.
//

import UIKit
import CoreData
//import SwipeCellKit


class TableViewController: UITableViewController {
    
    let modelView = ModelView()
    


    private var backgroundCellColor: UIColor?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Records"
        setupUI()
        
    }
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        //overrideUserInterfaceStyle = ColorHelper.getSelectedAppearance()
        tableView.reloadData()
        setupUI()
    }
 
    func setupUI() {
           
           let backgroundColor: UIColor
           let navigationFontColor: UIColor
      
            if traitCollection.userInterfaceStyle ==  .light{
                backgroundColor = UIColor.getColors.lightModeBlueColor
                backgroundCellColor = UIColor.getColors.lightModeCyanColor
                navigationFontColor = UIColor.getColors.lightModeTextColor
                
            }else {
                backgroundColor = UIColor.getColors.darkModeBlueColor
                backgroundCellColor = UIColor.getColors.darkModeCyanColor
                navigationFontColor = UIColor.getColors.darkModeTextColor
            }
        let attrs = [
            NSAttributedString.Key.foregroundColor: navigationFontColor,
            NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 22)
            
        ]
        
        navigationController?.navigationBar.titleTextAttributes = attrs
    
        view.backgroundColor = backgroundColor
        
     
        navigationController?.navigationBar.barTintColor = backgroundColor
        navigationController?.navigationBar.tintColor = navigationFontColor
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.backgroundColor = UIColor.clear
  
    }

    
    override func viewWillAppear(_ animated: Bool) {
        
        modelView.loadItems()
        tableView.reloadData()
        
    }
    

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        performSegue(withIdentifier: "ToRegisterVC", sender: self)
        
    }
    

   
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = UIColor.clear
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

         performSegue(withIdentifier: "goToDetailVC", sender: self)
        
        tableView.deselectRow(at: indexPath, animated: true)

    }
    

    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return modelView.itemsArray.count
    }
    
    func getDateString(date: Date , isTime: Bool) -> String {
        let dateFormatter = DateFormatter()
        if isTime{
            dateFormatter.dateFormat = "h:mm a"
            dateFormatter.amSymbol = "AM"
            dateFormatter.pmSymbol = "PM"
        }else {
            dateFormatter.dateFormat = "YYYY-MM-dd"
        }
    
//        dateFormatter.dateFormat = "MMMM dd, yyyy "
        return dateFormatter.string(from: date)
    
    }
    

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "cellID", for: indexPath) as! RecordCell

        cell.cellView.backgroundColor = backgroundCellColor

        cell.cellView.layer.cornerRadius = 10
        
        
        let records = modelView.itemsArray[indexPath.row]
        let imagesArray = modelView.imagesFromCoreData(object: records.images)!
        let sizeCell = CGSize(width: cell.selectedPhotoImageView.frame.width, height: cell.selectedPhotoImageView.frame.height)
        //UIGraphicsGetCurrentContext()?.interpolationQuality = . high

//        let imagesResized = resizeImage(image: imagesArray[0], targetSize: sizeCell)
        let imagesResizedExtention = imagesArray[0].resize(targetSize: sizeCell)
        cell.selectedPhotoImageView.layer.cornerRadius = 10
        cell.selectedPhotoImageView.image = imagesResizedExtention
        
//        as
    
        cell.dateLabel.text = getDateString(date: records.date!, isTime: false)
        cell.timeLabel.text = getDateString(date: records.date!, isTime: true)
        cell.titleLabel.text = modelView.itemsArray[indexPath.row].name
//        cell.delegate = self
        
//        return cell
//        let cell = super.tableView(tableView, cellForRowAt: indexPath)

        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") {  (action, Sourceview, completionHandler) in
       
            self.modelView.deleteItems(int: indexPath.row)
            tableView.reloadData()
            completionHandler(true)

        }
//        deleteAction.perform(nil, with: .)
        deleteAction.image = UIImage(systemName: "delete.left.fill")
        let swipeActions = UISwipeActionsConfiguration(actions: [deleteAction])
//        swipeActions.perform
        return swipeActions
    }

//    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
//        editing
//    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let indexPath = tableView.indexPathForSelectedRow {
        
        
//        if segue.identifier == "ToRegisterVC"{
//            let destinationVC = segue.destination as! RegisterEditVC
//
//
//
//        }else
        if segue.identifier == "goToDetailVC"{
            lazy var destinationVC = segue.destination as! DetailVC
            let records = modelView.itemsArray[indexPath.row]
            let imagesArray = modelView.imagesFromCoreData(object: records.images)!
            destinationVC.title = records.name!
            //destinationVC.title = String(indexPath.row)
            destinationVC.itemObject = records
            destinationVC.currentIndex = indexPath.row
            destinationVC.imageArray = imagesArray
            //destinationVC.descText = records.desc!
            
            if records.lat == 0 {
                destinationVC.mapButtonOutlet.isEnabled = false
                destinationVC.mapButtonOutlet.customView?.alpha = 0.5
            }
            
        }
            
            
            

        }
        

    }
//    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
//        if indexPath.row == 1{
//            return .none
//        }else {
//            return .delete
//        }
//    }
    

}
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
