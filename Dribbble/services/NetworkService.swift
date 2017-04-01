//
//  BaseNetworkService.swift
//  Dribbble
//
//  Created by Lobanov Aleksey on 17.02.17.
//  Copyright © 2017 Lobanov Aleksey. All rights reserved.
//

import Foundation
import RxSwift

/// Method identifier
enum NetworkReqestType {
  case shots
  case shotComments
  case unknown
}

struct NetworkError {
  let type: NetworkReqestType
  let error: NSError
}

struct NetworkState {
  let type: NetworkReqestType
  let state: LoadingState
}

protocol NetworkServiceStateble {
  var networkError: Observable<NetworkError> {get}
  var commonNetworkState: Observable<NetworkState> {get}
}

class NetworkService {
  let bag = DisposeBag()
  
  var networkError: Observable<NetworkError> {
    return _networkError.asObservable().skip(1)
  }
  
  var commonNetworkState: Observable<NetworkState> {
    return _commonNetworkState.asObservable()
  }
  
  // Dependencies
  var api: Networking!
  private var requestInProcess = false
  internal var _networkError = Variable<NetworkError>(NetworkError(type: .unknown, error: AppError.dummyError.error))
  internal var _commonNetworkState = Variable<NetworkState>(NetworkState(type: .unknown, state: .unknown))
  
  init(api: Networking) {
    self.api = api
  }
  
  func isRequestInProcess(networkReqestType: NetworkReqestType = .unknown) -> Bool {
    guard _commonNetworkState.value.state != .loading else { return true }
    _commonNetworkState.value = NetworkState(type: networkReqestType, state: .loading)
    
    return false
  }
  
  func handleResponse<E>(_ response: Observable<E>, networkReqestType: NetworkReqestType) -> Observable<E> {
    return response.map {[weak self] (event) -> E in
      self?._commonNetworkState.value = NetworkState(type: networkReqestType, state: .normal)
      return event
      }.do(onError: {[weak self] (err) in
        let e = err as NSError
        self?.throwError(type: networkReqestType, error: e)
      })
  }
  
  func throwError(type: NetworkReqestType, error: NSError) {
    self._networkError.value = NetworkError(type: type, error: error)
    self._commonNetworkState.value = NetworkState(type: type, state: .error)
  }
}
