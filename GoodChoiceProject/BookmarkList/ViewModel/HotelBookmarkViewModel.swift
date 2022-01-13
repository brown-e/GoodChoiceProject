//
//  HotelBookmarkViewModel.swift
//  GoodChoiceProject
//
//  Created by 김이은 on 2022/01/12.
//

import Foundation
import RxSwift
import RxCocoa
import Kingfisher

struct HotelBookmarkViewModel: AccommodationBookmarkViewModel {
    var bookmark: Bookmark
    var bookmarkButtonTap: PublishRelay<Void> = PublishRelay()
    
    private var disposeBag = DisposeBag()
    
    init(bookmark: Bookmark) {
        self.bookmark = bookmark
        
        bookmarkButtonTap.bind {
            try? BookmarkManager.shared.delete(bookmark.id)
        }.disposed(by: disposeBag)
    }
    
    func viewBind(_ cell: HotelBookmarkTableViewCell) {
        cell.lblTitle.text = bookmark.title
        cell.lblRate.text = "\(bookmark.rate)"
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd hh:mm:ss"
        
        cell.lblRateDate.text = dateFormatter.string(from: bookmark.date)
        
        cell.imgView.image = nil
        if let thumbnailImageUrl = bookmark.thumbnailImageUrl {
            cell.imgView.kf.setImage(with: thumbnailImageUrl)
        }
    }
}
