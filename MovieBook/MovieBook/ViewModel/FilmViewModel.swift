//
//  FilmViewModel.swift
//  MovieBook
//
//  Created by Ahmet Karaman on 20.08.2024.
//

import Foundation


class FilmListViewModel : ObservableObject {    //ObservableObject, biz arrtık yayın yapar hale geliyoruz
    
    //internetten çektiğimiz verileri bu değişken içinde tutmak ve bu değişkeni puplished etmek
    @Published var films = [FilmViewModel]() //yayına sokuyorum, ben bu filmler içinde herhangi bir değişiklik yaptığımda hangi viewdan buna üye olduysam hangi viewdan bunu gözlemliyorsam bunu orda görebilcem hangi değişkeni gözlemlettirmek istiyorsak @puplished diyoruz
    let downloaderClient = DownloaderClient()
    
    func searchFilm (filmName : String) {
        downloaderClient.downloadFilms(search: filmName) { (result) in
            switch result{
                case .failure(let error):
                    print(error)
                case .success(let filmDizisi):
                DispatchQueue.main.async{   // kod bloğunu ana iş parçacığında asenkron olarak çalıştırır.
                    self.films = filmDizisi.map(FilmViewModel.init) // map fonksiyonu her bir Film nesnesini alacak ve bu nesneyi kullanarak yeni bir FilmViewModel nesnesi oluşturacak. Yani filmDizisi adlı bir Film nesneleri dizisini, FilmViewModel nesneleri dizisine dönüştürür
                }
            }
            
        }
    }
}


struct FilmViewModel {
    
    let film : Film
    
    var title : String{
        film.title
    }
    
    var poster : String{
        film.poster
    }
    
    var imdbID : String {
        film.imdbID
    }
    
    var year : String {
        film.year
    }
}
