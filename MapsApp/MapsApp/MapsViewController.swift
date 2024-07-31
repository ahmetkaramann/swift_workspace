//
//  ViewController.swift
//  MapsApp
//
//  Created by Ahmet Karaman on 27.07.2024.
//

import UIKit
import MapKit
import CoreLocation  // KENDİ konumumuz için
import CoreData

class MapsViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var noteTextField: UITextField!
    @IBOutlet weak var saveButton: UIButton!
    
    var locationManager = CLLocationManager()
    var selectedLatitude = Double()
    var selectedLongitude = Double()
    var selectedName = ""
    var selectedID : UUID?
    
    var annotationTitle = ""
    var annotationSubtitle = ""
    var annotationLatitude = Double()
    var annotationLangitude = Double()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self     //Harita görünümünün delegasyonunu ViewController'e atar.
        locationManager.delegate = self    // konum yöneticisinin delegasyonunu viewControllere vermek
        
        locationManager.desiredAccuracy = kCLLocationAccuracyBest   //Konum güncellemelerinin en yüksek doğrulukta olmasını sağlar.
        locationManager.requestWhenInUseAuthorization()         //Uygulama kullanılırken konum bilgisine erişim izni istemek için kullanılır.
        locationManager.startUpdatingLocation()
        
        //haritaya uzun tıklandığında o konumu işaretlemek için
        let gestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(selectLocation(gestureRecognizer: ))) //uzun basılınca yapıcağı aksiyon
        gestureRecognizer.minimumPressDuration = 3      // ne kadar süre basılınca algılayacak
        mapView.addGestureRecognizer(gestureRecognizer) // basılınca algılamayı ekledik
        
        if selectedName != "" {
            //coreData'dan verileri çek
            
            if let uuidString = selectedID?.uuidString{
                //uuıd ye göre bir filtremeleme yaparak coredatadan veri çekicez
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                let context = appDelegate.persistentContainer.viewContext
                
                let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Location")
                fetch.predicate = NSPredicate(format: "id = %@", uuidString)        //filtreleme yapıyporuz hangi kolonu hangi değerle filtrelicemizi yazıyoruz
                fetch.returnsObjectsAsFaults = false
                
                do{
                    let results = try context.fetch(fetch)
                    
                    if results.count > 0 {
                        for result in results as! [NSManagedObject] {
                            if let name = result.value(forKey: "name") as? String {
                                //yukarıda oluşturdğum boş değişkenleri bu değişkenlere eşitleyerek her yerden kullanabilirim iç içe if yaparız çünkü biri yazılmazsa anotation yapılmasın istiyoruz
                                annotationTitle = name
                                if let note = result.value(forKey: "note") as? String {
                                    annotationSubtitle = note
                                    if let latitude = result.value(forKey: "latitude") as? Double{
                                        annotationLatitude = latitude
                                        if let longitude = result.value(forKey: "longitude") as? Double{
                                            annotationLangitude = longitude
                                            
                                            let annotation = MKPointAnnotation()
                                            annotation.title = annotationTitle
                                            annotation.subtitle = annotationSubtitle
                                            let coordinate = CLLocationCoordinate2D(latitude: annotationLatitude, longitude: annotationLangitude)
                                            annotation.coordinate = coordinate
                                            
                                            mapView.addAnnotation(annotation)
                                            nameTextField.text = annotationTitle
                                            noteTextField.text = annotationSubtitle
                                            
                                      
                                            
                                        }
                                        
                                    }
                                    
                                }
                            }
                            
                        }
                    }
                    
                }catch{
                    
                    
                }
                
                
                
                
                
            }
        }else{
            //yeni veri eklemek için geldi 
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: any MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation{
            return nil      // kullanıcının mevcut konumunu temsil ediyorsa (MKUserLocation), bu durumda hiçbir görünüm döndürmez
        }
        let reuseId = "myAnnotation" //Anotasyon görünümleri için yeniden kullanım kimliği. Bu kimlik, görünümün yeniden kullanılabilir olmasını sağlar.
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) //yeni oluşturulmıuş konum Eğer varsa, pinView değişkenine bu yeniden kullanılabilir görünümü atar.
        
        if pinView == nil { // pinView yeniden kullanılabilir bir görünüm bulamazsa, yeni bir MKPinAnnotationView oluşturur.
            pinView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: reuseId) // Yeni bir iğne tipi anotasyon görünümü oluşturur.
            pinView?.canShowCallout = true//: Anotasyonun üzerine tıklandığında bilgi baloncuğunun gösterilmesini sağlar.
            pinView?.tintColor = .red
            
            let button = UIButton(type: .detailDisclosure)
            pinView?.rightCalloutAccessoryView = button
        }else{
            pinView?.annotation = annotation
        }
        return pinView // pinView, artık tanımlanmış ve uygun şekilde yapılandırılmış bir MKAnnotationView nesnesidir. Bu görünüm, haritada belirtilen annotation için döndürülür.
    }
    
    //oluşturduğumuz butonun üstüne tıklanınca ne olcak
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        // Eğer seçilen konum adı boş değilse (bir konum seçilmişse) devam et
        if selectedName != "" {
            // Seçilen anotasyonun enlem ve boylam bilgilerini kullanarak bir CLLocation nesnesi oluştur
            let requestLocation = CLLocation(latitude: annotationLatitude, longitude: annotationLangitude)
            
            // CLGeocoder kullanarak geriye dönük coğrafi kodlama işlemi yap
            CLGeocoder().reverseGeocodeLocation(requestLocation) { placemarkArray, error in
                // Eğer placemarkArray nil değilse ve içinde en az bir placemark varsa
                if let placemarks = placemarkArray {
                    if placemarks.count > 0 {
                        // İlk placemark'ı al ve MKPlacemark nesnesine dönüştür
                        let newPlacemark = MKPlacemark(placemark: placemarks[0])
                        // MKMapItem nesnesi oluştur ve bu yeni placemark'ı kullan
                        let item = MKMapItem(placemark: newPlacemark)
                        // Harita öğesinin adını anotasyon başlığı olarak ayarla
                        item.name = self.annotationTitle
                        
                        // Yönlendirme modu için seçenekler belirle (sürüş yönlendirmesi)
                        let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
                        
                        // MKMapItem nesnesini belirli yönlendirme seçenekleri ile Apple Maps uygulamasında aç
                        item.openInMaps(launchOptions: launchOptions)
                    }
                }
            }
        }
    }

    
    
    
    
    
    
    
    
    
    
    @objc func selectLocation (gestureRecognizer:UILongPressGestureRecognizer) {
        if gestureRecognizer.state == .began {
            let touchedPoint = gestureRecognizer.location(in: mapView)  //dokunulan noktayı tespit etmek için
            let touchedCoordinate = mapView.convert(touchedPoint, toCoordinateFrom: mapView) //noktayı algılatyıp kordinatlarını bulmak için
            
            selectedLatitude = touchedCoordinate.latitude
            selectedLongitude = touchedCoordinate.longitude
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = touchedCoordinate
            annotation.title = nameTextField.text
            annotation.subtitle = noteTextField.text
            mapView.addAnnotation(annotation)
            
        }
        
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // En güncel konumu temsil eder.
        if selectedName == "" {
            let location = CLLocationCoordinate2D(latitude: locations[0].coordinate.latitude, longitude: locations[0].coordinate.longitude)// Enlem-boylam
            let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)    // Haritanın ne kadar zoom yapılacağını belirler. (0.1)
            let region = MKCoordinateRegion(center: location, span: span) // Haritada gösterilecek bölgeyi tanımlar.
            
            mapView.setRegion(region, animated: true) // Haritada belirlenen bölgeye animasyonlu geçiş yapar.
            
            // Konum güncellemelerini durdurun
            locationManager.stopUpdatingLocation()  // ben nerde olursam oluyum işaretlenen konum ortada açılması için
        }
    }


    @IBAction func saveButton(_ sender: Any) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let newLocation = NSEntityDescription.insertNewObject(forEntityName: "Location", into: context) //entity i import ettik artık kullanabiliriz
        
        newLocation.setValue(nameTextField.text, forKey: "name")
        newLocation.setValue(noteTextField.text, forKey: "note")
        newLocation.setValue(selectedLatitude, forKey: "latitude")
        newLocation.setValue(selectedLongitude, forKey: "longitude")
        newLocation.setValue(UUID(), forKey: "id")
        
        do{
            try context.save()
            print("saved")
        }catch{
            print("error")
        }
        
        NotificationCenter.default.post(name: NSNotification.Name("createdNewLocation"), object: nil)
        navigationController?.popViewController(animated: true )    //ekranlar arası geçişi sağlıcam
        
        
    }
    
    
    
    
    
    
    
    
}

