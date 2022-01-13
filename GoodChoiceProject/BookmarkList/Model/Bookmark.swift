//
//  Bookmark.swift
//  GoodChoiceProject
//
//  Created by 김이은 on 2022/01/08.
//

import Foundation

protocol Bookmark {
    var type: PropertyType { get }
    
    var id: Int { get set }
    
    var title: String { get set }
    
    var thumbnailImageUrl: URL? { get set }
    
    var rate: Float { get set }
    
    var imageUrl: URL? { get set }
    
    var subject: String { get set }
    
    var price: Int { get set }
    
    var date: Date { get set }
}
