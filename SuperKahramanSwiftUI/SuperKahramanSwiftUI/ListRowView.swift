//
//  ListRowView.swift
//  SuperKahramanSwiftUI
//
//  Created by Ahmet Karaman on 17.08.2024.
//

import SwiftUI

struct ListRowView: View {
    var superhero : SuperHero
    
    var body: some View {
        HStack{
            Image(superhero.imageName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width:100, height: 50, alignment: .leading)
                .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
    
            
            VStack{
                Text(superhero.name)
                    .bold()
                    
                
                Text(superhero.realName)
            }
            Spacer()
        }
    }
}

#Preview {
    ListRowView(superhero: batman)
}
