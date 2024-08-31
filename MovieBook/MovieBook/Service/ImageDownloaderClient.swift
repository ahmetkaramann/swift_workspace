//
//  ImageDownloaderClient.swift
//  MovieBook
//
//  Created by Ahmet Karaman on 21.08.2024.
//

import Foundation


class ImageDownloaderClient : ObservableObject {       //indirildiğini diğer tüm görünümlere göstereceğimizden dolayı bu classın observable olması gerekiyor
    
    @Published var downloadedImage : Data? //indirilen görsel  bu değişkene atancak, ve gözlenen değişken de olucak(published)
    
    func downloadImage(url : String){
        
        guard let imageUrl = URL(string: url) else{
            return
        }
        
        URLSession.shared.dataTask(with: imageUrl) { data, response, error in
            guard let data = data, error == nil else{
                return
            }
            
            DispatchQueue.main.async{   //main tradde olcağından asenkron olarak yapılması lazım
                self.downloadedImage = data //urlsession çağırıldığında artık downloadedImage kaydedeilcek, ve bizim view umuza haber verilcek
            }
        }.resume()
        
    }
}
