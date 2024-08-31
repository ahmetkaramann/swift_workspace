//
//  ContentView.swift
//  MovieBook
//
//  Created by Ahmet Karaman on 19.08.2024.
//

import SwiftUI

struct FilmListView: View {
    
    @ObservedObject var filmListViewModel : FilmListViewModel   //gözlemlenen obje
    
    @State var aranacakFilm = ""
    
    init() {
        self.filmListViewModel = FilmListViewModel()
        
    }
    
    
    var body: some View {
        
        NavigationView{
            
            VStack{
                TextField("Search Film", text: $aranacakFilm, onEditingChanged: { _ in }) {
                    self.filmListViewModel.searchFilm(filmName: aranacakFilm)
                    
                }.padding().textFieldStyle(RoundedBorderTextFieldStyle()).background(Color.yellow)
                
                if aranacakFilm.isEmpty{
                    Image("movie")
                        .resizable()
                        .frame(height: 500)
                        .padding()
                }
            
            List(filmListViewModel.films, id: \.imdbID) { film in
                
                NavigationLink(destination: DetailsFilmView(imdbID:film.imdbID)) {
                    HStack{
                        SpecialImage(url: film.poster)
                            .frame(width:90, height: 130)
                        
                        VStack(alignment : .leading) {
                            Text(film.title)
                                .font(.title3)
                            
                            Text(film.year)
                        }
                    }
                }
              
                
            }.navigationTitle(Text("Movie Book"))
            }.background(Color.black)
        }


    }
}

#Preview {
    FilmListView()
}
