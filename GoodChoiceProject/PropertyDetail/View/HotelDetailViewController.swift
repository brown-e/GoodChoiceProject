//
//  HotelDetailViewController.swift
//  GoodChoiceProject
//
//  Created by 김이은 on 2022/01/09.
//

import UIKit
import Kingfisher

final class HotelDetailViewController: UIViewController {

    @IBOutlet var imageView: UIImageView!
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var lblDescription: UILabel!
    @IBOutlet var lblPrice: UILabel!
    @IBOutlet var lblRate: UILabel!
    @IBOutlet var btnToggle: UIButton!
    
    private let hotel: Hotel
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        lblTitle.text = hotel.title
        lblPrice.text = "\(hotel.detail?.price ?? 0)"
        lblDescription.text = hotel.detail?.subject ?? ""
        lblRate.text = "\(hotel.rate)"
        
        if let imageUrl = hotel.detail?.imageUrl {
            imageView.kf.setImage(with: imageUrl)
        }
    }
    
    init(_ hotel: Hotel) {
        self.hotel = hotel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
