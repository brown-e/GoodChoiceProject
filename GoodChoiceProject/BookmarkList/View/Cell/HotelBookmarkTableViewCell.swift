//
//  HotelBookmarkTableViewCell.swift
//  GoodChoiceProject
//
//  Created by 김이은 on 2022/01/09.
//

import UIKit
import RxSwift

extension HotelBookmarkTableViewCell {
    static var Key: String = "HotelBookmarkTableViewCell"
}

final class HotelBookmarkTableViewCell: UITableViewCell {

    @IBOutlet var imgView: UIImageView!
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var lblRate: UILabel!
    @IBOutlet var lblRateDate: UILabel!
    @IBOutlet var btnBookmark: UIButton!
    
    var disposeBag = DisposeBag()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        imgView.layer.borderColor = UIColor.lightGray.cgColor
        imgView.layer.borderWidth = 1
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        disposeBag = DisposeBag()
    }
}
