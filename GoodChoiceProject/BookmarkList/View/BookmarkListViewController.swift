//
//  BookmarkListViewController.swift
//  GoodChoiceProject
//
//  Created by 김이은 on 2022/01/08.
//

import UIKit
import RxSwift
import RxCocoa
import Kingfisher

final class BookmarkListViewController: UIViewController {
    
    // View
    @IBOutlet var tableView: UITableView!

    // ViewModel
    private var viewModel: BookmarkListViewModel = BookmarkListViewModel()
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initializeTableView()
        bind()
    }
    
    private func bind() {
        
        // 정렬 버튼 bind
        self.navigationItem.rightBarButtonItem?.rx.tap.bind { [unowned self] in
            let alertController = UIAlertController(title: "정렬", message: nil, preferredStyle: .actionSheet)
            
            for sortType in BookmarkSortType.allCases {
                var title = sortType.actionTitle
                if sortType == self.viewModel.sortType.value {
                    title += " *"
                }
                alertController.addAction(UIAlertAction(title: title, style: .default,
                                                        handler: { [unowned self, sortType] _ in
                    self.viewModel.sortType.accept(sortType)
                }))
            }
            
            alertController.addAction(UIAlertAction(title: "취소", style: .cancel))
            
            self.present(alertController, animated: true, completion: nil)
        }.disposed(by: disposeBag)
        
        // TableView Cell Bind
        viewModel.bookmarks.bind(to: tableView.rx.items){ (tableView, row, bookmark) -> UITableViewCell in
            switch bookmark {
            case let bookmark as HotelBookmark:
                let cell = tableView.dequeueReusableCell(withIdentifier: HotelBookmarkTableViewCell.Key) as! HotelBookmarkTableViewCell
                
                cell.btnBookmark.rx.tap.subscribe({ _ in
                    try? BookmarkManager.shared.delete(bookmark.id)
                }).disposed(by: cell.disposeBag)
                
                bookmark.bind(cell)
                return cell
            default: return UITableViewCell()
            }
        }.disposed(by: disposeBag)
        
        // 리스트 선택 시 상세 화면 이동
        tableView.rx.modelSelected(Bookmark.self)
            .subscribe { bookmark in
                switch bookmark.element {
                case let hotelBookmark as HotelBookmark:
                    guard let hotel = Hotel(hotelBookmark) else { return }

                    let propertyDetailView  = HotelDetailViewController(hotel)
                    self.navigationController?.pushViewController(propertyDetailView, animated: true)
                default: break
                }
            }
            .disposed(by: disposeBag)
    }
    
    private func initializeTableView() {
        tableView.rowHeight = 100
        tableView.register(UINib(nibName: "HotelBookmarkTableViewCell", bundle: nil),
                           forCellReuseIdentifier: HotelBookmarkTableViewCell.Key)
    }
}

extension HotelBookmark {
    func bind(_ cell: HotelBookmarkTableViewCell) {
        cell.lblTitle.text = title
        cell.lblRate.text = "\(rate)"
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd hh:mm:ss"
        
        cell.lblRateDate.text = dateFormatter.string(from: date)
        
        cell.imgView.image = nil
        if let thumbnailImageUrl = thumbnailImageUrl {
            cell.imgView.kf.setImage(with: thumbnailImageUrl)
        }
    }
}
