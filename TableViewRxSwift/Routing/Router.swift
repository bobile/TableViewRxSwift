//
//  Router.swift
//  TableViewRxSwift
//
//  Created by Aleksey Alekseenkov on 10/02/2018.
//  Copyright © 2018 Aleksey Alekseenkov. All rights reserved.
//

import UIKit

protocol Closable: class {
  func close()
}

protocol RouterProtocol: class {
  associatedtype V: UIViewController
  func open(viewController: UIViewController)
}

class Router<U>: RouterProtocol, Closable where U: UIViewController {
  typealias V = U
  weak var viewController: V?
  
  func open(viewController: UIViewController) {
    self.viewController?.navigationController?.pushViewController(viewController, animated: true)
  }
  
  func close() {
    self.viewController?.navigationController?.popViewController(animated: true)
  }
  
}
