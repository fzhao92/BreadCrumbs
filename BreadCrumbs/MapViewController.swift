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

class MapViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    var places: [CLPlacemark] = []
    var locationManager: CLLocationManager!
    var placeInLineCounter = 1
    //var breadCrumb: Crumb = Crumb()
    var locationList: [Location] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        initGestures()
        setupLocationManager()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
                    print(pm)
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
        let location = Location(name: locationName, latitude: annotation.coordinate.latitude, longitude: annotation.coordinate.longitude, placeInLine: placeInLineCounter)
        placeInLineCounter += 1
        locationList.append(location)
    }

    @IBAction func saveButtonTapped(_ sender: UIBarButtonItem) {
        saveCrumb()
    }
    
    func saveCrumb() {
        var crumb: Crumb = Crumb(name: "default")
        let saveAlert = UIAlertController(title: "New Bread Crumb", message: "Save your trail!", preferredStyle: .alert)
        let saveAction = UIAlertAction(title: "Save", style: .default) { _ in
            guard let textField = saveAlert.textFields?.first, let text = textField.text else { return }
            crumb.name = text
            crumb.locations = self.locationList
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        saveAlert.addTextField()
        saveAlert.addAction(saveAction)
        saveAlert.addAction(cancelAction)
        present(saveAlert, animated: true, completion: nil)

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
        mapView
    }
    
}

