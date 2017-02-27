//
//  CommentNetworkService.swift
//  Dribbble
//
//  Created by Lobanov Aleksey on 17.02.17.
//  Copyright © 2017 Lobanov Aleksey. All rights reserved.
//

import Foundation
import RxSwift

protocol CommentNetworkPagination: NetworkServiceStateble {
  func obtainNextPage()
  func obtainFirstPage()
  
  var loadNextPageTrigger: PublishSubject<Void> {get}
  var refreshTrigger: PublishSubject<Void> {get}
  var paginationState: Variable<PaginationState> {get}
}

class CommentNetworkService: BaseNetworkService, CommentNetworkPagination {
  
  // Private
  // Dependencies
  private var api: Networking!
  private var shotId: Int!
  
  // internal
  private var page = 1
  private let perPage = 10
  
  // Public
  var comments = Variable<[ShotCommentModel]>([])
  var loadNextPageTrigger = PublishSubject<Void>()
  var refreshTrigger = PublishSubject<Void>()
  var paginationState = Variable<PaginationState>(.firstPage)
  
  init(api: Networking, shotId: Int) {
    super.init()
    
    self.api = api
    self.shotId = shotId
    
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
    self.obtainShots(by: self.page)
  }
  
  func obtainFirstPage() {
    self.paginationState.value = .firstPage
    self.page = 1
    self.obtainShots(by: 1)
  }
  
  func obtainShots(by page: Int) {
    let response = api
      .provider
      .request(DribbbleAPI.shotComments(shotID: self.shotId, page: page, perPage: perPage))
      .mapJSONObjectArray(ShotCommentModel.self)
    
    // prepare result
    let result = self.handleResponse(response)
      .do(onNext: {[weak self] (comments) in
        if let pp = self?.perPage  {
          self?.paginationState.value = (comments.count < pp) ? .endOfList : .morePage;
        } 
      }, onError: {[weak self] _ in
        self?.page = page-1
      })
    
    // merge new result with exists data
    Observable.combineLatest(result, self.comments.asObservable()) { new, exists in
        return (page == 1) ? new : exists + new
      }
      .take(1)
      .bindTo(self.comments)
      .disposed(by: bag)
  }
  
  deinit {
    print("-- CommentNetworkService dead")
  }
}
