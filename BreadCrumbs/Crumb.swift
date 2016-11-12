//
//  Crumb.swift
//  BreadCrumbs
//
//  Created by Forrest Zhao on 11/12/16.
//  Copyright © 2016 ForrestApps. All rights reserved.
//

import UIKit

struct Crumb {
    
    var name: String
    var rating: Int?
    var locations: [Location] = []
    
    init(name: String) {
        self.name = name
    }
    
}

struct Location {
    
    var name: String
    var latitude: Double
    var longitude: Double
    var placeInLine: Int
    var image: UIImage?
    var description: String?
    
    init(name: String, latitude: Double, longitude: Double, placeInLine: Int) {
        self.name = name
        self.latitude = latitude
        self.longitude = longitude
        self.placeInLine = placeInLine
    }
    
}
