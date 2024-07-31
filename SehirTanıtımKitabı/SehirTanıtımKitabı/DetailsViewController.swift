//
//  DetailsViewController.swift
//  SehirTanıtımKitabı
//
//  Created by Ahmet Karaman on 23.07.2024.
//

import UIKit

class DetailsViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var regionOfCity: UILabel!
    
    var selectedCity : City?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        label.text = selectedCity?.name
        regionOfCity.text = selectedCity?.region
        imageView.image = selectedCity?.image
        
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
