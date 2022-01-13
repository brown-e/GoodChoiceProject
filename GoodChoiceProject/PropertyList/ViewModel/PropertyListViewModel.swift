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
    
    var propertyViewModels: BehaviorRelay<[AccomodationViewModel]> = BehaviorRelay(value: [])
    var isLoading: BehaviorRelay<Bool> = BehaviorRelay(value: false)
    
    var totalCount: Int?
    var currentPage: Int? {
        let count = propertyViewModels.value.count
        if count == 0 { return nil }
        return count / 20
    }
    
    private let disposeBag = DisposeBag()
    
    init() {
        bind()
    }
    
    private func bind() {
        BookmarkManager.shared.bookmarks.bind { [unowned self] bookmarks in
            self.propertyViewModels.accept(self.propertyViewModels.value.compactMap({ property in
                let bookmarked = bookmarks.contains(where: { $0.id == property.accommodation.id })
                
                switch property {
                case let hotelViewModel as HotelViewModel:
                    return HotelViewModel(accommodation: hotelViewModel.accommodation,
                                          isBookmarked: bookmarked)
                default: return nil
                }
            }))
        }.disposed(by: disposeBag)
    }
    
    func fetchData(_ page: Int) {
        guard isLoading.value == false else { return }
        
        if let totalCount = totalCount, totalCount <= self.propertyViewModels.value.count {
            return
        }
        
        isLoading.accept(true)
        print("requested" + "https://www.gccompany.co.kr/App/json/\(page).json")
        
        AF.request(URL(string: "https://www.gccompany.co.kr/App/json/\(page).json")!)
            .responseDecodable(of: PropertyListAPIReturn.self) { [weak self] response in
                self?.isLoading.accept(false)
                
                guard let list = response.value?.data.product else { return }
                self?.totalCount = response.value?.data.totalCount
                
                let bookmarks = (try? BookmarkManager.shared.bookmarks.value()) ?? []
                self?.propertyViewModels.accept((self?.propertyViewModels.value ?? []) + list
                                                    .map { property in
                    let bookmarked = bookmarks.contains(where: { bookmark in
                        bookmark.id == property.id
                    })
                    
                    return HotelViewModel(accommodation: property.accommodation!,
                                          isBookmarked: bookmarked)
                })
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

extension PropertyListAPIReturn.Property {
    var accommodation: Accommodation? {
        return Hotel(id: id,
                     title: name,
                     thumbnailImageUrl: URL(string: thumbnail),
                     rate: rate,
                     imageUrl: URL(string: description.imagePath),
                     subject: description.subject,
                     price: description.price)
    }
}
