//
//  HotelBookmark.swift
//  GoodChoiceProject
//
//  Created by 김이은 on 2022/01/08.
//

import Foundation

struct HotelBookmark: Bookmark {
    var type: PropertyType { .hotel }
    
    var id: Int = 0
    
    var title: String = ""
    
    var imageUrl: URL?
    
    var thumbnailImageUrl: URL?
    
    var rate: Float = 0
    
    var subject: String
    
    var price: Int
    
    var date: Date
}
