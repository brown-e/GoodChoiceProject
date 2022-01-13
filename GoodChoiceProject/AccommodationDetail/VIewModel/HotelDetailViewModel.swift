//
//  HotelDetailViewModel.swift
//  GoodChoiceProject
//
//  Created by 김이은 on 2022/01/13.
//

import Foundation
import Kingfisher
import RxSwift
import RxCocoa

struct HotelDetailViewModel {
    var bookmarkButtonTap: PublishRelay<Void> = PublishRelay()
    var isBookmarked: BehaviorRelay<Bool> = BehaviorRelay(value: false)
    
    private let disposeBag = DisposeBag()
    private let hotel: Hotel
    
    func bindView(_ view: HotelDetailViewController) {
        view.lblPrice.text = "\(hotel.price)"
        view.lblDescription.text = hotel.subject
        view.lblRate.text = "\(hotel.rate)"
        view.lblTitle.text = hotel.title
        
        if let imageUrl = hotel.imageUrl {
            view.imageView.kf.setImage(with: imageUrl)
        }
    }
    
    init(_ hotel: Hotel) {
        self.hotel = hotel
        
        BookmarkManager.shared.bookmarks
            .map { $0.contains { $0.id == hotel.id } }
            .bind(to: isBookmarked)
            .disposed(by: disposeBag)
        
        bookmarkButtonTap.bind { [self] _ in
            if self.isBookmarked.value {
                try? BookmarkManager.shared.delete(hotel.id)
            } else {
                try? BookmarkManager.shared.save(hotel.bookmark)
            }
        }.disposed(by: disposeBag)
    }
}
