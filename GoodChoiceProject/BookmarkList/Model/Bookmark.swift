//
//  Bookmark.swift
//  GoodChoiceProject
//
//  Created by 김이은 on 2022/01/08.
//

import Foundation

struct Bookmark {
    var type: AccommodationType
    
    var id: Int
    
    var title: String
    
    var thumbnailImageUrl: URL?
    
    var rate: Float
    
    var imageUrl: URL?
    
    var subject: String
    
    var price: Int
    
    var date: Date
}
