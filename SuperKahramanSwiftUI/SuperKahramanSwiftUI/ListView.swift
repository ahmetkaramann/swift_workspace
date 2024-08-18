//
//  ContentView.swift
//  SuperKahramanSwiftUI
//
//  Created by Ahmet Karaman on 17.08.2024.
//

import SwiftUI

struct ListView: View {
    var body: some View {
        NavigationView {
            List(arrayOfHeros) { hero in
                NavigationLink {
                    DetailsView(selectedHero: hero)
                } label: {
                   ListRowView(superhero: hero)
                }

            }.navigationTitle(Text("Superheros"))
        }
    }
}

#Preview {
    ListView()
}
