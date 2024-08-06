//
//  FeedViewController.swift
//  SharedPhotosApp
//
//  Created by Ahmet Karaman on 2.08.2024.
//

import UIKit
import FirebaseFirestore
import SDWebImage

class FeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
//    var arrayOfEmail = [String]()
//    var arrayOfComment = [String]()
//    var arrayOfImage = [String]()
    
    var postDizisi = [Post]()   //post classının elamanlarını tutucam
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        getData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postDizisi.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! FeedTableViewCell
        cell.userNameText.text = postDizisi[indexPath.row].email
        cell.userCommentText.text = postDizisi[indexPath.row].comment
        cell.postImageView.sd_setImage(with: URL(string: self.postDizisi[indexPath.row].imageUrl))
        return cell
    
        
    }
    
    func getData() {
        let firestoreDatabase = Firestore.firestore()
        firestoreDatabase.collection("Post").order(by: "date", descending: true).addSnapshotListener { snapshot, error in
            if error != nil {
                self.errorMessage(title: "erorr!", message: error?.localizedDescription ?? "you have mistakes")
            } else {
                if snapshot?.isEmpty != true && snapshot != nil {
//                    self.arrayOfEmail.removeAll(keepingCapacity: false)
//                    self.arrayOfComment.removeAll(keepingCapacity: false)
//                    self.arrayOfImage.removeAll(keepingCapacity: false)
                    self.postDizisi.removeAll(keepingCapacity: false)
                    
                    for document in snapshot!.documents {
                        if let imageUrl = document.get("imageUrl") as? String { //dictionaryde any olarak kaydetmiştik burada string olarak cast edicez görselurl yi almış şekilde geldik sonra bunları tek tek eklicez
                            if let comment = document.get("comment") as? String {
                                if let email = document.get("email") as? String {
                                    self.postDizisi.append(Post(email: email, comment: comment, imageUrl: imageUrl))
                                    
                                }
                                
                            }
                        }
                        
                        
                        
                    }
                    
                    self.tableView.reloadData()
                }
            }
            
        }
    }
    
    //errorlar için fonc
    func errorMessage(title: String, message: String){
        let alert  = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(okButton)
        self.present(alert, animated: true)
    }
    
    

}
