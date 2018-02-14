//
//  FriendTableViewCell.swift
//  TableViewRxSwift
//
//  Created by Aleksey Alekseenkov on 13/02/2018.
//  Copyright © 2018 Aleksey Alekseenkov. All rights reserved.
//

import UIKit
import Kingfisher

class FriendTableViewCell: UITableViewCell {
  
  @IBOutlet weak var profilePhoto: UIImageView!
  @IBOutlet weak var cityLabel: UILabel!
  @IBOutlet weak var nameLabel: UILabel!
  
  static var identifier = "FriendTableViewCell"
  
  func configure(withFriend friend: Friend) {
    if friend.profileImageURL != nil {
      profilePhoto.kf.setImage(with: URL(string: friend.profileImageURL!)!)
    }
    nameLabel.text = friend.fullName
    cityLabel.text = friend.city
  }
  
}
