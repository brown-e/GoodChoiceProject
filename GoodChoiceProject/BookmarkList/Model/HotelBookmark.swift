//
//  HotelBookmark.swift
//  GoodChoiceProject
//
//  Created by 김이은 on 2022/01/08.
//

import Foundation

struct HotelBookmark: Bookmark {
    var type: PropertyType = .hotel
    
    var imageUrl: URL?
    
    var subject: String
    
    var price: Int
    
    var thumbnailImageUrl: URL?
    
    var id: Int = 0
    
    var title: String = ""
    
    var rate: Float = 0
    
    var date: Date
}
