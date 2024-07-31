//
//  DetailsViewController.swift
//  shoppingList
//
//  Created by Ahmet Karaman on 24.07.2024.
//

import UIKit
import CoreData

class DetailsViewController: UIViewController, UINavigationBarDelegate, UIImagePickerControllerDelegate & UINavigationControllerDelegate {

    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var priceTextField: UITextField!
    @IBOutlet weak var sizeTextField: UITextField!
    
    var selectedProductName = ""
    var selectedProductUUID: UUID?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        if selectedProductName != "" {
            saveButton.isHidden = true
            if let uuidString = selectedProductUUID?.uuidString {
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                let context = appDelegate.persistentContainer.viewContext
                
                let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Shopping")
                fetchRequest.predicate = NSPredicate(format: "id = %@", uuidString)
                fetchRequest.returnsObjectsAsFaults = false
                
                do {
                    let results = try context.fetch(fetchRequest)
                    
                    if results.count > 0 {
                        for result in results as! [NSManagedObject] {
                            if let name = result.value(forKey: "name") as? String {
                                nameTextField.text = name
                            }
                            if let price = result.value(forKey: "price") as? Int {
                                priceTextField.text = String(price)
                            }
                            if let size = result.value(forKey: "size") as? String {
                                sizeTextField.text = size
                            }
                            if let imageData = result.value(forKey: "image") as? Data {
                                let image = UIImage(data: imageData)
                                imageView.image = image
                            }
                        }
                    } else {
                        saveButton.isHidden = false
                        saveButton.isEnabled = false
                        nameTextField.text = ""
                        priceTextField.text = ""
                        sizeTextField.text = ""
                    }
                } catch {
                    print("error!!!")
                }
            }
        }

        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(closeKeyboard))
        view.addGestureRecognizer(gestureRecognizer)
        
        imageView.isUserInteractionEnabled = true
        let imageGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(clickedImage))
        imageView.addGestureRecognizer(imageGestureRecognizer)
    }
    
    @objc func closeKeyboard() {
        view.endEditing(true)
    }
    
    @objc func clickedImage() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        
        present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imageView.image = info[.originalImage] as? UIImage
        saveButton.isEnabled = true
        self.dismiss(animated: true)
    }
    
    @IBAction func saveButton(_ sender: Any) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let shopping = NSEntityDescription.insertNewObject(forEntityName: "Shopping", into: context)
        
        shopping.setValue(nameTextField.text, forKey: "name")
        shopping.setValue(sizeTextField.text, forKey: "size")
        if let price = Int(priceTextField.text!) {
            shopping.setValue(price, forKey: "price")
        } else {
            print("Fiyat değeri geçersiz.")
        }
        
        shopping.setValue(UUID(), forKey: "id")
        
        if let imageData = imageView.image?.jpegData(compressionQuality: 0.6) {
            shopping.setValue(imageData, forKey: "image")
        }
        
        do {
            try context.save()
            print("kayıt edildi.")
        } catch {
            print("hata yaptın")
        }
        
        NotificationCenter.default.post(name: NSNotification.Name("data entered"), object: nil)
        self.navigationController?.popViewController(animated: true)
    }
}

