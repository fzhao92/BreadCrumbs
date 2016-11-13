//
//  ShowCrumbViewController.swift
//  BreadCrumbs
//
//  Created by Forrest Zhao on 11/13/16.
//  Copyright © 2016 ForrestApps. All rights reserved.
//

import UIKit
import FirebaseDatabase

class ShowCrumbViewController: UIViewController {

    let ref = FIRDatabase.database().reference(withPath: "locations")
    var crumbKey: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        queryForLocations()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func queryForLocations() {
        let query = ref.queryOrdered(byChild: "crumbKey").queryEqual(toValue: crumbKey)
        query.observe(.value, with: { snapshot in
            print("Ateempt to query firebase")
            print(snapshot.value)
        })
    }

}
