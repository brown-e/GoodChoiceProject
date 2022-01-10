//
//  PropertyListViewModel.swift
//  GoodChoiceProject
//
//  Created by 김이은 on 2022/01/08.
//

import Foundation
import RxSwift
import RxCocoa

final class PropertyListViewModel {
    var properties: PublishSubject<[Bookmark]> = PublishSubject()
}
