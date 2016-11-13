//
//  Crumb.swift
//  BreadCrumbs
//
//  Created by Forrest Zhao on 11/12/16.
//  Copyright © 2016 ForrestApps. All rights reserved.
//

import UIKit
import FirebaseDatabase

struct Crumb {
    
    var key: String
    var crumbKey: String
    var name: String
//    var rating: Int?
    //var locations: [Location] = []
    let ref: FIRDatabaseReference?
    
    init(name: String, key: String = "", crumbKey: String) {
        self.key = key
        self.name = name
        self.crumbKey = crumbKey
        self.ref = nil
    }
    
    init(snapshot: FIRDataSnapshot) {
        key = snapshot.key
        let snapshotValue = snapshot.value as! [String: AnyObject]
        self.name = snapshotValue["name"] as! String
        self.crumbKey = snapshotValue["crumbKey"] as! String
//        self.rating = snapshotValue["rating"] as? Int
        ref = snapshot.ref
    }
    
    func toAnyObject() -> Any {
        return [
            "name": name,
            "crumbKey": crumbKey
//            "rating": rating!
        ]
    }
    
}

struct Location {
    
    var crumbKey: String
    var key: String
    var name: String
    var latitude: Double
    var longitude: Double
    var placeInLine: Int
    //var image: UIImage?
//    var description: String?
    
    let ref: FIRDatabaseReference?
    
    init(crumbKey: String, name: String, latitude: Double, longitude: Double, placeInLine: Int, key: String = "") {
        self.crumbKey = crumbKey
        self.key = key
        self.name = name
        self.latitude = latitude
        self.longitude = longitude
        self.placeInLine = placeInLine
        self.ref = nil
    }
    
    init(snapshot: FIRDataSnapshot) {
        key = snapshot.key
        let snapshotValue = snapshot.value as! [String: AnyObject]
        self.crumbKey = snapshotValue["crumbKey"] as! String
        self.name = snapshotValue["name"] as! String
        self.latitude = snapshotValue["latitude"] as! Double
        self.longitude = snapshotValue["longitude"] as! Double
        self.placeInLine = snapshotValue["placeInLine"] as! Int
//        self.description = snapshotValue["description"] as? String
        ref = snapshot.ref
    }
    
    func toAnyObject() -> Any {
        return [
            "crumbKey": crumbKey,
            "name": name,
            "latitude": latitude,
            "longitude": longitude,
            "placeInLine": placeInLine
//            "description": description!
        ]
    }
    
}
