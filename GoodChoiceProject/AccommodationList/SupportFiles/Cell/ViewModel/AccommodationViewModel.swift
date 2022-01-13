//
//  AccommodationViewModel.swift
//  GoodChoiceProject
//
//  Created by 김이은 on 2022/01/12.
//

import Foundation

protocol AccomodationViewModel {
    var accommodation: Accommodation { get set }
    var isBookmarked: Bool { get set }
}
