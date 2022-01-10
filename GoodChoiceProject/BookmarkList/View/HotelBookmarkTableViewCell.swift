//
//  HotelBookmarkTableViewCell.swift
//  GoodChoiceProject
//
//  Created by 김이은 on 2022/01/09.
//

import UIKit

extension HotelBookmarkTableViewCell {
    static var Key: String = "HotelBookmarkTableViewCell"
}

final class HotelBookmarkTableViewCell: UITableViewCell {

    @IBOutlet var imgView: UIImageView!
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var lblRate: UILabel!
    @IBOutlet var lblRateDate: UILabel!
    @IBOutlet var btnBookmark: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
