//
//  PropertyListViewModel.swift
//  GoodChoiceProject
//
//  Created by 김이은 on 2022/01/08.
//

import Foundation
import RxSwift
import RxCocoa
import Alamofire

final class PropertyListViewModel {
    var properties: BehaviorRelay<[Property]> = BehaviorRelay(value: [])
    
    var isLoading: BehaviorRelay<Bool> = BehaviorRelay(value: false)
    
    var totalCount: Int?
    var currentPage: Int?
    
    func fetchData(_ page: Int) {
        if let totalCount = totalCount, totalCount / 20 > page + 1 { return }
        guard isLoading.value == false else { return }
        
        isLoading.accept(true)
        AF.request(URL(string: "https://www.gccompany.co.kr/App/json/\(page+1).json")!).responseDecodable(of: PropertyListAPIReturn.self) { [weak self] response in
            self?.isLoading.accept(false)
            
            guard let list = response.value?.data.product else { return }
            self?.totalCount = response.value?.data.totalCount
            self?.currentPage = page
            self?.properties.accept((self?.properties.value ?? []) + list.map { Hotel($0) })
        }
    }
}

struct PropertyListAPIReturn: Decodable {
    
    struct Data: Decodable {
        var totalCount: Int
        var product: [Property]
    }
    
    struct Property: Decodable {
        struct Description: Decodable {
            var imagePath: String
            var subject: String
            var price: Int
        }
        
        var id: Int
        var name: String
        var thumbnail: String
        var rate: Float
        var description: Description
    }
    
    var msg: String
    var data: Data
}

extension Hotel {
    init(_ apiReturn: PropertyListAPIReturn.Property) {
        id = apiReturn.id
        title = apiReturn.name
        if let url = URL(string: apiReturn.thumbnail) {
            thumbnailImageUrl = url
        }
        rate = apiReturn.rate
        detail = PropertyDetail(imageUrl: URL(string: apiReturn.description.imagePath), subject: apiReturn.description.subject, price: apiReturn.description.price)
    }
}
