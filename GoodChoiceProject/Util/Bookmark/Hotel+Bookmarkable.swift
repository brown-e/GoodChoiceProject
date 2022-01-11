//
//  Hotel+Bookmarkable.swift
//  GoodChoiceProject
//
//  Created by 김이은 on 2022/01/11.
//

import Foundation

extension Hotel: Bookmarkable {
    var bookmark: Bookmark {
        return HotelBookmark(imageUrl: imageUrl,
                             subject: subject,
                             price: price,
                             thumbnailImageUrl: thumbnailImageUrl,
                             id: id,
                             title: title,
                             rate: rate,
                             date: Date())
    }
    
    init?(_ bookmark: Bookmark) {
        guard let bookmark = bookmark as? HotelBookmark else { return nil }
        
        imageUrl = bookmark.imageUrl
        subject = bookmark.subject
        price = bookmark.price
        thumbnailImageUrl = bookmark.thumbnailImageUrl
        id = bookmark.id
        title = bookmark.title
        rate = bookmark.rate
    }
}
