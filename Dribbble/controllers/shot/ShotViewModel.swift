//
//  ShotViewModel.swift
//  Dribbble
//
//  Created by Lobanov Aleksey on 11.02.17.
//  Copyright (c) 2017 Lobanov Aleksey. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import RealmSwift

protocol ShotTestable {
  // put here private methods
}

protocol ShotModuleOutput: class {
  
}

protocol ShotModuleInput {
  
}

protocol ShotOutput: RxModelOutput {
  var router: ShotRouterInput! {get}
  var title: Variable<String> {get}
  var datasourceItems: Variable<[ModelSection]> {get}
  var paginationState: Variable<PaginationState> {get}
  var shotId: Int {get}
  
  func configureRx()
  func refreshComments()
  func obtainCommentsNextPage()
}

class ShotViewModel: RxViewModel, ShotOutput, ShotModuleInput, ShotTestable {
  
  // MARK:- dependencies
  var router: ShotRouterInput!
  fileprivate var commentService: CommentNetworkPagination!
  
  // MARK:- properties
  // ShotOutput
  var title = Variable<String>("Title")
  var datasourceItems = Variable<[ModelSection]>([])
  var shotId: Int
  var paginationState = Variable<PaginationState>(.undefined)
  
  // Private
  
  // MARK:- init
  init(dependencies:InputDependencies) {
    self.router = dependencies.router
    self.commentService = dependencies.commentService
    self.shotId = dependencies.shotId
    
    super.init()
  }
  
  // Output
  func configureRx() {
    
    self.commentService.networkError.map { $0.error }.bindTo(self._displayError).addDisposableTo(bag)
    self.commentService.commonNetworkState.map { $0.state }.bindTo(self._loadingState).addDisposableTo(bag)
    self.commentService.paginationState.asObservable().bindTo(self.paginationState).addDisposableTo(bag)
    
    self.commentService.comments
      .asObservable()
      .observeOn(Schedulers.shared.backgroundWorkScheduler) // in bg
      .map({ comments -> [CommentCellModel] in
        return comments.map(CommentCellModel.init)
      })
      .map({ items -> [CommentCellModel] in
        return removeDuplicates(source: items)
      })
      .map({ items -> [ModelSection] in
        return items.prepareForDatasource()
      })
      .observeOn(Schedulers.shared.mainScheduler) // in main thread
      .bindTo(self.datasourceItems)
      .addDisposableTo(bag)
  }
  
  // MARK: - Additional
  
  // MARK: - Networking
  
  func refreshComments() {
    self.commentService.refreshTrigger.onNext()
  }
  
  func obtainCommentsNextPage() {
    self.commentService.loadNextPageTrigger.onNext()
  }

  
  deinit {
    print("-- ShotViewModel dead")
  }
}

extension ShotViewModel: ViewModelType {
  struct InputDependencies {
    let router: ShotRouterInput
    let commentService: CommentNetworkPagination
    let shotId: Int
  }
}

// MARK: - Network
extension ShotViewModel {
  }

