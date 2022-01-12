//
//  BookmarkListViewModel.swift
//  GoodChoiceProject
//
//  Created by 김이은 on 2022/01/08.
//

import Foundation
import RxSwift
import RxCocoa

enum BookmarkSortType: CaseIterable {
    case dateAscending, dateDescending, rateAscending, rateDescending
}

final class BookmarkListViewModel {
    
    var bookmarks: BehaviorRelay<[Bookmark]> = BehaviorRelay(value: [])
    
    var sortType: BehaviorRelay<BookmarkSortType> = BehaviorRelay(value: .dateAscending)
    
    private let disposeBag = DisposeBag()
    
    init() {
        bind()
    }
    
    private func bind() {
        // 저장된 북마크 bind
        BookmarkManager.shared.bookmarks
            .map({
                return $0.sorted(by: self.sortType.value.comparer)
            })
            .bind(to: self.bookmarks)
            .disposed(by: disposeBag)
        
        // 정렬 타입 bind
        sortType.bind { type in
            let bookmarks = self.bookmarks.value.sorted(by: type.comparer)
            self.bookmarks.accept(bookmarks)
        }.disposed(by: disposeBag)
    }
}

extension BookmarkSortType {
    
    // 정렬 리스트 노출 시 Title
    var actionTitle: String {
        switch self {
        case .dateAscending:    return "최근 등록 순 (오름차순)"
        case .dateDescending:   return "최근 등록 순 (내림차순)"
        case .rateAscending:    return "평점 순 (오름차순)"
        case .rateDescending:   return "평점 순 (내림차순)"
        }
    }
    
    
    // 각 타입 별 정렬 메소드 정의
    var comparer: (Bookmark, Bookmark) -> Bool {
        switch self {
        case .dateAscending:    return { $0.date > $1.date }
        case .dateDescending:   return { $0.date < $1.date }
        case .rateAscending:    return { $0.rate > $1.rate }
        case .rateDescending:   return { $0.rate < $1.rate }
        }
    }
}
