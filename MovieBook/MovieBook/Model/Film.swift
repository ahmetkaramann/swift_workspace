//
//  Film.swift
//  MovieBook
//
//  Created by Ahmet Karaman on 19.08.2024.
//

import Foundation

struct Film: Codable {
    let title : String
    let year : String
    let imdbID : String
    let type : String
    let poster : String
    
    
    private enum CodingKeys : String, CodingKey{
        case title = "Title"
        case year = "Year"
        case imdbID = "imdbID"
        case type = "Type"
        case poster = "Poster"
        
    }
}

struct GetFilm: Codable {
    let films : [Film]

    private enum CodingKeys: String, CodingKey {
        case films = "Search"   // bu film listesi genellikle JSON'da bir anahtarın (bu durumda "Search") altında bulunur.
    }
}




