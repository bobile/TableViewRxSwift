//
//  ProfileRote.swift
//  ProtocolTest
//
//  Created by Aleksey Alekseenkov on 03/02/2018.
//  Copyright © 2018 Aleksey Alekseenkov. All rights reserved.
//

import UIKit

protocol FriendListRoute {
  func openFriendList()
}

extension FriendListRoute where Self: RouterProtocol {
  
  func openFriendList() {
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    let friendListViewController = storyboard.instantiateViewController(withIdentifier: "FriendListViewController")
    self.open(viewController: friendListViewController)
  }
  
}
