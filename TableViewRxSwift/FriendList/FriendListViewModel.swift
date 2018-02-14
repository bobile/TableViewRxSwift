//
//  FriendListViewModel.swift
//  TableViewRxSwift
//
//  Created by Aleksey Alekseenkov on 12/02/2018.
//  Copyright © 2018 Aleksey Alekseenkov. All rights reserved.
//

import RxSwift

class FriendListViewModel: NSObject {
  
  static let friendsNumberPerPage = 20
  
  var friends: Variable<Array<Any>>
  var vkFriendsProcessing: VKFriendsProcessing
  var disposeBag: DisposeBag
  var reloading: Variable<Bool>
  var isSearchState: Bool = false
  var isLoading: Bool = false
  var loadedFriendsCount: Int = 0
  
  var loadMoreFriendsTrigger: Observable<Void>
  var reloadFriendsTrigger: Observable<Void>
  var searchFriendsStream: Observable<String>
  
  
  init(loadMoreFriendsTrigger: Observable<Void>,
       reloadFriendsTrigger: Observable<Void>,
       searchFriendsStream: Observable<String>) {
    
    self.friends = Variable([])
    self.vkFriendsProcessing = VKFriendsProcessing()
    self.disposeBag = DisposeBag()
    self.reloading = Variable(false)
    
    self.loadMoreFriendsTrigger = loadMoreFriendsTrigger
    self.reloadFriendsTrigger = reloadFriendsTrigger
    self.searchFriendsStream = searchFriendsStream
    
    super.init()
    
    self.setupObservables()
  }
  
  func setupObservables() {
    self.loadMoreFriendsTrigger
      .subscribe(onNext: { [unowned self] (_) in
        if self.isSearchState {
          return
        }
        self.loadFriends(reload: false, completion: { (_) in })
      })
      .disposed(by: disposeBag)
    
    self.reloadFriendsTrigger
      .subscribe(onNext: { [unowned self] (_) in
        self.reloading.value = true
        self.loadFriends(reload: true, completion: { (_) in
          self.reloading.value = false
        })
      })
      .disposed(by: disposeBag)
    
    self.searchFriendsStream
      .skip(1)
      .subscribe(onNext: { [unowned self] (query) in
        if query.count > 0 {
          self.isSearchState = true
          self.searchFriends(query: query, completion: { (friends) in })
        } else {
          self.loadFriends(reload: true, completion: { (friends) in })
        }
      })
      .disposed(by: disposeBag)
  }
  
  func didAppear() {
    self.loadFriends(reload: true) { _ in }
  }
  
  func loadFriends(reload: Bool, completion: @escaping (Array<Friend>) -> Void) {
    if self.isLoading {
      return
    }
    self.isLoading = true
    if reload {
      isSearchState = false
    }
    self.vkFriendsProcessing
      .list(offset: reload ? 0 : self.loadedFriendsCount, count: FriendListViewModel.friendsNumberPerPage) { friends in
        self.isLoading = false
        
        self.loadedFriendsCount += friends.count
        let filteredFriends = self.filterdFriends(friends: friends)
        
        if reload {
          self.friends.value = filteredFriends
        } else {
          self.friends.value = self.friends.value + filteredFriends
        }
        completion(friends)
    }
  }
 
  func searchFriends(query: String, completion: @escaping (Array<Friend>) -> Void) {
    self.vkFriendsProcessing.search(query: query) { (friends) in
      self.friends.value = self.filterdFriends(friends: friends)
      completion(friends)
    }
  }
  
  func filterdFriends(friends:[Friend]) -> [Friend] {
    return friends.filter({ (friend) -> Bool in
      return friend.city != nil && friend.hasProfileImage
    })
  }
  
}
