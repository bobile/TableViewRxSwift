//
//  FriendListViewController.swift
//  TableViewRxSwift
//
//  Created by Aleksey Alekseenkov on 12/02/2018.
//  Copyright © 2018 Aleksey Alekseenkov. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

let offsetToLoadMore: CGFloat = 100

class FriendListViewController: UIViewController {
  
  var viewModel: FriendListViewModel!
  var disposeBag: DisposeBag!
  
  @IBOutlet weak var searchBar: UISearchBar!
  @IBOutlet weak var tableView: UITableView!
  var refreshControl: UIRefreshControl!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    refreshControl = UIRefreshControl()
    tableView.refreshControl = refreshControl
    tableView.keyboardDismissMode = .onDrag
    tableView.rowHeight = UIScreen.main.bounds.width
    
    searchBar.delegate = self
    
    disposeBag = DisposeBag()
    bindViewModel()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    viewModel.didAppear()
  }
  
  func bindViewModel() {
    let loadMoreFriendsTrigger = tableView
      .rx
      .didScroll
      .throttle(0.3, scheduler: MainScheduler.instance)
      .filter({ [unowned self] () -> Bool in
        return self.tableView.contentOffset.y + self.tableView.bounds.height >= self.tableView.contentSize.height - offsetToLoadMore
      })
      .filter({ [unowned self] () -> Bool in
        return  self.tableView.numberOfRows(inSection: 0) == self.viewModel.friends.value.count
      })
    
    let reloadFriendsTrigger = refreshControl.rx.controlEvent(UIControlEvents.valueChanged)
      .filter({ [unowned self] () -> Bool in
        return self.refreshControl.isRefreshing
      }).asObservable()
    
    let searchFriendsStream = searchBar.rx.text.orEmpty
      .throttle(0.3, scheduler: MainScheduler.instance)
      .distinctUntilChanged()
    
    viewModel = FriendListViewModel(loadMoreFriendsTrigger: loadMoreFriendsTrigger, reloadFriendsTrigger: reloadFriendsTrigger, searchFriendsStream: searchFriendsStream)
    
    viewModel.friends.asObservable()
      .bind(to: tableView
        .rx
        .items(cellIdentifier: FriendTableViewCell.identifier,
               cellType: FriendTableViewCell.self)) { row, friend, cell in
                if let friend = friend as? Friend {
                  cell.configure(withFriend: friend)
                }
      }
      .disposed(by: disposeBag)
    
    viewModel.reloading.asObservable()
      .subscribe(onNext: { [unowned self] (reloading) in
        if self.refreshControl.isRefreshing && !reloading {
          self.refreshControl.endRefreshing()
        }
      })
      .disposed(by: disposeBag)
  }
  
}

extension FriendListViewController: UISearchBarDelegate {
  
  func position(for bar: UIBarPositioning) -> UIBarPosition {
    return .topAttached
  }
  
}
