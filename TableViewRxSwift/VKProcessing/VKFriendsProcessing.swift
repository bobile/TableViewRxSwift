//
//  VKFriends.swift
//  TableViewRxSwift
//
//  Created by Aleksey Alekseenkov on 12/02/2018.
//  Copyright © 2018 Aleksey Alekseenkov. All rights reserved.
//

import VK_ios_sdk

class VKFriendsProcessing: NSObject {
  
  let VKFriendsNoHavePhotoURLs = ["http://vk.com/images/camera_b.gif", "https://vk.com/images/camera_200.png"]
  
  func list(offset: Int, count: Int, completion: @escaping (Array<Friend>) -> Void) {
    VKRequest(method: "friends.get", parameters: ["offset" : offset, "count" : count, "fields" : "uid,city,photo_max"]).execute(resultBlock: { (response) in
      completion(self.parse(data: response?.json))
    }) { (error) in
      completion([])
    }
  }
  
  func search(query: String, completion: @escaping (Array<Friend>) -> Void) {
    VKRequest(method: "friends.search", parameters: ["q" : query, "fields" : "uid,city,photo_max"]).execute(resultBlock: { (response) in
      completion(self.parse(data: response?.json))
    }) { (error) in
      completion([])
    }
  }
  
  func parse(data: Any?) -> Array<Friend> {
    var friends = Array<Friend>()
    guard let dict = data as? Dictionary<String, Any> else {
      return []
    }
    guard let array = dict["items"] as? Array<Any> else {
      return []
    }
    for object in array {
      if let dict = object as? Dictionary<String, Any> {
        let id = dict["id"] as! Int
        let firstName = dict["first_name"] as! String
        let secondName = dict["last_name"] as! String
        let profileImageURL = dict["photo_max"] as! String
        var city: String? = nil
        if let cityDict = dict["city"] as? Dictionary<String, Any> {
          city = cityDict["title"] as? String
        }
        
        let friend =
          Friend(id: "\(id)",
            firstName: firstName,
            secondName: secondName,
            city: city,
            profileImageURL: profileImageURL,
            hasProfileImage: !VKFriendsNoHavePhotoURLs.contains(profileImageURL))
        friends.append(friend)
      }
    }
    return friends
  }
  
}
