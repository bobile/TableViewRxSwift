//
//  Friend.swift
//  TableViewRxSwift
//
//  Created by Aleksey Alekseenkov on 12/02/2018.
//  Copyright © 2018 Aleksey Alekseenkov. All rights reserved.
//

import UIKit

class Friend: NSObject {

  let id: String
  let firstName: String
  let secondName: String
  let city: String?
  let profileImageURL: String?
  let hasProfileImage: Bool
  var fullName: String {
    get {
      return "\(self.firstName) \(self.secondName)"
    }
  }
  
  init(id: String, firstName: String, secondName: String, city: String?, profileImageURL: String?, hasProfileImage: Bool = false) {
    self.id = id
    self.firstName = firstName
    self.secondName = secondName
    self.city = city
    self.profileImageURL = profileImageURL
    self.hasProfileImage = hasProfileImage
    super.init()
  }
  
}
