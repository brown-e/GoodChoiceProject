//
//  HotelDetailViewController.swift
//  GoodChoiceProject
//
//  Created by 김이은 on 2022/01/09.
//

import UIKit
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
    
        hotelDetailViewModel.bindView(self)
        bind()
    }
    
    init(_ hotel: Hotel) {
        hotelDetailViewModel = HotelDetailViewModel(hotel)
        
        super.init(nibName: nil, bundle: nil)
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
