//
//  UploadViewController.swift
//  SharedPhotosApp
//
//  Created by Ahmet Karaman on 2.08.2024.
//

import UIKit
import FirebaseStorage
import FirebaseFirestore
import FirebaseAuth

class UploadViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var commentTextField: UITextField!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        imageView.isUserInteractionEnabled = true
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(clickedImage))
        imageView.addGestureRecognizer(gestureRecognizer)
    }
    
    @objc func clickedImage(){
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        present(picker, animated: true, completion: nil)
    }
    
    //resim seçildikten sonra ne yapılması gerektiği ise 'didFinishPickingMedia' fonksiyonu kullanılıyor
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        //bir dictionary alıyoruz burada info.key olarak ardından ise any değişkenini UIImage olarak cast ediyoruz
        imageView.image = info[.originalImage] as? UIImage  //ünlem koymuyoruz data gelmeyebilir program çöker , ımageView değiştirme işlemi
        self.dismiss(animated: true, completion: nil)   //resim seçildikten sonra kapatıcaz
    }
    
    @IBAction func uploadButton(_ sender: Any) {
        let storage = Storage.storage()
        let storageReference = storage.reference()
        
        let mediaFolder = storageReference.child("Media")
        if let data = imageView.image?.jpegData(compressionQuality: 0.5){
            
            let uuid = UUID().uuidString
            let imageReference = mediaFolder.child("\(uuid).jpg")
            imageReference.putData(data) { StorageMetadata, error in
                if error != nil {
                    self.errorMessage(title: "error!", message: error?.localizedDescription ?? "you have a mistake")
                } else{
                    //url yi alma işlemi
                    imageReference.downloadURL { url, error in
                        if error == nil {
                            let imageUrl = url?.absoluteString
                            if let imageUrl = imageUrl {     // yukarıda imageUrl opsiyoneldi(string?) onu opsiyonellikten çıkarcak if let
                                let firestorageDatabase = Firestore.firestore() // Firestore veritabanı referansını alıyoruz
                                
                                // Firestore'a eklenecek verileri bir sözlük içinde topluyoruz
                                let firestoreDictionary = [ "imageUrl":imageUrl,
                                                            "comment":self.commentTextField.text!,
                                                            "email": Auth.auth().currentUser!.email as Any,
                                                            "date":FieldValue.serverTimestamp() ]
                                
                                // "Post" koleksiyonuna belge ekliyoruz
                                firestorageDatabase.collection("Post").addDocument(data: firestoreDictionary) { (error) in
                                    if error != nil { //hata varsa
                                        self.errorMessage(title: "error!", message: error?.localizedDescription ?? "you have mistake")
                                    } else {    //hata yoksa
                                        //resim yüklendikten sonra biizi 'feed' sayfasına gönderip upload ekranını da yenileme bölümü
                                        self.imageView.image = UIImage(named: "selectImage")
                                        self.commentTextField.text = ""
                                        self.tabBarController?.selectedIndex = 0
                                    }
                                    
                                }
                            
                            }
                            
                        }
                    }
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
