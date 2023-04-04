//
//  ViewController.swift
//  MapDiary
//
//  Created by canberk yılmaz on 2023-02-10.
//

import UIKit
import CoreData



class TableViewController: UITableViewController {
    
    let modelView = ModelView()

    private var backgroundCellColor: UIColor?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        title = "Records"
        setupUI()
        
    }
    
    // Update UI in case of dark-light theme change
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        tableView.reloadData()
        setupUI()
    }
   // Setup UI
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

    // Fetching from core data
    
    override func viewWillAppear(_ animated: Bool) {
        
        modelView.loadItems()
        tableView.reloadData()
        
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
    
    
    // Formatting the date attributes
    private func getDateString(date: Date , isTime: Bool) -> String {
        let dateFormatter = DateFormatter()
        if isTime{
            dateFormatter.dateFormat = "h:mm a"
            dateFormatter.amSymbol = "AM"
            dateFormatter.pmSymbol = "PM"
        }else {
            dateFormatter.dateFormat = "YYYY-MM-dd"
        }
    

        return dateFormatter.string(from: date)
    
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "cellID", for: indexPath) as! RecordCell
  
        // Setting image size according to its frame
        let sizeCell = CGSize(width: cell.selectedPhotoImageView.frame.width, height: cell.selectedPhotoImageView.frame.height)
       
        cell.cellView.backgroundColor = backgroundCellColor
        cell.cellView.layer.cornerRadius = 10
    
        cell.selectedPhotoImageView.layer.cornerRadius = 10

        let records = modelView.itemsArray[indexPath.row]
        cell.titleLabel.text = records.name
        
        
        if let date = records.date {
            cell.dateLabel.text = getDateString(date: date, isTime: false)
            cell.timeLabel.text = getDateString(date: date, isTime: true)
        }

         // Fetching, resizing and setting the image outside of main thread for smooth experience
          DispatchQueue.global(qos: .userInitiated).async {
              guard let imagesArray = self.modelView.imagesFromCoreData(object: records.images) else{
                  fatalError("Expect an image")
           }
            let imagesResizedExtention = imagesArray[0].resize(targetSize: sizeCell)

             DispatchQueue.main.async {
                cell.selectedPhotoImageView.image = imagesResizedExtention

                
               }
    
          }

        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }

    
    
    // Swipe to delete from table view and database
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") {  (action, Sourceview, completionHandler) in
       
            self.modelView.deleteItems(int: indexPath.row)
//            tableView.reloadData()
            self.tableView.deleteRows(at: [indexPath], with: .fade)
            completionHandler(true)

        }

        deleteAction.image = UIImage(systemName: "delete.left.fill")
        let swipeActions = UISwipeActionsConfiguration(actions: [deleteAction])
  
        
        return swipeActions
    }


    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let indexPath = tableView.indexPathForSelectedRow {
        
            
        if segue.identifier == "goToDetailVC"{
            lazy var destinationVC = segue.destination as! DetailVC
            let records = modelView.itemsArray[indexPath.row]
            guard let imagesArray = modelView.imagesFromCoreData(object: records.images) else {return}
            
            if let name = records.name {
            destinationVC.title = name
            }
            destinationVC.itemObject = records
            destinationVC.currentIndex = indexPath.row
            destinationVC.imageArray = imagesArray
        
            // Map button disabled if location was turned off during registering the record
            if records.lat > 90.0 || records.lon > 180.0 {
                destinationVC.mapButtonOutlet.isEnabled = false
                destinationVC.mapButtonOutlet.customView?.alpha = 0.5
            }
            
        }
            
            
            

        }
        

    }

}
