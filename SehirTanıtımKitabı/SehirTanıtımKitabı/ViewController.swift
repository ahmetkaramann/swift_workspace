//
//  ViewController.swift
//  SehirTanıtımKitabı
//
//  Created by Ahmet Karaman on 23.07.2024.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var userSelection : City?
    
    var arrayOfCities = [City]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
//       Cities
        let istanbul = City(name: "istanbul", region: "marmara bölgesi", image: UIImage(named: "istanbul")!)
        let ankara = City(name: "ankara", region: "iç anadolu bölgesi", image: UIImage(named: "ankara")!)
        let aksaray = City(name: "aksaray", region: "iç anadolu bölgesi", image: UIImage(named: "aksaray")!)
        let izmir = City(name: "izmir", region: "ege bölgesi", image: UIImage(named: "izmir")!)
        
        
        arrayOfCities = [istanbul, ankara, aksaray, izmir]
        
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayOfCities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = arrayOfCities[indexPath.row].name
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        userSelection = arrayOfCities[indexPath.row]
        performSegue(withIdentifier: "toDetailsVC", sender: nil)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetailsVC" {
            let destination = segue.destination as! DetailsViewController
            destination.selectedCity = userSelection
        }
    }
    
    

}

