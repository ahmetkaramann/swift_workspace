//
//  SpecialImageView.swift
//  SuperKahramanSwiftUI
//
//  Created by Ahmet Karaman on 17.08.2024.
//

import SwiftUI

struct SpecialImageView: View {
    
    var image : Image
    var body: some View {
       image
            .resizable()
            .aspectRatio(contentMode: .fit)
            .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
            .overlay(Circle().stroke(Color.red, lineWidth: 5))
            .shadow(radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
    }
}

#Preview {
    SpecialImageView(image: Image("spiderman"))
}
