//
//  Bookmark.swift
//  GoodChoiceProject
//
//  Created by 김이은 on 2022/01/08.
//

import Foundation

protocol Bookmark {
    var imageUrlString: String? { get set }
    
    var title: String { get set }
    
    var rate: Float { get set }
    
    var date: Date { get set }
}
