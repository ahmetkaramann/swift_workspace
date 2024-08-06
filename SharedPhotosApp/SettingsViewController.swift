//
//  SettingsViewController.swift
//  SharedPhotosApp
//
//  Created by Ahmet Karaman on 2.08.2024.
//

import UIKit
import FirebaseAuth

class SettingsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func signOutButton(_ sender: Any) {
        
        do{
            try Auth.auth().signOut()
            performSegue(withIdentifier: "toVC", sender: nil)
        }catch{
            print("hata")
        }
        
        
        
    }
    

}
