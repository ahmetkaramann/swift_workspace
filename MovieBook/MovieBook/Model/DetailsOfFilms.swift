//
//  DetailsOfFilms.swift
//  MovieBook
//
//  Created by Ahmet Karaman on 21.08.2024.
//

import Foundation

struct DetailsOfFilms : Codable {
    let title : String
    let year : String
    let genre : String
    let director : String
    let writer : String
    let actors : String
    let plot : String
    let awards : String
    let poster : String
    let metascore : String
    let imdbRating : String
    let imdbID : String
    let runTime : String
    let language :String
    
    
    private enum CodingKeys: String, CodingKey{
        case title = "Title"
        case year = "Year"
        case genre = "Genre"
        case director = "Director"
        case writer = "Writer"
        case actors = "Actors"
        case plot = "Plot"
        case awards = "Awards"
        case poster = "Poster"
        case metascore = "Metascore"
        case imdbRating = "imdbRating"
        case imdbID = "imdbID"
        case runTime = "Runtime"
        case language = "Language"
       
    }
}

// bunun ardından yeni bir service açmamız lazım çünkü bundan önceki service lerde filmleri indir vardı şimdi tek bir filmi indireceğimiz service yazcaz
