//
//  BookmarkManager.swift
//  GoodChoiceProject
//
//  Created by 김이은 on 2022/01/08.
//

import Foundation
import RxSwift
import RxCocoa
import RealmSwift

final class BookmarkManager {
    static var shared: BookmarkManager = BookmarkManager()
    
    var bookmarks: BehaviorSubject<[Bookmark]>
    
    var realm = try! Realm(configuration: .defaultConfiguration)
    
    let notificationToken: NotificationToken
    private var tempBookmark: [Bookmark] = []
    
    private init() {
        
        let bookmarksObjects = realm.objects(BookmarkObject.self)
        
        bookmarks = BehaviorSubject(value: [])
        
        notificationToken = bookmarksObjects.observe { [bookmarks] (changes) in
            switch changes {
            case .initial:
                bookmarks.onNext(bookmarksObjects.compactMap({ $0.bookmark }))
            case .update:
                bookmarks.onNext(bookmarksObjects.compactMap({ $0.bookmark }))
            case .error(let error):
                fatalError("\(error)")
            }
        }
    }
    
    deinit {
        notificationToken.invalidate()
    }
    
    func delete(_ id: Int) throws {
        let bookmarks = realm.objects(BookmarkObject.self)
        guard let bookmark = bookmarks.filter({ $0.id == id}).first else { return }
        
        try realm.write {
            realm.delete(bookmark)
        }
    }

    func save(_ bookmark: Bookmark) throws {
        try realm.write {
            realm.add(BookmarkObject(bookmark: bookmark))
        }
    }
}

class BookmarkObject: Object {
    @Persisted(primaryKey: true) var id: Int

    @Persisted var type: Int = 0

    @Persisted var title: String = ""
    
    @Persisted var thumbnailImageUrlString: String?
    
    @Persisted var rate: Float = 0

    @Persisted var imageUrlString: String?
    
    @Persisted var subject: String = ""
    
    @Persisted var price: Int = 0
    
    @Persisted var date: Date?
    
    override init() {
        super.init()
        self.id = 0
    }
    
    init(id: Int) {
        super.init()
        self.id = id
    }
    
    init(bookmark: Bookmark) {
        super.init()
        
        self.id = bookmark.id
        self.type = bookmark.type.rawValue
        self.thumbnailImageUrlString = bookmark.thumbnailImageUrl?.absoluteString
        self.rate = bookmark.rate
        self.imageUrlString = bookmark.imageUrl?.absoluteString
        self.subject = bookmark.subject
        self.price = bookmark.price
        self.date = bookmark.date
        self.title = bookmark.title
    }
}

extension BookmarkObject {
    fileprivate var bookmark: Bookmark? {
        guard let propertyType = PropertyType(rawValue: type) else { return nil }
        
        switch propertyType {
        case .hotel:
            return HotelBookmark(type: .hotel,
                                 imageUrl: URL(string: imageUrlString),
                                 subject: subject,
                                 price: price,
                                 thumbnailImageUrl: URL(string: thumbnailImageUrlString),
                                 id: id,
                                 title: title,
                                 rate: rate,
                                 date: date ?? Date())
        default: return nil
        }
    }
}
