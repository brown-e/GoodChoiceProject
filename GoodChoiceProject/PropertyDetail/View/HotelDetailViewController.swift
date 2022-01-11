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
    @IBOutlet var btnToggle: UIButton!
    
    // model
    private let hotel: Hotel
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        initializeView()
        bind()
    }
    
    init(_ hotel: Hotel) {
        self.hotel = hotel
        super.init(nibName: nil, bundle: nil)
    }
    
    private func initializeView() {
        lblTitle.text = hotel.title
        lblPrice.text = "\(hotel.price)"
        lblDescription.text = hotel.subject
        lblRate.text = "\(hotel.rate)"
        
        if let imageUrl = hotel.imageUrl {
            imageView.kf.setImage(with: imageUrl)
        }
    }
    
    private func bind() {
        btnToggle.rx.tap.subscribe { [hotel] event in
            if self.btnToggle.isSelected {
                try? BookmarkManager.shared.delete(hotel.id)
            } else {
                try? BookmarkManager.shared.save(hotel.bookmark)
            }
        }.disposed(by: disposeBag)
        
        BookmarkManager.shared.bookmarks.map { $0.filter { $0.id == self.hotel.id } }.subscribe { event in
            guard let element = event.element else { return }
            self.btnToggle.isSelected = !element.isEmpty
        }.disposed(by: disposeBag)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
