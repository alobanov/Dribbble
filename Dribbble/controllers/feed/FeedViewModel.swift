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
  func prepareForDatasource(list: [FeedCellModel]) -> [ModelSection]
  func prepareFirstPageFromCache() -> [FeedCellModel]
  func saveFirstPage(by: [FeedCellModel])
}

protocol FeedModuleOutput: class {

}

protocol FeedModuleInput {
  
}

protocol FeedOutput: RxModelOutput {
  // dependencies
  var router: FeedRouterInput! {get}
  
  // initialization rx.cocoa
  func confRx(changeLayoutTap: Driver<Void>)
  
  // observable
  var title: Variable<String> {get}
  var datasourceItems: Variable<[ModelSection]> {get}
  var loadNextPageTrigger: PublishSubject<Void> {get}
  var refreshTrigger: PublishSubject<Void> {get}
  var currentLayout: Variable<CurrentLayout> {get}
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
  var title = Variable<String>("Dribbble")
  var datasourceItems = Variable<[ModelSection]>([])
  var loadNextPageTrigger = PublishSubject<Void>()
  var refreshTrigger = PublishSubject<Void>()
  var currentLayout = Variable<CurrentLayout>(.medium)
  
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
  
  func confRx(changeLayoutTap: Driver<Void>) {
    
    changeLayoutTap.throttle(1).drive(onNext: {
        self.currentLayout.value = self.currentLayout.value.nextLayoutType()
    }).disposed(by: bag)
    
    // Get first page from cache
    self.datasourceItems
      .asObservable()
      .take(1).filter{ $0.count == 0 }
      .map({ _ -> [FeedCellModel] in self.prepareFirstPageFromCache() })
      .bindTo(self.originalItems)
      .addDisposableTo(bag)
    
    // binding to datasource
    self.originalItems.asObservable()
      .observeOn(Schedulers.shared.backgroundWorkScheduler)
      // remove all duplicates
      .map({ items -> [FeedCellModel] in        
        return removeDuplicates(source: items)
      })
      // prepare for RxDatasource
      .map({ l -> [ModelSection] in
        if self.page == 1 {
          self.saveFirstPage(by: l)
        }
        
        return self.prepareForDatasource(list: l)
      })
      .observeOn(Schedulers.shared.mainScheduler)
      .bindTo(self.datasourceItems)
      .disposed(by: bag)
    
    // refresh first page
    self.refreshTrigger
      .subscribe(onNext: {
        self.obtainFirstPage()
      }).disposed(by: bag)
    
    // laod next page of shots
    self.loadNextPageTrigger
      .subscribe(onNext: {
        self.obtainNextPage()
      }).disposed(by: bag)
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
  func prepareForDatasource(list: [FeedCellModel]) -> [ModelSection] {
    var renderItemsData: [ModelSectionItem] = []
    renderItemsData = list.map { ModelSectionItem(model: $0) }
    return [ModelSection(items: renderItemsData)]
  }
  
  
  /// Obtain last cached first page of feed
  ///
  /// - Returns: Wrapped array of ModelSection
  func prepareFirstPageFromCache() -> [FeedCellModel] {
    guard let r = self.realm else { return []; }
    
    if let ids = self.appSettings?.feedFirstPage {
      let predicate = NSPredicate(format: "shotId IN %@", ids)
      return r.objects(ShotModel.self)
        .filter(predicate)
        .sorted { ids.index(of: $0.shotId)! < ids.index(of: $1.shotId)! }
        .map { $0.feedModel() }
    } else {
      return []
    }
  }
  
  
  /// Saving ids of first page
  ///
  /// - Parameter by: [FeedCellModel]
  func saveFirstPage(by: [FeedCellModel]) {
    let ids = by.map { $0.shotId }
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
    
    let response = api
      .provider
      .request(DribbbleAPI.shots(page: page, list: nil, timeframe: nil, date: nil, sort: nil))
      .mapJSONObjectArray(ShotModel.self, realm: self.realm)
    
    // prepare result
    let result = self.handleResponse(response)
      .do(onError: {[weak self] _ in
        self?.page = page-1
      })
      .observeOn(Schedulers.shared.backgroundWorkScheduler)
      .map({ shots -> [FeedCellModel] in
        return shots.map { $0.feedModel() }
      })
    
    // merge new result with exists data
    Observable.combineLatest(result, self.originalItems.asObservable()) { new, exists in
      return (page == 1) ? new : exists + new
    }
    .take(1)
    .observeOn(Schedulers.shared.mainScheduler)
    .bindTo(self.originalItems)
    .disposed(by: bag)
  }
}

