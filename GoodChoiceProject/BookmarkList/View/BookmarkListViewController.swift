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
    
    private var viewModel: BookmarkListViewModel = BookmarkListViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initializeSortButton()
        initializeTableView()
        
        viewModel.bookmarks.bind(to: tableView.rx.items(cellIdentifier: BookmarkTableViewCell.Key, cellType: BookmarkTableViewCell.self)) { (row, bookmark, cell) in
            switch bookmark {
            case let bookmark as HotelBookmark:
                break
            default:
                break
            }
            
        }.disposed(by: disposeBag)
    }
    
    func initializeSortButton() {
        btnSort.rx.tap.bind { [unowned self] in
            let alertController = UIAlertController(title: "정렬", message: nil, preferredStyle: .actionSheet)
            alertController.addAction(UIAlertAction(title: "최근 등록 순 (오름차순)", style: .default, handler: { [unowned self] _ in
                self.viewModel.sortByDate(true)
            }))
            
            alertController.addAction(UIAlertAction(title: "최근 등록 순 (내림차순)", style: .default, handler: { [unowned self] _ in
                self.viewModel.sortByDate(false)
            }))
            
            alertController.addAction(UIAlertAction(title: "평점 순 (오름차순)", style: .default, handler: { [unowned self] _ in
                self.viewModel.sortByRate(false)
            }))
            
            alertController.addAction(UIAlertAction(title: "평점 순 (내림차순)", style: .default, handler: { [unowned self] _ in
                self.viewModel.sortByRate(false)
            }))
            
            self.present(alertController, animated: true, completion: nil)
        }.disposed(by: disposeBag)
    }
    
    func initializeTableView() {
        tableView.register(UINib(nibName: "BookmarkTableViewCell", bundle: nil), forCellReuseIdentifier: BookmarkTableViewCell.Key)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
}

extension HotelBookmark {
    func bind(_ cell: BookmarkTableViewCell) {
        cell.lblTitle.text = title
        cell.lblRate.text = "\(rate)"
        
        cell.imgView.image = nil
        if let imageUrlString = imageUrlString {
//            cell.imgView.kf.setImage(with: thumbnailImageUrl)
        }
    }
}
