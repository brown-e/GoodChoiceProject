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
    
    var properties: BehaviorRelay<[PropertyViewModel]> = BehaviorRelay(value: [])
    var isLoading: BehaviorRelay<Bool> = BehaviorRelay(value: false)
    
    var totalCount: Int?
    var currentPage: Int?
    
    private let disposeBag = DisposeBag()
    
    init() {
        bind()
    }
    
    private func bind() {
        BookmarkManager.shared.bookmarks.bind { [unowned self] bookmarks in
            self.properties.accept(self.properties.value.map({ property in
                let bookmarked = bookmarks.contains(where: { $0.id == property.property.id })
                return PropertyViewModel(property: property.property, isBookmarked: bookmarked)
            }))
        }.disposed(by: disposeBag)
    }
    
    func fetchData(_ page: Int) {
        guard isLoading.value == false else { return }
        
        if let totalCount = totalCount, totalCount/20 > page+1 { return }
        
        isLoading.accept(true)
        AF.request(URL(string: "https://www.gccompany.co.kr/App/json/\(page+1).json")!)
            .responseDecodable(of: PropertyListAPIReturn.self) { [weak self] response in
                self?.isLoading.accept(false)
                
                guard let list = response.value?.data.product else { return }
                self?.totalCount = response.value?.data.totalCount
                self?.currentPage = page
                
                let bookmarks = (try? BookmarkManager.shared.bookmarks.value()) ?? []
                self?.properties.accept((self?.properties.value ?? []) + list
                                            .map { property in
                    let bookmarked = bookmarks.contains(where: { bookmark in
                        bookmark.id == property.id
                    })
                    return PropertyViewModel(property: Hotel(property),
                                             isBookmarked: bookmarked) })
            }
    }
}

// API 리턴 스펙 정의
fileprivate struct PropertyListAPIReturn: Decodable {
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
    fileprivate init(_ apiReturn: PropertyListAPIReturn.Property) {
        id = apiReturn.id
        title = apiReturn.name
        rate = apiReturn.rate
        thumbnailImageUrl = URL(string: apiReturn.thumbnail)
        imageUrl = URL(string: apiReturn.description.imagePath)
        subject = apiReturn.description.subject
        price = apiReturn.description.price
    }
}
