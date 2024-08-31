// DetailsFilmView.swift
import SwiftUI

struct DetailsFilmView: View {
    
    let imdbID : String
    @ObservedObject var detailsFilmViewModel = DetailsFilmViewModel()
    
    var body: some View {
        VStack  {
            
            
                //poster
                SpecialImage(url: detailsFilmViewModel.detailsFilm?.poster ?? "")
                    .frame(width:200, height: 200)
            
            
            //title
            Text(detailsFilmViewModel.detailsFilm?.title ?? "title").padding().font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/).bold().foregroundColor(.yellow)
            
            ScrollView{
                VStack(alignment:.leading){
                    //plot
                    ScrollView{
                        Text(detailsFilmViewModel.detailsFilm?.plot ?? "plot").foregroundColor(.yellow)
                            .padding()
                    }.frame(height: 100)
                    
                    //year
                    Text("Year: \(detailsFilmViewModel.detailsFilm?.year ?? "year")")
                        .padding().foregroundColor(.yellow)
                    
                    //imdb
                    Text("imdb: \(detailsFilmViewModel.detailsFilm?.imdbRating ?? "imdb")")
                        .padding().foregroundColor(.yellow)
                    
                    //runtime
                    Text("Runtime: \(detailsFilmViewModel.detailsFilm?.runTime ?? "runtime")")
                        .padding().foregroundColor(.yellow)
                    
                    //language
                    Text("Language: \(detailsFilmViewModel.detailsFilm?.language ?? "language")")
                        .padding().foregroundColor(.yellow)
                    
                    //director
                    Text("Director: \(detailsFilmViewModel.detailsFilm?.director ?? "director")")
                        .padding().foregroundColor(.yellow)
                    
                    //actors
                    Text("Actors: \(detailsFilmViewModel.detailsFilm?.actors ?? "actors")")
                        .padding().foregroundColor(.yellow)
                    
                    //writer
                    Text("Writer: \(detailsFilmViewModel.detailsFilm?.writer ?? "writer")")
                        .padding().foregroundColor(.yellow)
                    
                    //genre
                    Text("Genre: \(detailsFilmViewModel.detailsFilm?.genre ?? "genre")")
                        .padding().foregroundColor(.yellow)
                    
                    //awards
                    Text("Awards:\(detailsFilmViewModel.detailsFilm?.awards ?? "awards")")
                        .padding().foregroundColor(.yellow)
                }
            }
            
        }.onAppear {
            self.detailsFilmViewModel.detailsOfFilm(imdbID: imdbID)
        }.background(Color.black)
    }
}

#Preview {
    DetailsFilmView(imdbID: "test")
}

