//
//  BookmarkListViewModel.swift
//  GoodChoiceProject
//
//  Created by 김이은 on 2022/01/08.
//

import Foundation
import RxSwift
import RxCocoa

enum BookmarkSortType {
    case dateAscending, dateDescending, rateAscending, rateDescending
}

final class BookmarkListViewModel {
    
    var bookmarks: BehaviorSubject<[Bookmark]> = BehaviorSubject(value: [])
    var sortType: BookmarkSortType = .dateAscending

    private let disposeBag = DisposeBag()
    
    func sortByDate(_ descendingOrder: Bool) {
        bookmarks.onNext([])
    }
    
    func sortByRate(_ descendingOrder: Bool) {
        bookmarks.onNext([])
    }
    
    init(_ bookmarks: [Bookmark]) {

        BookmarkManager.shared.bookmarks
            .map({
                switch self.sortType {
                case .dateAscending:
                    return $0.sorted { $0.date > $1.date }
                case .dateDescending:
                    return $0.sorted { $0.date < $1.date }
                case .rateAscending:
                    return $0.sorted { $0.rate < $1.rate }
                case .rateDescending:
                    return $0.sorted { $0.rate > $1.rate }
                }
            })
            .bind(to: self.bookmarks)
            .disposed(by: disposeBag)
    }
}


