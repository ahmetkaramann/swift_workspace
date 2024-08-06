//
//  PostClass.swift
//  SharedPhotosApp
//
//  Created by Ahmet Karaman on 6.08.2024.
//

import Foundation

class Post {
    
    var email :String
    var comment : String
    var imageUrl : String
    
    init(email: String, comment: String, imageUrl: String) {
        self.email = email
        self.comment = comment
        self.imageUrl = imageUrl
    }
}
