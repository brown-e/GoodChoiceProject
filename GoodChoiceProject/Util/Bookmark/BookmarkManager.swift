//
//  BookmarkManager.swift
//  GoodChoiceProject
//
//  Created by 김이은 on 2022/01/08.
//

import Foundation
import RxSwift
import RxCocoa

final class BookmarkManager {
    static var shared: BookmarkManager = BookmarkManager()
    
    var bookmarks: BehaviorSubject<[Bookmark]>
    
    private var tempBookmark: [Bookmark] = []
    
    private init() {
        
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentPath = paths[0]
        let dataPath = NSString(string: documentPath).appendingPathComponent("Bookmark")
        
        if !FileManager.default.fileExists(atPath: dataPath) {
            do {
                try FileManager.default.createDirectory(atPath: dataPath, withIntermediateDirectories: false, attributes: nil)
            } catch let error as NSError {
                print(error.localizedDescription);
            }
        }

        bookmarks = BehaviorSubject(value: [])
    }
    
    func delete(_ id: Int) throws {
        tempBookmark.removeAll { $0.id == id }
        bookmarks.onNext(tempBookmark)
    }

    func save(_ bookmark: Bookmark) throws {
        tempBookmark.append(bookmark)
        bookmarks.onNext(tempBookmark)
    }
}

struct BookmarkObject: Codable {
    var type: Int
    
    var id: Int
    
    var title: String
    
    var thumbnailImageUrlString: String?
    
    var rate: Float

    var imageUrlString: String?
    
    var subject: String
    
    var price: Int
}

extension Property {
    fileprivate static func generateFrom(_ bookmarkObject: BookmarkObject) -> Property? {
        guard let propertyType = PropertyType(rawValue: bookmarkObject.type) else { return nil }
        switch propertyType {
        case .hotel:
            return Hotel(id: bookmarkObject.id,
                         title: bookmarkObject.title,
                         thumbnailImageUrl: URL(string: bookmarkObject.thumbnailImageUrlString),
                         rate: bookmarkObject.rate,
                         imageUrl: URL(string: bookmarkObject.imageUrlString),
                         subject: bookmarkObject.subject,
                         price: bookmarkObject.price)
        default:
            return Hotel(id: bookmarkObject.id,
                         title: bookmarkObject.title,
                         thumbnailImageUrl: URL(string: bookmarkObject.thumbnailImageUrlString),
                         rate: bookmarkObject.rate,
                         imageUrl: URL(string: bookmarkObject.imageUrlString),
                         subject: bookmarkObject.subject,
                         price: bookmarkObject.price)
        }
    }
}
