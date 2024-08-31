//
//  DetailsFilmViewModel.swift
//  MovieBook
//
//  Created by Ahmet Karaman on 22.08.2024.
//

import Foundation


class DetailsFilmViewModel : ObservableObject {
    
    @Published var detailsFilm : FilmDetailsViewModel?
    
    let downloaderClient = DownloaderClient()
    
    func detailsOfFilm (imdbID : String){ //filmdetayıAl
        
        downloaderClient.detailsFilmDownload(imdbID: imdbID) { (result) in
                switch result {
                case .failure(let error):
                    print(error)
                case .success(let detailsOfFilms):
                    DispatchQueue.main.async{
                        self.detailsFilm = FilmDetailsViewModel(details: detailsOfFilms)
                    }
                }
            }
        }
    }
    



struct FilmDetailsViewModel {
   
    let details : DetailsOfFilms
    
    var title : String {
        details.title
    }
    
    var year : String {
        details.year
    }
    
    var poster : String {
        details.poster
    }
    
    var imdbID : String {
        details.imdbID
    }
    
    var writer : String {
        details.writer
    }
    
    var awards : String{
        details.awards
    }
    
    var director : String {
        details.director
    }
    
    var actors : String {
        details.actors
    }
    
    var genre : String {
        details.genre
    }
    
    var plot : String {
        details.plot
    }
    var runTime : String {
        details.runTime
    }
    var language : String {
        details.language
    }
    
    var imdbRating : String {
        details.imdbRating
    }
}
