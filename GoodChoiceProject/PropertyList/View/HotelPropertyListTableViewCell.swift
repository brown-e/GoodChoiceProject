//
//  HotelPropertyListTableViewCell.swift
//  GoodChoiceProject
//
//  Created by 김이은 on 2022/01/09.
//

import UIKit

extension HotelPropertyListTableViewCell {
    static var Key: String = "HotelPropertyListTableViewCell"
}

final class HotelPropertyListTableViewCell: UITableViewCell {

    @IBOutlet var imgView: UIImageView!
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var lblRate: UILabel!
    @IBOutlet var btnBookmark: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
