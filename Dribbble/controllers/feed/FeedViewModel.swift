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

protocol FeedModuleOutput: class {

}

protocol FeedModuleInput {
  
}

protocol FeedOutput: RxModelOutput {
  var router: FeedRouterInput! {get}
  var title: Variable<String> {get}
  var items: Observable<[ModelSection]> {get}
  func confRx(signin: Driver<Void>)
}

protocol FeedInput: class {
//  func show(error: NSError)
}

class FeedViewModel: RxViewModel, FeedOutput, FeedModuleInput {
  
  // MARK:- dependencies
  fileprivate weak var view: FeedInput!
  fileprivate var api: NetworkHelper!
  var router: FeedRouterInput!
  
  // MARK:- properties
  // FeedOutput
  var title = Variable<String>("Rx Request")
  var items: Observable<[ModelSection]> {
    return _items.asObservable()
  }; var _items = Variable<[ModelSection]>([])
  
  // Private
  
  // MARK:- init
  init(dependencies:(
    view: FeedInput,
    router: FeedRouterInput,
    api: NetworkHelper
    )) {
    self.view = dependencies.view
    self.router = dependencies.router
    self.api = dependencies.api
    
    super.init()
  }
  
  // Output
  func confRx(signin: Driver<Void>) {
    signin.drive(onNext: {
      self.obtainShots()
    }).addDisposableTo(bag)
  }
  
  // MARK: - Additional
  
  deinit {
    print("-- FeedViewModel dead")
  }
}

// MARK: - Additional helpers
extension FeedViewModel {
  func prepareShotList(list: [ShotModel]) -> [ModelSection] {
    var renderItemsData: [ModelSectionItem] = []
    
    for s: ShotModel in list {
      renderItemsData.append(ModelSectionItem(model: s))
    }
    
    return [ModelSection(items: renderItemsData)]
  }
}

// MARK: - Network
extension FeedViewModel {
  func obtainShots() {
    if isRequestInProcess() {
      return
    }
    
    let res = api.shots(page: 1, list: nil, timeframe: nil, date: nil, sort: nil)
    
    self.handleResponse(res)
    .map({ l -> [ModelSection] in return self.prepareShotList(list: l) })
    .bindTo(self._items)
    .addDisposableTo(bag)
  }
}

