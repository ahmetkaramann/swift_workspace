//
//  DetailsView.swift
//  SuperKahramanSwiftUI
//
//  Created by Ahmet Karaman on 17.08.2024.
//

import SwiftUI

struct DetailsView: View {
    
    var selectedHero : SuperHero
    var body: some View {
        VStack{
        //haritayı koycaz
            mapView(coordinateee: selectedHero.cordinateLocation)
                .frame(height: UIScreen.main.bounds.height * 0.3)  //bütün ekranı kaplamaması için frame kullancaz
        
        //image koycaz
            SpecialImageView(image: Image(selectedHero.imageName))
                .frame(width:UIScreen.main.bounds.width * 0.5, height:UIScreen.main.bounds.height * 0.5, alignment:.center)
                .offset(x:UIScreen.main.bounds.width * -0.33, y:UIScreen.main.bounds.height * -0.25) //resmin nerde durmasını ayarladım
            
        //diğer isim,şehir gibi şeyleri ayrı bir vstck aççcam
            VStack{
                HStack{
                    Text(selectedHero.name)
                        .padding(.leading)
                        .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                        .bold()
                    Spacer()
                    Text(selectedHero.realName)
                        .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                        .padding(.trailing)
                }
            
                HStack{
                    Text(selectedHero.city)
                        .padding(.leading)
                    Spacer()
                    Text(selectedHero.job)
                        .padding(.trailing)
                }
                //about için
                ScrollView{
                    Text(selectedHero.about)
                        .padding()
                }
            }.padding(.top, UIScreen.main.bounds.height * -0.43)
            
            
        } //en üsteki vstack
    }
}

#Preview {
    DetailsView(selectedHero: batman)
}
