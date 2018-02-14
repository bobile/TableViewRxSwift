//
//  LoginViewController.swift
//  TableViewRxSwift
//
//  Created by Aleksey Alekseenkov on 10/02/2018.
//  Copyright © 2018 Aleksey Alekseenkov. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class LoginViewController: UIViewController {
  
  @IBOutlet weak var vkButton: UIButton!
  
  var viewModel: LoginViewModel!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    bindViewModel()
  }
  
  override var prefersStatusBarHidden: Bool {
    return true
  }
  
  func bindViewModel() {
    let router = LoginRouter()
    router.viewController = self
    viewModel = LoginViewModel(vkLogin: VKLoginProcessing(fromViewController: self),
                               router: router,
                               loginTap: vkButton.rx.tap.asObservable())
  }
  
}

