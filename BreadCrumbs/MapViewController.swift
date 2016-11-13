//
//  ViewController.swift
//  BreadCrumbs
//
//  Created by Forrest Zhao on 11/12/16.
//  Copyright © 2016 ForrestApps. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import FirebaseDatabase

class MapViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    var places: [CLPlacemark] = []
    var locationManager: CLLocationManager!
    var placeInLineCounter = 1
    var locationList: [Location] = []
    var crumbKey: String = ""
    let city = ""
    
    let locationsRef = FIRDatabase.database().reference(withPath: "locations")
    let crumbsRef = FIRDatabase.database().reference(withPath: "crumbs")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        placeInLineCounter = 1
        initGestures()
        setupLocationManager()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func initGestures() {
        let longPressMapGesture = UILongPressGestureRecognizer(target: self, action: #selector(self.addAnnotation(_ :)) )
        mapView.addGestureRecognizer(longPressMapGesture)
    }
    
    func addAnnotation(_ gestureRecognizer: UILongPressGestureRecognizer) {
        if gestureRecognizer.state == UIGestureRecognizerState.began {
            let touchPoint = gestureRecognizer.location(in: mapView)
            let newCoordinates = mapView.convert(touchPoint, toCoordinateFrom: mapView)
            let annotation = MKPointAnnotation()
            annotation.coordinate = newCoordinates
            
            CLGeocoder().reverseGeocodeLocation(CLLocation(latitude: newCoordinates.latitude, longitude: newCoordinates.longitude), completionHandler: {(placemarks, error) -> Void in
                if error != nil {
                    print("Reverse geocoder failed with error" + (error?.localizedDescription)!)
                    return
                }
                
                if (placemarks?.count)! > 0 {
                    let pm = (placemarks?[0])! 
                    // not all places have thoroughfare & subThoroughfare so validate those values
                    annotation.title = pm.thoroughfare! + ", " + pm.subThoroughfare!
                    annotation.subtitle = pm.subLocality
                    self.mapView.addAnnotation(annotation)
                }
                else {
                    annotation.title = "Unknown Place"
                    self.mapView.addAnnotation(annotation)
                    print("Problem with the data received from geocoder")
                }
                self.saveLocationToList(annotation: annotation)
            })
        }
    }
    
    func saveLocationToList(annotation: MKAnnotation) {
        var locationName = ""
        if let name = annotation.title {
            if let unwrappedName = name {
                locationName = unwrappedName
            }
        }
        let location = Location(crumbKey: crumbKey, name: locationName, latitude: annotation.coordinate.latitude, longitude: annotation.coordinate.longitude, placeInLine: placeInLineCounter)
        placeInLineCounter += 1
        locationList.append(location)
    }

    @IBAction func saveButtonTapped(_ sender: UIBarButtonItem) {
        saveCrumb()
    }
    
    @IBAction func clearPinButtonTapped(_ sender: UIBarButtonItem) {
        clearPins()
    }
    
    func saveCrumb() {
        
        let saveAlert = UIAlertController(title: "New Bread Crumb", message: "Save your trail!", preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: "Save", style: .default) { _ in
            guard let textField = saveAlert.textFields?.first, let text = textField.text else { return }
            let crumbKey = self.genKey()
            let crumb = Crumb(name: text, crumbKey: crumbKey)
            let crumbsRef = self.crumbsRef.child(text.lowercased())
            crumbsRef.setValue(crumb.toAnyObject())
            
            for (index, _) in self.locationList.enumerated() {
                print("index is \(index)")
                self.locationList[index].crumbKey = crumbKey
                let locationsRef = self.locationsRef.child(self.genKey())
                locationsRef.setValue(self.locationList[index].toAnyObject())
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        saveAlert.addTextField()
        saveAlert.addAction(saveAction)
        saveAlert.addAction(cancelAction)
        present(saveAlert, animated: true, completion: nil)

    }
    
    func clearPins() {
        mapView.removeAnnotations(mapView.annotations)
        locationList.removeAll()
    }
}

extension MapViewController: CLLocationManagerDelegate {
    
    func setupLocationManager(){
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last! as CLLocation
        centerMapOnCurrentLocation(location: location)
    }
    
    func centerMapOnCurrentLocation(location: CLLocation) {
        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let span = MKCoordinateSpanMake(0.02, 0.02) //arbitrary span (about 2X2 miles i think)
        let region = MKCoordinateRegion(center: center, span: span)
        mapView.setRegion(region, animated: true)
    }
    
}

extension MapViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        
    }
    
}



extension MapViewController {
    
    func genKey() -> String {
        let length = 12
        let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let len = UInt32(letters.length)
        
        var randomString = ""
        
        for _ in 0 ..< length {
            let rand = arc4random_uniform(len)
            var nextChar = letters.character(at: Int(rand))
            randomString += NSString(characters: &nextChar, length: 1) as String
        }
        
        return randomString
    }
}

