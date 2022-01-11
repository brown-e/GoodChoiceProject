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

    var obSortType: BehaviorRelay<BookmarkSortType> = BehaviorRelay(value: .dateAscending)
    
    private let disposeBag = DisposeBag()
    
    func sortByDate(_ descendingOrder: Bool) {
        obSortType.accept(descendingOrder ? .dateDescending : .dateAscending)
    }
    
    func sortByRate(_ descendingOrder: Bool) {
        obSortType.accept(descendingOrder ? .rateDescending : .rateAscending)
    }
    
    init(_ bookmarks: [Bookmark]) {

        BookmarkManager.shared.bookmarks
            .map({
                switch self.obSortType.value {
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
        
        obSortType.bind { type in
            var bookmarks = (try? self.bookmarks.value()) ?? []
            switch type {
            case .dateAscending:
                bookmarks.sort { $0.date > $1.date }
            case .dateDescending:
                bookmarks.sort { $0.date < $1.date }
            case .rateAscending:
                bookmarks.sort { $0.rate < $1.rate }
            case .rateDescending:
                bookmarks.sort { $0.rate > $1.rate }
            }

            self.bookmarks.onNext(bookmarks)
        }.disposed(by: disposeBag)
    }
}


