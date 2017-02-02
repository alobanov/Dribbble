//
//  FeedViewModel.swift
//  Dribbble
//
//  Created by Lobanov Aleksey on 18.01.17.
//  Copyright (c) 2017 Lobanov Aleksey. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import RealmSwift

protocol FeedViewModelTestable {
  func prepareShotList(list: [FeedCellModel]) -> [ModelSection]
  func prepareShotsFirstPage() -> [ModelSection]
  func saveFirstPageIDs(ids: [Int])
}

protocol FeedModuleOutput: class {

}

protocol FeedModuleInput {
  
}

protocol FeedOutput: RxModelOutput {
  // dependencies
  var router: FeedRouterInput! {get}
  
  // initialization rx.cocoa
  func confRx(signin: Driver<Void>)
  
  // observable
  var title: Variable<String> {get}
  var items: Variable<[ModelSection]> {get}
  var loadNextPageTrigger: PublishSubject<Void> {get}
}

protocol FeedInput: class {
//  func show(error: NSError)
}

class FeedViewModel: RxViewModel, FeedOutput, FeedModuleInput, FeedViewModelTestable {
  
  // MARK:- dependencies
  fileprivate weak var view: FeedInput!
  fileprivate var api: Networking!
  fileprivate var realm: Realm?
  fileprivate var appSettings: AppSettingsStorage?
  var router: FeedRouterInput!
  
  // MARK:- properties
  // FeedOutput
  var title = Variable<String>("Rx Request")
  var items = Variable<[ModelSection]>([])
  var loadNextPageTrigger = PublishSubject<Void>()
  
  // Private
  fileprivate var originalItems = Variable<[FeedCellModel]>([])
  fileprivate var page = 1
  
  // MARK:- init
  
  init(dependencies:(
    view: FeedInput,
    router: FeedRouterInput,
    api: Networking,
    realm: Realm?,
    appSettings: AppSettingsStorage?
    )) {
    self.view = dependencies.view
    self.router = dependencies.router
    self.api = dependencies.api
    self.realm = dependencies.realm
    self.appSettings = dependencies.appSettings
    
    super.init()
  }
  
  // Output
  
  func confRx(signin: Driver<Void>) {
    
    signin.drive(onNext: {
      self.obtainShots(by: 1)
    }).addDisposableTo(bag)
    
//    self.items
//      .asObservable()
//      .take(1)
//      .filter{ $0.count == 0 }
//      .map({ _ -> [ModelSection] in self.prepareShotsFirstPage() })
//      .bindTo(self.items)
//      .addDisposableTo(bag)
    
    self.originalItems.asObservable()
      .map({ l -> [ModelSection] in
        if self.page == 1 {
          let ids = l.map { $0.shotId }
          self.saveFirstPageIDs(ids: ids)
        }
        
        print("ttt: Bind new items count: \(l.count)")
        return self.prepareShotList(list: l)
      })
      .bindTo(self.items)
      .addDisposableTo(bag)
    
    self.loadNextPageTrigger
      .filter { self._loadingState.value == .normal }
      .subscribe(onNext: {
        print("ttt: obtain next page")
        self.obtainNextPage()
      }).addDisposableTo(bag)
  }
  
  // MARK: - Additional
  
  deinit {
    print("-- FeedViewModel dead")
  }
}

// MARK: - Additional helpers
extension FeedViewModel {
  
  /// Wrap ShotModels into datasource protocols
  ///
  /// - Parameter list: ShotModel
  /// - Returns: Wrapped array of ModelSection
  func prepareShotList(list: [FeedCellModel]) -> [ModelSection] {
    var renderItemsData: [ModelSectionItem] = []
    renderItemsData = list.map { ModelSectionItem(model: $0) }
    return [ModelSection(items: renderItemsData)]
  }
  
  
  /// Obtain last cached first page of feed
  ///
  /// - Returns: Wrapped array of ModelSection
  func prepareShotsFirstPage() -> [ModelSection] {
    guard let r = self.realm else { return []; }
    
    if let ids = self.appSettings?.feedFirstPage {
      let predicate = NSPredicate(format: "shotId IN %@", ids)
      let shots = r.objects(ShotModel.self)
        .filter(predicate)
        .sorted { ids.index(of: $0.shotId)! < ids.index(of: $1.shotId)! }
      
      return self.prepareShotList(list: Array(shots.map { $0.feedModel() }))
    } else {
      return []
    }
  }
  
  
  /// Saving first page of feed
  ///
  /// - Parameter ids: [Int]
  func saveFirstPageIDs(ids: [Int]) {
    self.appSettings?.feedFirstPage = ids
  }
}

// MARK: - Network
extension FeedViewModel {
  func obtainNextPage() {
    self.page += 1
    self.obtainShots(by: self.page)
  }
  
  func obtainFirstPage() {
    self.page = 1
    obtainShots(by: page)
  }
  
  func obtainShots(by page: Int) {
    if isRequestInProcess() {
      return
    }
    
    let res = api
      .provider
      .request(DribbbleAPI.shots(page: page, list: nil, timeframe: nil, date: nil, sort: nil))
      .mapJSONObjectArray(ShotModel.self, realm: self.realm)
    
    self.handleResponse(res)
      .observeOn(Schedulers.shared.backgroundWorkScheduler)
      .map({ shots -> [FeedCellModel] in
        return shots.map { $0.feedModel() }
      }).map({ feedItems ->[FeedCellModel] in
        return (page == 1) ? feedItems : self.originalItems.value + feedItems
      })
      .observeOn(Schedulers.shared.mainScheduler)
      .take(1)
      .bindTo(self.originalItems)
      .addDisposableTo(bag)
    }

//  func paginationRequest(currentPage: Int) {
//   var page = currentPage
//    
//    self.refreshTrigger.map { _ in
//      page = 1
//    }.bindTo(self.performRequest)
//    .addDisposableTo(self.bag)
//    
//    self.loadNextPageTrigger
//      .bindTo(self.performRequest)
//      .addDisposableTo(bag)
//    
//    let response = self.performRequest
//      .flatMap {[weak self] _ -> Observable<[ShotModel]> in
//        print("perform request with page: \(page)")
//        
//        return (self?.api.provider
//          .request(DribbbleAPI.shots(page: page, list: nil, timeframe: nil, date: nil, sort: nil))
//          .mapJSONObjectArray(ShotModel.self, realm: self?.realm))!
//    }.shareReplay(1)
//    
//    Observable.combineLatest(response, self.shotItems.asObservable()) { new , exists in
//        return (exists.count == 0 || page == 1) ? new : exists + new
//      }
//      .take(1)
//      .bindTo(self.shotItems)
//      .addDisposableTo(bag)
//    
//    response.catchError { (err) -> Observable<[ShotModel]> in
//        return Observable.just([])
//      }.subscribe(onNext: {[weak self] _ in
//        self?.paginationRequest(currentPage: page+1)
//      }).addDisposableTo(bag)
//  }
}

