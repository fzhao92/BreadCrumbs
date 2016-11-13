//
//  ShowCrumbViewController.swift
//  BreadCrumbs
//
//  Created by Forrest Zhao on 11/13/16.
//  Copyright © 2016 ForrestApps. All rights reserved.
//

import UIKit

class ShowCrumbViewController: UIViewController {

    var crumbKey: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Crumb key is \(crumbKey)")
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
