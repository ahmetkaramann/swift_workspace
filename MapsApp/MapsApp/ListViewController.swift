//
//  ListViewController.swift
//  MapsApp
//
//  Created by Ahmet Karaman on 29.07.2024.
//

import UIKit
import CoreData

class ListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var arrayOfName = [String] ()
    var arrayOfID = [UUID] ()
    var selectedLocationName = ""
    var selectedLocationID : UUID?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        //tapbara + işareti eklicez
        navigationController?.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.add, target: self, action: #selector(addLocation))
        getData()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(getData), name: NSNotification.Name("createdNewLocation") , object: nil)
    }
    
    
    @objc func getData(){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Location")
        fetchRequest.returnsObjectsAsFaults = false
        
        do{
            let results =  try context.fetch(fetchRequest)
            if results.count > 0 {          // bir veri geliyorsa
                // for loop a girmeden diziyi boşalmak iyi çünkü birden fazla gelebiliyor
                arrayOfName.removeAll(keepingCapacity: false)
                arrayOfID.removeAll(keepingCapacity: false)
                
                for result in results as! [NSManagedObject] {       // gelen objeler bir any diziisi olarak gelitor NSOBJECT isttiyorum
                    // burdan name ve id leri alcaz ama onlarda any olarak geliyor stringe uuıd ye çevirmek için if let kullanırız sonra o arraylari boş bir dizi değişkenine atarız
                    if let name = result.value(forKey: "name") as? String {
                        arrayOfName.append(name)
                    }
                    if let id  = result.value(forKey: "id") as? UUID {
                        arrayOfID.append(id)
                    }
                    
                }
                tableView.reloadData()      //tableviewe gğncelledik
            }
            
           
        }catch{
            print("errorr")
        }
        
    }
    @objc func addLocation (){
        selectedLocationName = "" //diğer tarafta boş gelsin çünkü if else de else girsin yeni veri eklemeye geldiği belli olsun
        performSegue(withIdentifier: "toMapsVC", sender: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayOfName.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = arrayOfName[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedLocationName = arrayOfName[indexPath.row]   //tıklanınca o an seçilenleri atamış oluyoruz
        selectedLocationID = arrayOfID[indexPath.row]
        performSegue(withIdentifier: "toMapsVC", sender: nil)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toMapsVC" {
            let destination = segue.destination as! MapsViewController
            destination.selectedName = selectedLocationName
            destination.selectedID = selectedLocationID     // ilk ve ikinci sayfadaki seçilen id ve isimleri değişkene atadık
            
        }
    }
    
}
