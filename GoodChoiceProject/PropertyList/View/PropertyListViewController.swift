//
//  PropertyListViewController.swift
//  GoodChoiceProject
//
//  Created by 김이은 on 2022/01/08.
//

import UIKit
import RxSwift
import RxCocoa
import Alamofire
import Kingfisher

final class PropertyListViewController: UIViewController {

    @IBOutlet var tableView: UITableView!
    
    private var viewModel: PropertyListViewModel = PropertyListViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
//        self.photoCollectionView.rx.didScroll
//          .withLatestFrom(self.photoCollectionView.rx.contentOffset)
//          .map { [weak self] in
//            Reactor.Action.pagination(
//              contentHeight: self?.photoCollectionView.contentSize.height ?? 0,
//              contentOffsetY: $0.y,
//              scrollViewHeight: UIScreen.main.bounds.height
//            )
//          }
//          .bind(to: reactor.action)
//          .disposed(by: disposeBag)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let hotel = Hotel(id: 0, title: "hello world", thumbnailImageUrl: nil, rate: 5.0, detail: nil)
        let detail = HotelDetailViewController(hotel)
        
        present(detail, animated: true, completion: nil)
    }
}

extension Hotel {
    func bind(_ cell: PropertyListTableViewCell) {
        cell.lblTitle.text = title
        cell.lblRate.text = "\(rate)"
        
        cell.imgView.image = nil
        if let thumbnailImageUrl = thumbnailImageUrl {
            cell.imgView.kf.setImage(with: thumbnailImageUrl)
        }
    }
}
