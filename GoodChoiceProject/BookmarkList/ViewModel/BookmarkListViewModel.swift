//
//  BookmarkListViewModel.swift
//  GoodChoiceProject
//
//  Created by 김이은 on 2022/01/08.
//

import Foundation
import RxSwift
import RxCocoa

final class BookmarkListViewModel {
    var bookmarks: PublishSubject<[Bookmark]> = PublishSubject()
    
    func sortByDate(_ descendingOrder: Bool) {

    }
    
    func sortByRate(_ descendingOrder: Bool) {
        
    }
    
    
}
