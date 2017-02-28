//
//  FeedNetworkService.swift
//  Dribbble
//
//  Created by Lobanov Aleksey on 30.01.17.
//  Copyright © 2017 Lobanov Aleksey. All rights reserved.
//

import Foundation
import RxSwift
import RealmSwift

protocol FeedNetworkPagination: NetworkServiceStateble {
  var loadNextPageTrigger: PublishSubject<Void> {get}
  var refreshTrigger: PublishSubject<Void> {get}
  var paginationState: Variable<PaginationState> {get}
  var shots: Variable<[ShotModel]> {get}
}

class FeedNetworkService: BaseNetworkService, FeedNetworkPagination {
  
  // Private
  // Dependencies
  private var api: Networking!
  private var shotId: Int!
  private var realm: Realm!
  
  // internal
  private var page = 1
  private let perPage = 10
  
  // Public
  var shots = Variable<[ShotModel]>([])
  var loadNextPageTrigger = PublishSubject<Void>()
  var refreshTrigger = PublishSubject<Void>()
  var paginationState = Variable<PaginationState>(.firstPage)
  
  init(api: Networking, shotId: Int, realm: Realm) {
    super.init()
    
    self.realm = realm
    self.api = api
    self.shotId = shotId
    
    self.configureRx()
  }
  
  func configureRx() {
    self.refreshTrigger
      .filter({[weak self] _ -> Bool in
        guard let state = self?.isRequestInProcess() else {
          return false
        }
        
        return !state
      })
      .subscribe(onNext: { [weak self] _ in
        self?.obtainFirstPage()
      }).addDisposableTo(bag)
    
    self.loadNextPageTrigger
      .filter({[weak self] _ -> Bool in
        guard let state = self?.isRequestInProcess() else {
          return false
        }
        
        return !state
      })
      .subscribe(onNext: { [weak self] _ in
        self?.obtainNextPage()
      }).addDisposableTo(bag)
  }
  
  func obtainNextPage() {
    self.page+=1
    self.obtainShots(page: self.page)
  }
  
  func obtainFirstPage() {
    self.paginationState.value = .firstPage
    self.page = 1
    self.obtainShots(page: 1)
  }
  
  func obtainShots(page: Int) {
    let response = api
      .provider
      .request(DribbbleAPI.shots(page: page, list: nil, timeframe: nil, date: nil, sort: nil))
      .mapJSONObjectArray(ShotModel.self, realm: self.realm)
    
    // prepare result
    let result = self.handleResponse(response)
      .do(onNext: {[weak self] (shots) in
          if let pp = self?.perPage  {
            self?.paginationState.value = (shots.count < pp) ? .endOfList : .morePage;
          }
        }, onError: {[weak self] _ in
          self?.page = page-1
      })
    
    // merge new result with exists data
    Observable.combineLatest(result, self.shots.asObservable()) { (new, exists) -> [ShotModel] in
        return (page == 1) ? new : exists + new
      }
      .take(1)
      .observeOn(Schedulers.shared.mainScheduler)
      .bindTo(self.shots)
      .disposed(by: bag)
  }
  
  deinit {
    print("-- CommentNetworkService dead")
  }
  
}
