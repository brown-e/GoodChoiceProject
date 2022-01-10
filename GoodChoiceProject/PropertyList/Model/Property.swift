//
//  Property.swift
//  GoodChoiceProject
//
//  Created by 김이은 on 2022/01/08.
//

import Foundation

enum PropertyType: Int {
    case hotel, motel
}

protocol Property {
    var id: Int { get set }
    
    var title: String { get set }
    
    var thumbnailImageUrl: URL? { get set }
    
    var rate: Float { get set }
    
    var detail: PropertyDetail? { get set }
}

struct PropertyDetail {
    var imageUrl: URL?
    
    var subject: String
    
    var price: Int
}
