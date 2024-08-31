//
//  DownloaderClient.swift
//  MovieBook
//
//  Created by Ahmet Karaman on 19.08.2024.
//

import Foundation

class DownloaderClient {
    
    func downloadFilms(search :String, completion: @escaping (Result<[Film], DownloaderError>) -> Void) {
        guard let url = URL(string:
                                "http://www.omdbapi.com/?s=\(search)&apikey=a8a66c31") else {
            return completion(.failure(.incorrectUrl))
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in        //URLSession Swift'te ağ istekleri (network requests) yapmak için kullanılan bir sınıftır. Bu sınıf, HTTP ve HTTPS gibi protokoller üzerinden veri alıp göndermek için bir arayüz sağlar.
            
            // Veri var mı ve hata yok mu kontrolü
            guard let data = data, error == nil else {
                return completion(.failure(.noData))
            }

            
            //data : API'den gelen ham JSON verisidir.
            //JSONDecoder: Swift'in JSON ayrıştırıcısıdır. decode metodunu kullanarak JSON verisini belirli bir modele (GetFilm) dönüştürmek için kullanılır.
            guard let filmAnswer = try? JSONDecoder().decode(GetFilm.self, from: data) else {
                return completion(.failure(.dontProcess))
            }
            
            completion(.success(filmAnswer.films))  // Başarılı sonuç durumu
        }.resume() // Görevi başlat
    }
    
    
    //detailsVieW İÇİN
    func detailsFilmDownload(imdbID:String, completion: @escaping (Result<DetailsOfFilms, DownloaderError>) ->Void){
        
        guard let url = URL(string: "http://www.omdbapi.com/?i=\(imdbID)&apikey=a8a66c31") else {
            return completion(.failure(.incorrectUrl))
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
                guard let data = data, error == nil else {
                    return completion(.failure(.noData))
                }
            
            //yukardaki fonksiyondan farklı burası olcak
            guard let getFilmDetail = try? JSONDecoder().decode(DetailsOfFilms.self, from: data) else {
                return completion(.failure(.dontProcess))
            }
            
            completion(.success(getFilmDetail))
        }.resume()
    }
}


enum DownloaderError: Error {
    case incorrectUrl
    case noData
    case dontProcess
}

