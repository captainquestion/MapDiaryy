//
//  ViewController.swift
//  MapDiary
//
//  Created by canberk yılmaz on 2023-02-10.
//

import UIKit
import CoreData
import SwipeCellKit


class TableViewController: SwipeTableVC {
    
  


    override func viewDidLoad() {
        super.viewDidLoad()
       print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))

    }
    
    override func viewDidAppear(_ animated: Bool) {
//        loadItems()
        modelView.loadItems()
        tableView.reloadData()
        title = "Keep It Up !"
        
        //tableView.rowHeight = UITableView.automaticDimension
    }

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        performSegue(withIdentifier: "ToRegisterVC", sender: self)
        
    }
    

   
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

         performSegue(withIdentifier: "goToDetailVC", sender: self)
        
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return modelView.itemsArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = super.tableView(tableView, cellForRowAt: indexPath)

        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }

//    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
//        editing
//    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let indexPath = tableView.indexPathForSelectedRow {
        
        
        if segue.identifier == "ToRegisterVC"{
            let destinationVC = segue.destination as! RegisterEditVC
           
           
    
        }else if segue.identifier == "goToDetailVC"{
            let destinationVC = segue.destination as! DetailVC
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
