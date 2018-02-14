//
//  AppDelegate.swift
//  TableViewRxSwift
//
//  Created by Aleksey Alekseenkov on 10/02/2018.
//  Copyright © 2018 Aleksey Alekseenkov. All rights reserved.
//

import UIKit
import VK_ios_sdk

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  
  var window: UIWindow?
  
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    VKSdk.initialize(withAppId: "6290903")
    return true
  }

  func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
    VKSdk.processOpen(url, fromApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication] as! String)
    return true
  }
  
}

