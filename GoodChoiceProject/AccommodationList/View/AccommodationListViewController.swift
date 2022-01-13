//
//  AccommodationListViewController.swift
//  GoodChoiceProject
//
//  Created by 김이은 on 2022/01/08.
//

import UIKit
import RxSwift
import RxCocoa
import Kingfisher

final class AccommodationListViewController: UIViewController {
    
    // View
    @IBOutlet private var tableView: UITableView!
    @IBOutlet private var loadingView: UIActivityIndicatorView!
    
    // ViewModel
    private var viewModel: AccommodationListViewModel = AccommodationListViewModel()
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initializeTableView()
        
        bind()
        
        // 첫번째 페이지 API 호출
        viewModel.fetchData()
    }
    
    private func bind() {
        viewModel.accommodationViewModels.bind(to: tableView.rx.items){ (tableView, row, accommodationViewModel) -> UITableViewCell in
            switch accommodationViewModel {
            case let hotelViewModel as HotelViewModel:
                let cell = tableView.dequeueReusableCell(withIdentifier: HotelPropertyListTableViewCell.Key) as! HotelPropertyListTableViewCell
                
                hotelViewModel.viewBind(cell)
                
                return cell
            default: return UITableViewCell()
            }
        }.disposed(by: disposeBag)
        
        viewModel.isLoading.bind(to: loadingView.rx.isAnimating).disposed(by: disposeBag)
        if let refreshControl = tableView.refreshControl {
            viewModel.isLoading
                .filter { $0 == false }
                .filter { _ in refreshControl.isRefreshing == true }
                .bind(to: refreshControl.rx.isRefreshing)
                .disposed(by: disposeBag)
        }
        
        tableView.rx.willDisplayCell.observe(on: MainScheduler.instance).bind {
            guard let current = self.viewModel.currentPage else { return }
            let indexPath = $0.indexPath
            if indexPath.row == self.tableView.numberOfRows(inSection: 0) - 1 {
                self.viewModel.fetchData(current+1)
            }
        }.disposed(by: disposeBag)
        
        
        tableView.rx.didEndDragging.filter({ $0 == true }).bind { [unowned self] _ in
            guard self.tableView.contentOffset.y > self.tableView.contentSize.height - self.tableView.frame.height else { return }
            guard let current = self.viewModel.currentPage else { return }
            
            self.viewModel.fetchData(current+1)
        }.disposed(by: disposeBag)
        
        tableView.rx.modelSelected(AccomodationViewModel.self).bind {
            switch $0.accommodation {
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
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.rx.controlEvent(.valueChanged)
            .bind(to: viewModel.refreshControlCalled)
            .disposed(by: disposeBag)
    }
}
