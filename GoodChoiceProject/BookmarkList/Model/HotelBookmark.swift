//
//  HotelBookmark.swift
//  GoodChoiceProject
//
//  Created by 김이은 on 2022/01/08.
//

import Foundation

struct HotelBookmark: Bookmark {
    var id: Int = 0
    
    var imageUrlString: String?
    
    var title: String = ""
    
    var rate: Float = 0
    
    var date: Date
}
