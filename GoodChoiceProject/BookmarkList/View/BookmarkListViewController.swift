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
        viewModel.bookmarkViewModels.bind(to: tableView.rx.items){ (tableView, row, bookmarkViewModel) -> UITableViewCell in
            switch bookmarkViewModel {
            case let hotelBookmark as HotelBookmarkViewModel:
                let cell = tableView.dequeueReusableCell(withIdentifier: HotelBookmarkTableViewCell.Key) as! HotelBookmarkTableViewCell
                hotelBookmark.viewBind(cell)
                return cell
            default: return UITableViewCell()
            }
        }.disposed(by: disposeBag)
        
        // 리스트 선택 시 상세 화면 이동
        tableView.rx.modelSelected(BookmarkViewModel.self)
            .bind { viewModel in
                switch viewModel.bookmark.type {
                case .hotel:
                    let propertyDetailView  = HotelDetailViewController(Hotel(viewModel.bookmark))
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
