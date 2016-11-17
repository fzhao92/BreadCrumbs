//
//  RegisterViewController.swift
//  BreadCrumbs
//
//  Created by Alexander Mason on 11/15/16.
//  Copyright © 2016 ForrestApps. All rights reserved.
//

import UIKit
import Firebase

class RegisterViewController: UIViewController {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBAction func registerButton(_ sender: Any) {
        handleRegister()
    }
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    
    
    func handleRegister() {
        print("handle register called")
        guard let email = emailTextField.text, let password = passwordTextField.text, let name = nameTextField.text else { return }
        FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { (user, error) in
            
            if error != nil {
                print("error registering \(error)")
                return
            }
            guard let uid = user?.uid else {
                print("uid failed")
                return
            }
            
            let ref = FIRDatabase.database().reference(withPath: "user")
            let user = ref.child(uid)
            let values = ["name": name, "email": email]
            print("registering-----------------")
            user.updateChildValues(values, withCompletionBlock: { (error, ref) in
                if error != nil {
                    print("error updating child values \(error)")
                    return
                }
                print("User ID inside of handleRegister is == \(FIRAuth.auth()?.currentUser?.uid)")
            })
            
        })
    }
    

   

}
