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

protocol FeedViewModelPrivate {}

protocol FeedModuleOutput: class {}

protocol FeedModuleInput {}

protocol FeedOutput: RxModelOutput {
  var router: FeedRouterInput {get}
  
  // initialization rx.cocoa
  func confRx(changeLayoutTap: Driver<Void>)
  
  // observable
  var title: Variable<String> {get}
  var datasourceItems: Variable<[ModelSection]> {get}
  var loadNextPageTrigger: PublishSubject<Void> {get}
  var refreshTrigger: PublishSubject<Void> {get}
  var currentLayout: Variable<CurrentLayout> {get} // TODO: Implement tests!
  var paginationState: Variable<PaginationState> {get}
}

class FeedViewModel: RxViewModel, FeedOutput {
  
  // MARK:- dependencies
  fileprivate var feedService: FeedNetworkPagination
  var router: FeedRouterInput
  
  // MARK:- properties
  // FeedOutput
  
  var title = Variable<String>("Dribbble")
  var datasourceItems = Variable<[ModelSection]>([])
  var loadNextPageTrigger = PublishSubject<Void>()
  var refreshTrigger = PublishSubject<Void>()
  var currentLayout = Variable<CurrentLayout>(.medium)
  var paginationState = Variable<PaginationState>(.undefined)
  
  // MARK:- init
  
  init(dependencies: InputDependencies) {
    self.router = dependencies.router
    self.feedService = dependencies.feedService
    
    super.init()
  }
  
  // Output
  
  func confRx(changeLayoutTap: Driver<Void>) {
    
    // Get first page from cache
    self.feedService.networkError.map { $0.error }.bindTo(self._displayError).addDisposableTo(bag)
    self.feedService.commonNetworkState.map { $0.state }.bindTo(self._loadingState).addDisposableTo(bag)
    self.feedService.paginationState.asObservable().bindTo(self.paginationState).addDisposableTo(bag)
    
    self.feedService.shots
      .asObservable().skip(1)
      .map({ comments -> [FeedCellModel] in
        return comments.map { $0.feedModel() }
      })
      .observeOn(Schedulers.shared.backgroundWorkScheduler)
      .map({ items -> [FeedCellModel] in
        return removeDuplicates(source: items)
      })
      .map({ items -> [ModelSection] in
        return items.prepareForDatasource()
      })
      .observeOn(Schedulers.shared.mainScheduler)
      .bindTo(self.datasourceItems)
      .addDisposableTo(bag)
    
    // refresh first page
    self.refreshTrigger
      .filter { !self.isRequestInProcess() }
      .bindTo(self.feedService.refreshTrigger)
      .disposed(by: bag)
    
    // laod next page of shots
    self.loadNextPageTrigger
      .filter { !self.isRequestInProcess() }
      .bindTo(self.feedService.loadNextPageTrigger)
      .disposed(by: bag)
    
    changeLayoutTap.throttle(1).drive(onNext: {
      self.currentLayout.value = self.currentLayout.value.nextLayoutType()
    }).addDisposableTo(self.bag)
    
    self.feedService.mapFirstPage()
  }
  
  // MARK: - Additional
  
  deinit {
    print("-- FeedViewModel dead")
  }
}

extension FeedViewModel: ViewModelType {
  struct InputDependencies {
    let router: FeedRouterInput
    let feedService: FeedNetworkPagination
  }
}

// MARK: - Module input
extension FeedViewModel: FeedModuleInput {
  
}

// MARK: - Private methods
extension FeedViewModel: FeedViewModelPrivate {

}

