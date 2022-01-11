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
    @IBOutlet var tableView: UITableView!
    @IBOutlet var btnSort: UIButton!
    
    private let disposeBag = DisposeBag()
    
    private var viewModel: BookmarkListViewModel = BookmarkListViewModel([])
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initializeSortButton()
        initializeTableView()
        bind()
    }
    
    private func bind() {
        viewModel.bookmarks
            .bind(to: tableView.rx.items(cellIdentifier: HotelBookmarkTableViewCell.Key, cellType: HotelBookmarkTableViewCell.self)) { (row, bookmark, cell) in
                switch bookmark {
                case let bookmark as HotelBookmark:
                    bookmark.bind(cell)
                default: break
                }
                
                cell.btnBookmark.rx.tap.subscribe({ _ in
                    try? BookmarkManager.shared.delete(bookmark.id)
                }).disposed(by: cell.disposeBag)
                
            }.disposed(by: disposeBag)
        
        
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
    
    private func initializeSortButton() {
        self.navigationItem.rightBarButtonItem?.rx.tap.bind { [unowned self] in
            let alertController = UIAlertController(title: "정렬", message: nil, preferredStyle: .actionSheet)
            alertController.addAction(UIAlertAction(title: "최근 등록 순 (오름차순)", style: .default, handler: { [unowned self] _ in
                self.viewModel.sortByDate(true)
            }))

            alertController.addAction(UIAlertAction(title: "최근 등록 순 (내림차순)", style: .default, handler: { [unowned self] _ in
                self.viewModel.sortByDate(false)
            }))
            
            alertController.addAction(UIAlertAction(title: "평점 순 (오름차순)", style: .default, handler: { [unowned self] _ in
                self.viewModel.sortByRate(true)
            }))
            
            alertController.addAction(UIAlertAction(title: "평점 순 (내림차순)", style: .default, handler: { [unowned self] _ in
                self.viewModel.sortByRate(false)
            }))
            
            self.present(alertController, animated: true, completion: nil)
        }.disposed(by: disposeBag)
    }
    
    private func initializeTableView() {
        tableView.rowHeight = 100
        tableView.register(UINib(nibName: "HotelBookmarkTableViewCell", bundle: nil), forCellReuseIdentifier: HotelBookmarkTableViewCell.Key)
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
