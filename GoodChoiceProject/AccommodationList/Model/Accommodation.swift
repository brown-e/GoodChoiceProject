//
//  Accommodation.swift
//  GoodChoiceProject
//
//  Created by 김이은 on 2022/01/08.
//

import Foundation

enum AccommodationType: Int {
    case hotel, motel
}

protocol Accommodation: Bookmarkable {
    var id: Int { get set }
    
    var title: String { get set }
    
    var thumbnailImageUrl: URL? { get set }
    
    var rate: Float { get set }
    
    var imageUrl: URL? { get set }
    
    var subject: String { get set }
    
    var price: Int { get set }
}
