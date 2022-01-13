//
//  AccommodationListViewModel.swift
//  GoodChoiceProject
//
//  Created by 김이은 on 2022/01/08.
//

import Foundation
import RxSwift
import RxCocoa
import Alamofire

final class AccommodationListViewModel {
    
    var accommodationViewModels: BehaviorRelay<[AccomodationViewModel]> = BehaviorRelay(value: [])
    var isLoading: BehaviorRelay<Bool> = BehaviorRelay(value: false)
    var refreshControlCalled: PublishRelay<Void> = PublishRelay()
    
    var totalCount: Int?
    var currentPage: Int? {
        let count = accommodationViewModels.value.count
        if count == 0 { return nil }
        return count / 20
    }
    
    private let disposeBag = DisposeBag()
    
    init() {
        bind()
    }
    
    private func bind() {
        BookmarkManager.shared.bookmarks.bind { [unowned self] bookmarks in
            let oldList = self.accommodationViewModels.value
            self.accommodationViewModels.accept(oldList.compactMap({ property in
                let bookmarked = bookmarks.contains(where: { $0.id == property.accommodation.id })
                
                switch property {
                case let hotelViewModel as HotelViewModel:
                    return HotelViewModel(accommodation: hotelViewModel.accommodation,
                                          isBookmarked: bookmarked)
                default: return nil
                }
            }))
        }.disposed(by: disposeBag)
        
        refreshControlCalled.bind { [unowned self] _ in
            fetchData()
        }.disposed(by: disposeBag)
    }
    
    func fetchData(_ page: Int = 1) {
        guard isLoading.value == false else { return }
        
        var oldList = self.accommodationViewModels.value
        
        if page == 1 {
            totalCount = nil
            oldList = []
        }
        
        if let totalCount = totalCount, totalCount <= oldList.count {
            return
        }
        
        isLoading.accept(true)
        AF.request(URL(string: "https://www.gccompany.co.kr/App/json/\(page).json")!)
            .responseDecodable(of: PropertyListAPIReturn.self) { [weak self] response in
                self?.isLoading.accept(false)
                
                guard let newList = response.value?.data.product.compactMap({ $0.accommodation }) else { return }
                self?.totalCount = response.value?.data.totalCount
                
                let bookmarks = (try? BookmarkManager.shared.bookmarks.value()) ?? []
                let oldList = oldList
                self?.accommodationViewModels.accept(oldList + newList
                                                    .map { property in
                    let bookmarked = bookmarks.contains(where: { bookmark in
                        bookmark.id == property.id
                    })
                    
                    return HotelViewModel(accommodation: property,
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
        
        /*
         API 결과값이 Hotel 타입만 내려온다고 가정함
         */
        let accommodationType = AccommodationType.hotel
        
        switch accommodationType {
        case .hotel:
            return Hotel(id: id,
                         title: name,
                         thumbnailImageUrl: URL(string: thumbnail),
                         rate: rate,
                         imageUrl: URL(string: description.imagePath),
                         subject: description.subject,
                         price: description.price)
        default: return nil
        }
    }
}
