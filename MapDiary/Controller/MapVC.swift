//
//  MapVC.swift
//  MapDiary
//
//  Created by canberk yılmaz on 2023-03-11.
//

import UIKit
import MapKit


class MapVC: UIViewController, MKMapViewDelegate {
    
    let modelView = ModelView()
    
    @IBOutlet weak var mapView: MKMapView!
    
    var longituteV = Double()
    var latitudeV = Double()
    
    let pin = MKPointAnnotation()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        mapView.delegate = self
        goToMap(lat: latitudeV, lon: longituteV)
        setupUI()

    }
    
    private func setupUI() {
        let backgroundColor: UIColor
        let navigationFontColor: UIColor
        
        if traitCollection.userInterfaceStyle ==  .light{
            backgroundColor = UIColor.getColors.lightModeBlueColor
            navigationFontColor = UIColor.getColors.lightModeTextColor
        }else {
            backgroundColor = UIColor.getColors.darkModeBlueColor
            navigationFontColor = UIColor.getColors.darkModeTextColor
        }
        
        let attrs = [
            NSAttributedString.Key.foregroundColor: navigationFontColor,
            NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 22)
        ]
        
        navigationController?.navigationBar.titleTextAttributes = attrs
        navigationController?.navigationBar.tintColor = navigationFontColor
        view.backgroundColor = backgroundColor
        
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        setupUI()
    }
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        openMapButtonAction(latitude: latitudeV, longitude: longituteV)
        
    }
    
    func goToMap(lat: Double, lon: Double){
        //taking location parameters and assign it as CLLocation
        let location = CLLocation(latitude: lat, longitude: lon)
        //changing the CLLocation instance into CLLocationCoordinate2D
        let coordinate = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        //determining the zoom rate
        let span = MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
        //setting the region
        let region = MKCoordinateRegion(center: coordinate, span: span)
        mapView.setRegion(region, animated: true)
        //adding a annotation pin to the given region
        
        pin.coordinate = coordinate
        
        pin.title = title
        pin.subtitle = "You were here!"
        mapView.addAnnotation(pin)
    }
    

    func openMapButtonAction(latitude: Double, longitude: Double) {
        

            let appleURL = "http://maps.apple.com/?daddr=\(latitude),\(longitude)"
            let googleURL = "comgooglemaps://?daddr=\(latitude),\(longitude)&directionsmode=driving"
            let wazeURL = "waze://?ll=\(latitude),\(longitude)&navigate=false"
           
            let appleItem = ("Apple Maps", URL(string:appleURL)!)
            let googleItem = ("Google Maps", URL(string:googleURL)!)
            let wazeItem = ("Waze", URL(string:wazeURL)!)
           var installedNavigationApps: [(String, URL)] = []
        
        if UIApplication.shared.canOpenURL(appleItem.1){
            installedNavigationApps.append(appleItem)
        }

            if UIApplication.shared.canOpenURL(googleItem.1) {
                installedNavigationApps.append(googleItem)
            }

            if UIApplication.shared.canOpenURL(wazeItem.1) {
                installedNavigationApps.append(wazeItem)
            }

            let alert = UIAlertController(title: "Selection", message: "Select Navigation App", preferredStyle: .actionSheet)
        
        if installedNavigationApps.count < 1 {
           

            let noNavAppButton = UIAlertAction(title: "Bad URL or There is no supported navigation apps(Apple Maps, Google Maps or Waze)", style: .cancel, handler: { _ in
                self.mapView.deselectAnnotation(self.pin, animated: true)

            })
            
            alert.addAction(noNavAppButton)
        }else {
            for app in installedNavigationApps {
                
                let button = UIAlertAction(title: app.0, style: .default, handler: { _ in
                    UIApplication.shared.open(app.1, options: [:], completionHandler: nil)
                    self.mapView.deselectAnnotation(self.pin, animated: true)

                })
                alert.addAction(button)
            }
        }
            let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: {_ in
                self.mapView.deselectAnnotation(self.pin, animated: true)
            })
            alert.addAction(cancel)
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            
            if let popoverController = alert.popoverPresentationController {
                popoverController.sourceView = self.view //to set the source of your alert
                popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0) // you can set this as per your requirement.
                popoverController.permittedArrowDirections = [] //to hide the arrow of any particular direction
            }
        }
            present(alert, animated: true)
            
        }
    
    @IBAction func navigateToMap(_ sender: UIBarButtonItem) {
        
        openMapButtonAction(latitude: latitudeV, longitude: longituteV)

    }
    
    

}




