//
//  URL+Util.swift
//  GoodChoiceProject
//
//  Created by 김이은 on 2022/01/11.
//

import Foundation

extension URL {
    init?(string: String?) {
        guard let string = string else { return nil }
        
        self.init(string: string)
    }
}
