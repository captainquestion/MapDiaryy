//
//  RegisterEditVC.swift
//  MapDiary
//
//  Created by canberk yılmaz on 2023-02-27.
//

import UIKit
import CoreData
import ImageViewer_swift

class RegisterEditVC: UIViewController, UITextViewDelegate {
    
    var imageRecordArray: [UIImage] = []
    
    let modelView = ModelView()
    
    let titleText = String()
        
    @IBOutlet weak var nameTextField: UITextField!
        
    @IBOutlet weak var descMessageText: UITextView!

    @IBOutlet weak var collectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()
//        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))

        collectionView.dataSource = self
        collectionView.delegate = self
        title = titleText
        descMessageText.delegate = self
        
        
    }
    
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)

    }
    
//    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
//        textView.resignFirstResponder()
//        return true
//    }
//    
//    func textFieldShouldReturn(_ textView: UITextView) -> Bool {
//        textView.resignFirstResponder()
//        return true
//    }
    
    
    func coreDataObjectFromImages(images: [UIImage]) -> Data? {
        let dataArray = NSMutableArray()
        
        for img in images {
            if let data = img.pngData() {
                dataArray.add(data)
            }
        }
        
        return try? NSKeyedArchiver.archivedData(withRootObject: dataArray, requiringSecureCoding: true)
    }
    

    
    
    @IBAction func addImageButton(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
       
        
        present(imagePicker, animated: true)
        collectionView.reloadData()
        
    }
    
    @IBAction func saveButton(_ sender: Any) {

        let newItem = Items(context: modelView.context)
        newItem.name = nameTextField.text
        newItem.date = Date()
        newItem.images = coreDataObjectFromImages(images: imageRecordArray)
        newItem.desc = descMessageText.text
        modelView.itemsArray.append(newItem)
        modelView.saveItems()
        navigationController?.popViewController(animated: true)
        
        
    }
}

extension RegisterEditVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
//        guard let selectedImage = info[.editedImage] as? UIImage else {return }
//        dismiss(animated: true)
        
        if let image = info[.editedImage] as? UIImage{
            imageRecordArray.append(image)
            collectionView.reloadData()
            print(imageRecordArray.count)
            
        }
        picker.dismiss(animated: true, completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}



extension RegisterEditVC: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageRecordArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "selectImageCell", for: indexPath) as! SelectedImageCell
        cell.imageInTheCell.setupImageViewer(images: imageRecordArray)
        cell.imageInTheCell.image = imageRecordArray[indexPath.row]
        cell.delegate = self
        
        return cell
    }
    
    
    
    }

extension RegisterEditVC: PhotoCellDelegate {
    func delete(cell: SelectedImageCell) {
        if let indexPath = collectionView.indexPath(for: cell){
            //delete the photo from datasource
            imageRecordArray.remove(at: indexPath.item)
            collectionView.reloadData()
        }
    }
}



