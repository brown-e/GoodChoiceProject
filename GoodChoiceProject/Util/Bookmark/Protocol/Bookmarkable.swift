//
//  Bookmarkable.swift
//  GoodChoiceProject
//
//  Created by 김이은 on 2022/01/08.
//

import Foundation

// Bookmark 에 저장할 수 있는 프로토콜을 구현한 ... 
protocol Bookmarkable {
    var bookmark: Bookmark { get }
    init?(_ bookmark: Bookmark)
}
