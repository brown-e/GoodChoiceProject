//
//  HotelDetailViewController.swift
//  GoodChoiceProject
//
//  Created by 김이은 on 2022/01/09.
//

import UIKit
import Kingfisher
import RxSwift
import RxCocoa

final class HotelDetailViewController: UIViewController {

    // View
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var lblDescription: UILabel!
    @IBOutlet var lblPrice: UILabel!
    @IBOutlet var lblRate: UILabel!
    @IBOutlet var btnBookmark: UIButton!
    
    // View Model
    var hotelDetailViewModel: HotelDetailViewModel
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        initializeView()
        bind()
    }
    
    init(_ hotel: Hotel) {
        hotelDetailViewModel = HotelDetailViewModel(hotel)
        
        super.init(nibName: nil, bundle: nil)
    }
    
    private func initializeView() {
        
        lblPrice.text = hotelDetailViewModel.priceText
        lblDescription.text = hotelDetailViewModel.descriptionText
        lblRate.text = hotelDetailViewModel.rateString
        lblTitle.text = hotelDetailViewModel.title
        
        if let imageUrl = hotelDetailViewModel.imageUrl {
            imageView.kf.setImage(with: imageUrl)
        }
    }
    
    private func bind() {
        btnBookmark.rx.tap
            .bind(to: hotelDetailViewModel.bookmarkButtonTap)
            .disposed(by: disposeBag)
        
        hotelDetailViewModel.isBookmarked
            .bind(to: btnBookmark.rx.isSelected)
            .disposed(by: disposeBag)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

struct HotelDetailViewModel {
    
    var bookmarkButtonTap: PublishRelay<Void> = PublishRelay()
    var isBookmarked: BehaviorRelay<Bool> = BehaviorRelay(value: false)
    
    private let disposeBag = DisposeBag()
    private let hotel: Hotel
    
    var imageUrl: URL? {
        return hotel.imageUrl
    }
    
    var title: String {
        return hotel.title
    }
    
    var rateString: String {
        return "\(hotel.rate)"
    }
    
    var descriptionText: String {
        return hotel.subject
    }
    
    var priceText: String {
        return "\(hotel.price)"
    }
    
    init(_ hotel: Hotel) {
        self.hotel = hotel
        
        BookmarkManager.shared.bookmarks
            .map { $0.contains { $0.id == hotel.id } }
            .bind(to: isBookmarked)
            .disposed(by: disposeBag)
        
        bookmarkButtonTap.bind { [self] _ in
            if self.isBookmarked.value {
                try? BookmarkManager.shared.delete(hotel.id)
            } else {
                try? BookmarkManager.shared.save(hotel.bookmark)
            }
        }.disposed(by: disposeBag)
    }
}
