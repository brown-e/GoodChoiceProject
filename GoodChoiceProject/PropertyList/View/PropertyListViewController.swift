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
    // View
    @IBOutlet var tableView: UITableView!
    
    // View model
    private var viewModel: PropertyListViewModel = PropertyListViewModel()
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 테이블 뷰 초기화
        initializeTableView()
        
        // 뷰모델 바인딩
        bind()
        
        // 첫번째 페이지 API 호출
        viewModel.fetchData(viewModel.currentPage ?? 0)
    }
    
    private func bind() {
        viewModel.properties.bind(to: tableView.rx.items(cellIdentifier: HotelPropertyListTableViewCell.Key, cellType: HotelPropertyListTableViewCell.self)) { (row, property, cell) in
            switch property.property {
            case let hotel as Hotel:
                hotel.bind(cell)
            default: break
            }
            
            if let bookmark = property.property as? Bookmarkable {
                cell.btnBookmark.rx.tap.subscribe({ _ in
                    try? BookmarkManager.shared.save(bookmark.bookmark)
                }).disposed(by: cell.disposeBag)
            }
            
            cell.btnBookmark.isSelected = property.isBookmarked

        }.disposed(by: disposeBag)
    
        tableView.rx.willDisplayCell.observe(on: MainScheduler.instance).subscribe { event in
            guard let current = self.viewModel.currentPage else { return }
            let indexPath = event.element?.indexPath
            if indexPath?.row == self.tableView.numberOfRows(inSection: 0) - 1 {
                self.viewModel.fetchData(current + 1)
            }
        }.disposed(by: disposeBag)
        
        tableView.rx.modelSelected(PropertyViewModel.self).subscribe { property in
            switch property.element?.property {
            case let hotel as Hotel:
                let viewController = HotelDetailViewController(hotel)
                self.navigationController?.pushViewController(viewController, animated: true)
            default: break
            }
        }.disposed(by: disposeBag)
    }
    
    private func initializeTableView() {
        tableView.rowHeight = 100
        tableView.register(UINib(nibName: "HotelPropertyListTableViewCell", bundle: nil),
                           forCellReuseIdentifier: HotelPropertyListTableViewCell.Key)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
}

extension Hotel {
    func bind(_ cell: HotelPropertyListTableViewCell) {
        cell.lblTitle.text = title
        cell.lblRate.text = "\(rate)"
        
        cell.imgView.image = nil
        if let thumbnailImageUrl = thumbnailImageUrl {
            cell.imgView.kf.setImage(with: thumbnailImageUrl)
        }
    }
}
