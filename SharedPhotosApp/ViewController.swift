//
//  ViewController.swift
//  SharedPhotosApp
//
//  Created by Ahmet Karaman on 2.08.2024.
//

import UIKit
import FirebaseAuth

class ViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


    @IBAction func sigINButton(_ sender: Any) {
        if emailTextField.text != "" && passwordTextField.text != "" {
            //giriş yapma aşaması
            Auth.auth().signIn(withEmail: emailTextField.text!, password: passwordTextField.text!) { authDataResult, error in
                if error != nil{
                    self.errorMessage(titleInput: "error!", messageInput: error?.localizedDescription ?? "you have a mistake")
                }else{
                    self.performSegue(withIdentifier: "toFeedVC", sender: nil)
                }
            }
        } else {
            errorMessage(titleInput: "Error!", messageInput: "You did not write email or password")
        }
        
    }
    
    
    @IBAction func signUpButton(_ sender: Any) {
        if emailTextField.text != "" && passwordTextField.text != "" {
            //kayıt olma işlemi
            Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!) { authdataresult, error in
                if error != nil {
                    self.errorMessage(titleInput: "hata", messageInput: error?.localizedDescription ?? "you have a mistake")
                }else{
                    self.performSegue(withIdentifier: "toFeedVC", sender: nil)
                }
            }
        } else {
            errorMessage(titleInput: "Error!", messageInput: "You did not write email or password.")
        }
    }
    
    func errorMessage (titleInput: String, messageInput:String){
        let alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(okButton)
        self.present(alert, animated: true, completion: nil)    //self :closer içinde işlem yapcaz karışıklık yapmasın
    }
    
}

