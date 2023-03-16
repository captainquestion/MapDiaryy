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
import UniformTypeIdentifiers
import MobileCoreServices


class RegisterEditVC: UIViewController, UITextViewDelegate {
    
    var imageRecordArray: [UIImage] = []
    
    let modelView = ModelView()
    
    let titleText = String()
    
    var latitudeValue = Double()
    
    var longitudeValue = Double()
        
    var locationManager = CLLocationManager()
    
    @IBOutlet weak var locationSwitchOutlet: UISwitch!
    
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
//        locationManager.delegate = self
//        locationManager.requestAlwaysAuthorization()
//        setupLocationManager()
        
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
            if let data = img.jpegData(compressionQuality: 1) {
                dataArray.add(data)
            }
        }
        
        return try? NSKeyedArchiver.archivedData(withRootObject: dataArray, requiringSecureCoding: true)
    }
    

    
    
    @IBAction func addImageButton(_ sender: Any) {
        pickerFunc()
//        collectionView.reloadData()
//        let imagePicker = UIImagePickerController()
//        imagePicker.allowsEditing = true
//        imagePicker.delegate = self
//
//
//        present(imagePicker, animated: true)

        
    }
    
    @IBAction func locationSwitch(_ sender: UISwitch) {
        if sender.isOn{
            locationManager.requestAlwaysAuthorization()
            checkLocationService()
            print("Latitude Value on On=, \(latitudeValue)")

        }else {
            locationManager.stopUpdatingLocation()
            latitudeValue = 0.0
            longitudeValue = 0.0
            print("Latitude Value on OFF=, \(latitudeValue)")
        }
        
        print("Latitude Value on OFF= 2 \(latitudeValue)")

    }
    @IBAction func saveButton(_ sender: Any) {

        let newItem = Items(context: modelView.context)
        newItem.name = nameTextField.text
        newItem.date = Date()
        newItem.images = coreDataObjectFromImages(images: imageRecordArray)
        newItem.desc = descMessageText.text
        newItem.lat = latitudeValue
        newItem.lon = longitudeValue
        modelView.itemsArray.append(newItem)
        modelView.saveItems()
        navigationController?.popViewController(animated: true)
        
        
    }

    
    func pickerFunc(){
        //Setting imagePicker delegate
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        
        
        
        let actionSheet = UIAlertController(title: "Photo source", message: "Choose a source", preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: {action in
            //Source type is camera
            imagePicker.sourceType = .camera
            self.present(imagePicker, animated: true, completion: nil)
        }))
        actionSheet.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: {action in
           //Source type is library
            imagePicker.sourceType = .photoLibrary
            self.present(imagePicker, animated: true, completion: nil)
        }))
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: {(action:UIAlertAction) in
           
            
            
        }))
//        let a = view.bounds
//        actionSheet.popoverPresentationController?.sourceRect = CGRectMake(<#T##x: CGFloat##CGFloat#>, <#T##y: CGFloat##CGFloat#>, <#T##width: CGFloat##CGFloat#>, <#T##height: CGFloat##CGFloat#>)
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            
            if let popoverController = actionSheet.popoverPresentationController {
                popoverController.sourceView = self.view //to set the source of your alert
                popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0) // you can set this as per your requirement.
                popoverController.permittedArrowDirections = [] //to hide the arrow of any particular direction
            }
        }
        

//        actionSheet.popoverPresentationController?.sourceRect = view.bounds

        present(actionSheet, animated: true, completion: nil)
        
    }
    
}
//
//extension URL {
//
//    /// Used for limiting memory usage when opening new photos from user's library.
//    ///
//    /// Photos could consume a lot of memory when loaded into `UIImage`s. A 2000 by 2000 photo
//    /// roughly will consume 2000 x 2000 x 4 bytes = 16MB. A 10 000 by 10 000 photo will consume
//    /// 10000 * 10000 * 4 = 400MB which is a lot, give that in your app
//    /// you could pick up more than one photo (consider picking 10-15 photos)
//    var asSmallImage: UIImage? {
//
//            let sourceOptions = [kCGImageSourceShouldCache: false] as CFDictionary
//
//            guard let source = CGImageSourceCreateWithURL(self as CFURL, sourceOptions) else { return nil }
//
//            let downsampleOptions = [
//                kCGImageSourceCreateThumbnailFromImageAlways: true,
//                kCGImageSourceCreateThumbnailWithTransform: true,
//                kCGImageSourceThumbnailMaxPixelSize: 2_000,
//            ] as CFDictionary
//
//            guard let cgImage = CGImageSourceCreateThumbnailAtIndex(source, 0, downsampleOptions) else { return nil }
//
//            let data = NSMutableData()
//        guard let imageDestination = CGImageDestinationCreateWithData(data, UTTypeData, 1, nil) else { return nil }
//
//            // Don't compress PNGs, they're too pretty
//            let destinationProperties = [kCGImageDestinationLossyCompressionQuality: cgImage.isPNG ? 1.0 : 0.75] as CFDictionary
//            CGImageDestinationAddImage(imageDestination, cgImage, destinationProperties)
//            CGImageDestinationFinalize(imageDestination)
//
//            let image = UIImage(data: data as Data)
//            return image
//    }
//}
//extension CGImage {
//
//    /// Gives info whether or not this `CGImage` represents a png image
//    /// By observing its UT type.
//    var isPNG: Bool {
//        if #available(iOS 14.0, *) {
//            return (utType as String?) == UTType.png.identifier
//        } else {
//            return utType == kUTTypePNG
//        }
//    }
//}'
// MARK: - Memory Optimized Image Loading

extension URL {
    
    /// Used for limiting memory usage when opening new photos from user's library.
    ///
    /// Photos could consume a lot of memory when loaded into `UIImage`s. A 2000 by 2000 photo
    /// roughly will consume 2000 x 2000 x 4 bytes = 16MB. A 10 000 by 10 000 photo will consume
    /// 10000 * 10000 * 4 = 400MB which is a lot, give that in your app
    /// you could pick up more than one photo (consider picking 10-15 photos)
    var asSmallImage: UIImage? {
        
            let sourceOptions = [kCGImageSourceShouldCache: false] as CFDictionary
            
            guard let source = CGImageSourceCreateWithURL(self as CFURL, sourceOptions) else { return nil }
            
            let downsampleOptions = [
                kCGImageSourceCreateThumbnailFromImageAlways: true,
                kCGImageSourceCreateThumbnailWithTransform: true,
                kCGImageSourceThumbnailMaxPixelSize: 2_000,
            ] as CFDictionary

            guard let cgImage = CGImageSourceCreateThumbnailAtIndex(source, 0, downsampleOptions) else { return nil }

            let data = NSMutableData()
        guard let imageDestination = CGImageDestinationCreateWithData(data, kUTTypePNG, 1, nil) else { return nil }
            
            // Don't compress PNGs, they're too pretty
            let destinationProperties = [kCGImageDestinationLossyCompressionQuality: cgImage.isPNG ? 1.0 : 0.75] as CFDictionary
            CGImageDestinationAddImage(imageDestination, cgImage, destinationProperties)
            CGImageDestinationFinalize(imageDestination)
            
            let image = UIImage(data: data as Data)
            return image
    }
}

// MARK: - Helpers

extension CGImage {
    
    /// Gives info whether or not this `CGImage` represents a png image
    /// By observing its UT type.
    var isPNG: Bool {
        if #available(iOS 14.0, *) {
            return (utType as String?) == UTType.png.identifier
        } else {
            return utType == kUTTypePNG
        }
    }
}
extension RegisterEditVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        
        guard let url = info[.imageURL] as? URL else { return } // taking the result as `url` instead of uiimage

                if let image = url.asSmallImage {
                    imageRecordArray.append(image)
                    collectionView.reloadData()

                }
//        guard let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {return }
//        dismiss(animated: true)
        
//        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
//            imageRecordArray.append(image)
//            collectionView.reloadData()
//            print(imageRecordArray.count)
//
//        }
        
//        guard let url = info[.imageURL] as? URL else { return}
//
//        if let image = url.asSmall
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

extension RegisterEditVC: CLLocationManagerDelegate{
    
    func setupLocationManager(){
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func checkLocationService(){
        if CLLocationManager.locationServicesEnabled() == true{
            //Setup location manager
           print("PASSED TEST")
            setupLocationManager()
            checkLocationAuthorization()
         
        }else {
            print("DENIED TEST")
//
//            setupLocationManager()
//            checkLocationAuthorization()
            //
        }
        
    }
    
    func locationDeniedAlert() -> UIAlertController{
        let alertController = UIAlertController(title: "TITLE", message: "Please go to Settings and turn on the permissions", preferredStyle: .alert)

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
    
    func checkLocationAuthorization() {
        switch locationManager.authorizationStatus {
        case .authorizedWhenInUse:
            locationManager.startUpdatingLocation()
            break
        
        case .denied:
            print("DENIED: DENIED")
            self.present(locationDeniedAlert(), animated: true)
            break
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            locationManager.requestWhenInUseAuthorization()
            break
        case .authorizedAlways:
            locationManager.startUpdatingLocation()
            break
        default:
            locationManager.requestWhenInUseAuthorization()
            
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return}
        
        latitudeValue = location.coordinate.latitude
        longitudeValue = location.coordinate.longitude
        print("Final \(longitudeValue)")
        
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .denied{
            print("TESTING")
            manager.requestLocation()
        }
        
    }
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkLocationAuthorization()
    }
}

