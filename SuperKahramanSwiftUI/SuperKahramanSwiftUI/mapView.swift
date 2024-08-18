//
//  mapView.swift
//  SuperKahramanSwiftUI
//
//  Created by Ahmet Karaman on 17.08.2024.
//

import SwiftUI
import MapKit


struct mapView: UIViewRepresentable {
    
    var coordinateee : CLLocationCoordinate2D   //MAPVİEW HER oluştuğunda benden bir cllocation istenicek
    
    //map ilede yapılabiliyor, ancak yeni ve eski sürümlerde uyarı vericek 
    /*@State var region = MKCoordinateRegion(center: arrayOfHeros[1].cordinateLocation, span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))
    
    var body: some View {
        Map(coordinateRegion: $region)
    }*/
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
        let span = MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5)
        let region = MKCoordinateRegion(center: coordinateee, span: span)
        uiView.setRegion(region, animated: true)
    }
    
    func makeUIView(context: Context) -> MKMapView{
        MKMapView(frame: .zero)
    }
}

#Preview {
    mapView(coordinateee: arrayOfHeros[0].cordinateLocation)
}
