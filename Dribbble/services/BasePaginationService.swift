//
//  BasePaginationService.swift
//  Dribbble
//
//  Created by Lobanov Aleksey on 28.02.17.
//  Copyright © 2017 Lobanov Aleksey. All rights reserved.
//

import Foundation
import RxSwift

protocol NetworkPagination: NetworkServiceStateble {
  var loadNextPageTrigger: PublishSubject<Void> {get}
  var refreshTrigger: PublishSubject<Void> {get}
  var paginationState: Variable<PaginationState> {get}
}

class BasePaginationService: BaseNetworkService, NetworkPagination {
  
  // Private
  // Dependencies
  private var api: Networking!
  
  // internal
  private var page = 1
  private let perPage = 10
  
  // Public
  var loadNextPageTrigger = PublishSubject<Void>()
  var refreshTrigger = PublishSubject<Void>()
  var paginationState = Variable<PaginationState>(.firstPage)
  
  init(api: Networking) {
    super.init()
    
    self.api = api
    self.configureRx()
  }
  
  func configureRx() {
    self.refreshTrigger
      .filter({[weak self] _ -> Bool in
        guard let s = self else {
          return false
        }
        
        return !s.isRequestInProcess()
      })
      .subscribe(onNext: { [weak self] _ in
        self?.obtainFirstPage()
      }).addDisposableTo(bag)
    
    self.loadNextPageTrigger
      .filter({[weak self] _ -> Bool in
        guard let s = self else { return false }
        return !s.isRequestInProcess()
      })
      .subscribe(onNext: { [weak self] _ in
        self?.obtainNextPage()
      }).addDisposableTo(bag)
  }
  
  func obtainNextPage() {
    self.page+=1
    self.obtainComments(by: self.page)
  }
  
  func obtainFirstPage() {
    self.paginationState.value = .firstPage
    self.page = 1
    self.obtainComments(by: 1)
  }
  
  func obtainComments(by page: Int) {
    
  }
  
  deinit {
    print("-- BasePaginationService dead")
  }
}
