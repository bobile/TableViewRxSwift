//
//  LoginViewModel.swift
//  TableViewRxSwift
//
//  Created by Aleksey Alekseenkov on 10/02/2018.
//  Copyright © 2018 Aleksey Alekseenkov. All rights reserved.
//

import UIKit
import RxSwift

class LoginViewModel: NSObject {
  
  let vkLogin: VKLoginProcessing
  let router: LoginRouter
  
  let disposeBag = DisposeBag()
  var loginTap: Observable<Void>
  
  init(vkLogin: VKLoginProcessing,
       router: LoginRouter,
       loginTap: Observable<Void>) {
    
    self.vkLogin = vkLogin
    self.router = router
    self.loginTap = loginTap
    super.init()
    
    setupObservables()
  }
  
  func setupObservables() {
    loginTap
      .flatMap { [unowned self] in
        self.vkLogin.login()
      }
      .subscribe(onNext: { [unowned self] (successLogin) in
        self.router.openFriendList()
      })
      .disposed(by: self.disposeBag)
  }
  
}
