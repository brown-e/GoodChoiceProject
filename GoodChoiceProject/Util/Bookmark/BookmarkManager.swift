//
//  BookmarkManager.swift
//  GoodChoiceProject
//
//  Created by 김이은 on 2022/01/08.
//

import Foundation
import RxSwift
import RxCocoa
//import RealmSwift

final class BookmarkManager {
    static var shared: BookmarkManager = BookmarkManager()
    
//    let realm = try! Realm()
    var bookmarks: PublishSubject<[Bookmark]> = PublishSubject()
    
    private init() {
        
    }
    
//    func delete(_ bookmark: Bookmark) throws {
//        guard let bookmark = bookmark as? Persistable else { return }
//
//        try realm.write {
//            realm.add(bookmark.realmObject)
//        }
//    }
//
//    func save(_ bookmark: Bookmark) throws {
//        guard let bookmark = bookmark as? Persistable else { return }
//
//        let realm = try! Realm()
//
//        try! realm.write {
//            realm.add(bookmark.realmObject)
//        }
//    }
}

//extension HotelBookmark: Persistable {
//    typealias ManagedObject = RealmBookmark
//
//    init(managedObject: RealmBookmark) {
//        self.id = managedObject.id
//        self.rate = managedObject.rate
//        self.imageUrlString = managedObject.imageUrlString
//        self.date = managedObject.date
//    }
//
//    func managedObject() -> RealmBookmark {
//        let bookmark = RealmBookmark()
//        return bookmark
//    }
//}

//// realm에 저장되는 클래스
//class RealmBookmark: Object {
//    @Persisted var propertyType: Int
//
//    @Persisted var id: Int = 0
//
//    @Persisted var imageUrlString: String?
//
//    @Persisted var title: String = ""
//
//    @Persisted var rate: Float = 0
//
//    @Persisted var date: Date
//}
//
//
//
//public protocol Persistable {
//
//    associatedtype ManagedObject: RealmSwift.Object
//
//    // RealmObject -> Struct 변환
//    init(managedObject: ManagedObject)
//
//    // Struct -> RealmObject
//    func managedObject() -> ManagedObject
//}
