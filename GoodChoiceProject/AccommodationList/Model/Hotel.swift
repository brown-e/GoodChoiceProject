//
//  Hotel.swift
//  GoodChoiceProject
//
//  Created by 김이은 on 2022/01/08.
//

import Foundation

struct Hotel: Accommodation {
    var id: Int
    
    var title: String = ""
    
    var thumbnailImageUrl: URL?
    
    var rate: Float = 0
    
    var imageUrl: URL?
    
    var subject: String
    
    var price: Int
}
