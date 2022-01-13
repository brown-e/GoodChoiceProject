//
//  Hotel+Bookmarkable.swift
//  GoodChoiceProject
//
//  Created by 김이은 on 2022/01/11.
//

import Foundation

extension Hotel: Bookmarkable {
    var bookmark: Bookmark {
        return Bookmark(type: .hotel,
                        id: id,
                        title: title,
                        thumbnailImageUrl: thumbnailImageUrl,
                        rate: rate,
                        imageUrl: imageUrl,
                        subject: subject,
                        price: price,
                        date: Date())
    }
    
    init(_ bookmark: Bookmark) {
        id = bookmark.id
        imageUrl = bookmark.imageUrl
        subject = bookmark.subject
        price = bookmark.price
        thumbnailImageUrl = bookmark.thumbnailImageUrl
        title = bookmark.title
        rate = bookmark.rate
    }
}
