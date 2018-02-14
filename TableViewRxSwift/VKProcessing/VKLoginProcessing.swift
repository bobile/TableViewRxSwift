//
//  VKLogin.swift
//  TableViewRxSwift
//
//  Created by Aleksey Alekseenkov on 10/02/2018.
//  Copyright © 2018 Aleksey Alekseenkov. All rights reserved.
//

import VK_ios_sdk
import RxSwift

class VKLoginProcessing: NSObject {
  
  var fromViewController: UIViewController!
  var loginCompletion: ((Bool) -> Void)!
  
  init(fromViewController: UIViewController) {
    self.fromViewController = fromViewController
    super.init()
  }
  
  func login(_ completion: @escaping (Bool) -> Void) {
    loginCompletion = completion
    VKSdk.instance().register(self)
    VKSdk.instance().uiDelegate = self
    VKSdk.authorize(["friends"])
  }
  
}

extension VKLoginProcessing: VKSdkDelegate {
  
  func vkSdkAccessAuthorizationFinished(with result: VKAuthorizationResult!) {
    loginCompletion(result.token.accessToken.count > 0)
  }
  
  func vkSdkUserAuthorizationFailed() {
    loginCompletion(false)
  }
  
}

extension VKLoginProcessing {
  
  enum LoginError: Error {
    case SomeError
  }
  
  func login() -> Observable<Bool> {
    return Observable.create({ (observer) -> Disposable in
      self.login({ (successLogin) in
        if successLogin {
          observer.onNext(successLogin)
          observer.onCompleted()
        } else {
          observer.onError(LoginError.SomeError)
        }
      })
      return Disposables.create()
    })
  }
  
}

extension VKLoginProcessing: VKSdkUIDelegate {
  
  func vkSdkShouldPresent(_ controller: UIViewController!) {
    fromViewController.present(controller, animated: true, completion: nil)
  }
  
  func vkSdkNeedCaptchaEnter(_ captchaError: VKError!) {
    
  }
  
}
