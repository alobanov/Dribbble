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

protocol FeedNetworkPagination: NetworkPagination {
  var shots: Variable<[ShotModel]> {get}
  func prepareFirstPageFromCache() -> [ShotModel]
  func mapFirstPage()
}

class FeedNetworkService: PaginationService, FeedNetworkPagination {
  
  // Private
  // Dependencies
  fileprivate var realm: Realm!
  fileprivate var appSettings: AppSettingsStorage?
  
  // internal
  private var page = 1
  private let perPage = 10
  
  // Public
  var shots = Variable<[ShotModel]>([])
  
  init(api: Networking, realm: Realm, appSettings: AppSettingsStorage?) {
    super.init(networking: api)
    
    self.realm = realm
    self.appSettings = appSettings
    self.configureRx()
  }
  
  override func obtainData(by page: Int) {
    
    let method = DribbbleAPI.shots(page: page, list: nil, timeframe: nil, date: nil, sort: nil)
    
    let response = api
      .provider
      .request(method)
      .mapJSONObjectArray(ShotModel.self, realm: self.realm)
    
    // prepare result
    let result = self.handleResponse(response, networkReqestType: .shots)
      .do(onNext: {[weak self] shots in
        if let pp = self?.perPage  {
          self?.paginationState.onNext((shots.count < pp) ? .endOfList : .morePage)
        }
        
        if (page == 1) {
            self?.saveFirstPage(by: shots)
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

// MARK: - Additional helpers
extension FeedNetworkService {
  
  /// Obtain last cached first page of feed
  ///
  /// - Returns: Wrapped array of ModelSection
  func prepareFirstPageFromCache() -> [ShotModel] {
    guard let r = self.realm else { return []; }
    
    if let ids = self.appSettings?.feedFirstPage {
      let predicate = NSPredicate(format: "shotId IN %@", ids)
      return r.objects(ShotModel.self)
        .filter(predicate)
        .sorted { ids.index(of: $0.shotId)! < ids.index(of: $1.shotId)! }
    } else {
      return []
    }
  }
  
  func mapFirstPage() {
    let cache = self.prepareFirstPageFromCache()
    if (cache.count > 0) {
      self.shots.value = cache
    }
  }
  
  /// Saving ids of first page
  ///
  /// - Parameter by: [FeedCellModel]
  func saveFirstPage(by: [ShotModel]) {
    let ids = by.map { $0.shotId }
    self.appSettings?.feedFirstPage = ids
  }
}
