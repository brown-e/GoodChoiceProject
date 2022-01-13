//
//  HotelPropertyListTableViewCell.swift
//  GoodChoiceProject
//
//  Created by 김이은 on 2022/01/09.
//

import UIKit
import RxSwift

extension HotelPropertyListTableViewCell {
    static var Key: String = "HotelPropertyListTableViewCell"
}

final class HotelPropertyListTableViewCell: UITableViewCell {

    @IBOutlet var imgView: UIImageView!
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var lblRate: UILabel!
    @IBOutlet var btnBookmark: UIButton!
    
    var disposeBag = DisposeBag()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        imgView.layer.borderColor = UIColor(white: 0, alpha: 0.1).cgColor
        imgView.layer.cornerRadius = 5
        imgView.layer.borderWidth = 1
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        
        disposeBag = DisposeBag()
    }
}
