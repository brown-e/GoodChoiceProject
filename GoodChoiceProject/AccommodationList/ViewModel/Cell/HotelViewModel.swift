//
//  HotelViewModel.swift
//  GoodChoiceProject
//
//  Created by 김이은 on 2022/01/12.
//

import Foundation
import RxSwift
import RxCocoa
import Kingfisher

struct HotelViewModel: AccomodationViewModel {
    var accommodation: Accommodation
    var isBookmarked: Bool
    
    var bookmarkButtonTap: PublishRelay<Void> = PublishRelay()
    
    private var disposeBag = DisposeBag()
    
    init(accommodation: Accommodation, isBookmarked: Bool) {
        self.accommodation = accommodation
        self.isBookmarked = isBookmarked
        
        bookmarkButtonTap.bind { [self] _ in
            if self.isBookmarked {
                try? BookmarkManager.shared.delete(accommodation.id)
            } else {
                try? BookmarkManager.shared.save(accommodation.bookmark)
            }
        }.disposed(by: disposeBag)
    }
    
    func viewBind(_ cell: HotelPropertyListTableViewCell) {
        cell.lblTitle.text = accommodation.title
        cell.lblRate.text = "\(accommodation.rate)"
        cell.btnBookmark.isSelected = isBookmarked
        cell.imgView.image = nil
        if let thumbnailImageUrl = accommodation.thumbnailImageUrl {
            cell.imgView.kf.setImage(with: thumbnailImageUrl)
        }
        
        cell.btnBookmark.rx.tap
            .bind(to: bookmarkButtonTap)
            .disposed(by: cell.disposeBag)
    }
}
