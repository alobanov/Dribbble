//
//  RxViewModel.swift
//  Dribbble
//
//  Created by Lobanov Aleksey on 08.09.16.
//  Copyright © 2016 Lobanov Aleksey. All rights reserved.
//

import Foundation
import RxSwift

protocol RxModelOutput {
  var loadingState: Observable<LoadingState> {get}
  var displayError: Observable<NSError> {get}
}

class RxViewModel {
  let bag = DisposeBag()
  
  var displayError: Observable<NSError> {
    return _displayError.asObservable().skip(1)
  }
  
  var loadingState: Observable<LoadingState> {
    return _loadingState.asObservable()
  }
  
  internal var _loadingState = Variable<LoadingState>(.unknown)
  internal var _displayError = Variable<NSError>(NSError(domain: "", code: 0, userInfo: nil))
  
  init() {
    
  }
  
  func isRequestInProcess() -> Bool {
    guard _loadingState.value != .loading else { return true }
    _loadingState.value = .loading
    
    return false
  }
  
  func handleResponse<E>(_ response: Observable<E>) -> Observable<E> {
    return response.map { [weak self] (event) -> E in
      self?._loadingState.value = .normal
      return event
    }.do(onError: { [weak self] (err) in
      let e = err as NSError
      self?._displayError.value = e
      self?._loadingState.value = .error
    })
  }
}
