//
//  RegisterEditVC.swift
//  MapDiary
//
//  Created by canberk yılmaz on 2023-02-27.
//

import UIKit
import CoreData
import ImageViewer_swift
import CoreLocation

import AVFoundation
import Photos


class RegisterEditVC: UIViewController, UITextViewDelegate {
    
    private var imageRecordArray: [UIImage] = []
    
    let modelView = ModelView()
    

    
    private var latitudeValue = Double()
    
    private var longitudeValue = Double()
        
    private var locationManager = CLLocationManager()
    
    @IBOutlet weak var saveButtonOutlet: UIButton!
    
    @IBOutlet weak var locationSwitchOutlet: UISwitch!
    
    @IBOutlet weak var nameTextField: UITextField! {
        didSet {
            
            let placeholderText = NSAttributedString(string: "Write your title name!",
                                                        attributes: [NSAttributedString.Key.foregroundColor: UIColor.placeholderText])
            
            nameTextField.attributedPlaceholder = placeholderText
            
        }
    }
        
    @IBOutlet weak var descMessageText: UITextView!

    @IBOutlet weak var collectionView: UICollectionView!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Save Record"
        
        descMessageText.text = "Write your note!"
        descMessageText.textColor = UIColor.placeholderText
        collectionView.dataSource = self
        collectionView.delegate = self
    
        setupUI()
        
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(false)
        locationManager.stopUpdatingLocation()
    }
    

    // Automatic placeholder for text view
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.placeholderText {
            textView.text = ""
            textView.textColor = UIColor.label
            }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Write your note!"
            textView.textColor = UIColor.placeholderText
        }
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        setupUI()
    }

    private func setupUI(){
        descMessageText.delegate = self

        
        let backgroundColor: UIColor
        let navigationFontColor: UIColor
        let backgroundCellColor: UIColor
   
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
        navigationController?.navigationBar.tintColor = navigationFontColor
        navigationController?.navigationBar.barTintColor = backgroundColor


        view.backgroundColor = backgroundColor
     
     
  
        saveButtonOutlet.tintColor = UIColor.label

        
        locationSwitchOutlet.layer.cornerRadius = 16.0
        locationSwitchOutlet.backgroundColor = backgroundCellColor
        locationSwitchOutlet.clipsToBounds = true
   
        
        
        collectionView.layer.cornerRadius = 5.0
        collectionView.layer.borderWidth = 1.0
        collectionView.layer.borderColor = UIColor.placeholderText.cgColor

        nameTextField.layer.cornerRadius = 5.0
        nameTextField.layer.borderWidth = 1.0
        nameTextField.layer.borderColor = UIColor.placeholderText.cgColor

        nameTextField.backgroundColor = backgroundCellColor
        
        saveButtonOutlet.layer.cornerRadius = 16.0
        saveButtonOutlet.layer.borderWidth = 1.0
        saveButtonOutlet.layer.borderColor = UIColor.placeholderText.cgColor
        saveButtonOutlet.backgroundColor = backgroundCellColor
        saveButtonOutlet.titleLabel?.textColor = UIColor.label
        
       
        descMessageText.layer.borderWidth = 1.0
        descMessageText.layer.borderColor = UIColor.placeholderText.cgColor
        descMessageText.layer.cornerRadius = 5.0
        descMessageText.backgroundColor = backgroundCellColor
      
        
       
    }
    

    //Promting an alert incase of an empty name or no image selection
    private func emptyDataAlert() {
        
        let alert = UIAlertController(title: "Empty Value/Values", message: "Please enter Title and Select at least one image", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .cancel))
        
        present(alert, animated: true)
        
        
        
    }
    
    @IBAction func addImageButton(_ sender: UIButton) {
            pickerFunc()
    }
    //Start update location / permission request while switch is on
    @IBAction func locationSwitch(_ sender: UISwitch) {
        if sender.isOn{
           
            checkLocationService()
           

        }else {
            locationManager.stopUpdatingLocation()
            latitudeValue = 91.0
            longitudeValue = 181.0
        }
        
        

    }
    @IBAction func saveButton(_ sender: UIButton) {

        if nameTextField.text == "" || imageRecordArray.isEmpty == true{
            emptyDataAlert()
        }else {
            insertDB()
        }
    }
    // New instance created for saving the data

    private func insertDB(){
        
        let newItem = Items(context: modelView.context)
        newItem.name = nameTextField.text
        newItem.date = Date()
        newItem.images = modelView.coreDataObjectFromImages(images: imageRecordArray)
        if descMessageText.textColor == UIColor.placeholderText{
            descMessageText.text = ""
        }
        
        newItem.desc = descMessageText.text
        newItem.lat = latitudeValue
        newItem.lon = longitudeValue
        
        
        modelView.saveItems()
        
        navigationController?.popViewController(animated: true)
    }

    

    func imagePicker(sourceType: UIImagePickerController.SourceType) -> UIImagePickerController {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = sourceType
        return imagePicker
    }
    
    // Detecting if user wants to select photos from photo library or camera
    private func pickerFunc(){
        
        
        
        let actionSheet = UIAlertController(title: "Photo source", message: "Choose a source", preferredStyle: .actionSheet)
        
        if UIImagePickerController.isSourceTypeAvailable(.camera){
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: {action in
            
            let cameraImagePicker = self.imagePicker(sourceType: .camera)
            cameraImagePicker.delegate = self
            
            
            let cameraAuthorizationStatus = AVCaptureDevice.authorizationStatus(for: .video)

            switch cameraAuthorizationStatus {
            case .restricted, .denied:
                self.present(self.permissionAlert(), animated: true)
                
                
            case .authorized, .notDetermined:
                self.present(cameraImagePicker, animated: true,completion: nil)
                
            default:
                
                break
            }

           
        }))
        }
        
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            
        actionSheet.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: {action in
            
            let photoImagePicker = self.imagePicker(sourceType: .photoLibrary)
            photoImagePicker.delegate = self
            
            let photoAuthorizationStatus = PHPhotoLibrary.authorizationStatus()
            switch photoAuthorizationStatus {
            case .restricted,.denied, .notDetermined:

                PHPhotoLibrary.requestAuthorization(){
                    
                                (newStatus) in
                                DispatchQueue.main.async {

                                    if newStatus ==  PHAuthorizationStatus.authorized {
                                        
                                        self.present(photoImagePicker, animated: true, completion: nil)
                                    }else{
                                        self.present(self.permissionAlert(), animated: true, completion: nil)

                                    }
                                }}
           
            case .authorized:
                self.present(photoImagePicker, animated: true, completion: nil)
        
        
            default:
                break
            }

        }))
        }
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: {(action:UIAlertAction) in
           
            
            
        }))
        
        // ActionSheet centered for the ipad
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            
            if let popoverController = actionSheet.popoverPresentationController {
                popoverController.sourceView = self.view //to set the source of your alert
                popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
                popoverController.permittedArrowDirections = []
            }
        }
        

        present(actionSheet, animated: true, completion: nil)
        
    }
    
}


extension RegisterEditVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
   
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {

        //Appending and updating UI on image selection
        if (picker.sourceType == .camera){
            let uiImage = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
            imageRecordArray.append(uiImage)
            collectionView.reloadData()
        }else {
            
            DispatchQueue.main.async {
                guard let url = info[.imageURL] as? URL else { return }
                        if let image = url.asSmallImage {
                            self.imageRecordArray.append(image)
                            self.collectionView.reloadData()

                        }
            }
        
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

        cell.setupSelectedImageCell(cellImage: imageRecordArray[indexPath.row])
        cell.imageInTheCell.setupImageViewer(images: imageRecordArray, initialIndex: indexPath.item)
        
        cell.delegate = self

        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    
    
    }

// Deleting cell button function
extension RegisterEditVC: PhotoCellDelegate {
    func delete(cell: SelectedImageCell) {
 
        if let indexPath = collectionView.indexPath(for: cell){
           
            imageRecordArray.remove(at: indexPath.item)
            collectionView.reloadData()
        }
    }
}

extension RegisterEditVC: CLLocationManagerDelegate{
    
    func setupLocationManager(){
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func checkLocationService(){
        if CLLocationManager.locationServicesEnabled() == true{
            //Setup Location Manager
            setupLocationManager()
            checkLocationAuthorization()
         
        }
        
    }
    
    //Navigate to app setting if permission required
    
    func permissionAlert() -> UIAlertController{
        let alertController = UIAlertController(title: "Need Permission", message: "Please go to Settings and allow access", preferredStyle: .alert)

           let settingsAction = UIAlertAction(title: "Settings", style: .default) { (_) -> Void in
               guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                   return
               }
               if UIApplication.shared.canOpenURL(settingsUrl) {
                   UIApplication.shared.open(settingsUrl, completionHandler: { (success) in })
                }
           }
           let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)

           alertController.addAction(cancelAction)
           alertController.addAction(settingsAction)
        return alertController
    }
    
    
    //checking location autharization level
    func checkLocationAuthorization() {
        switch locationManager.authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            locationManager.startUpdatingLocation()
            
            
        case .denied,.restricted:
            locationSwitchOutlet.isOn = false
            latitudeValue = 91.0
            longitudeValue = 181.0
            self.present(permissionAlert(), animated: true)
            
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
    
        default:
            locationSwitchOutlet.isOn = false
            latitudeValue = 91.0
            longitudeValue = 181.0
            self.present(permissionAlert(), animated: true)
            
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return}
        
        latitudeValue = location.coordinate.latitude
        longitudeValue = location.coordinate.longitude
        
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkLocationAuthorization()
    }
}

