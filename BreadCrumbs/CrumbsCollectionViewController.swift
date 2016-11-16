//
//  CrumbsCollectionViewController.swift
//  BreadCrumbs
//
//  Created by Forrest Zhao on 11/12/16.
//  Copyright © 2016 ForrestApps. All rights reserved.
//

import UIKit
import FirebaseDatabase
import Firebase

private let reuseIdentifier = "Cell"

class CrumbsCollectionViewController: UICollectionViewController {

    struct FlickrSearchResults {
        let searchTerm: String
        let searchResults = [String]()
    }

    fileprivate let reuseIdentifier = "crumbCell"
    fileprivate let sectionInsets = UIEdgeInsets(top: 50.0, left: 20.0, bottom: 50.0, right: 20.0)
    fileprivate let itemsPerRow: CGFloat = 2

    
    let ref = FIRDatabase.database().reference(withPath: "crumbs")
    var crumbs: [Crumb] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //How to check if user is currently logged in
        print("UID is +++++ =\(FIRAuth.auth()?.currentUser?.uid)")
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        ref.observe(.value, with: { snapshot in
            var newCrumbs: [Crumb] = []
            //print(snapshot.value)
            for item in snapshot.children {
                let crumb = Crumb(snapshot: item as! FIRDataSnapshot)
                newCrumbs.append(crumb)
            }
            self.crumbs = newCrumbs
            self.collectionView?.reloadData()
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
     // MARK: - Navigation
     
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showCrumbDetail" {
            let dest = segue.destination as! ShowCrumbViewController
            if let cell = sender as? UICollectionViewCell, let indexPath = collectionView?.indexPath(for: cell) {
                dest.crumbKey = crumbs[indexPath.row].crumbKey
            }
        }
     }
    
    
    // MARK: UICollectionViewDataSource
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return self.crumbs.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = (collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)) as! CrumbCell
        cell.name.text = crumbs[indexPath.row].name
        cell.cityLabel.text = crumbs[indexPath.row].city
        cell.backgroundColor = UIColor.cyan
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
       
    }
   
    
}

extension CrumbsCollectionViewController: UICollectionViewDelegateFlowLayout {
    //1
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        //2
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        
        return CGSize(width: widthPerItem, height: widthPerItem)
    }
    
    //3
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    // 4
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
}
