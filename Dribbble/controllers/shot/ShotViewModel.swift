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

protocol ShotInput: class {
  //  func show(error: NSError)
}

class ShotViewModel: RxViewModel, ShotOutput, ShotModuleInput, ShotTestable {
  
  // MARK:- dependencies
  fileprivate weak var view: ShotInput!
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
    self.view = dependencies.view
    self.router = dependencies.router
    self.commentService = dependencies.commentService
    self.shotId = dependencies.shotId
    
    super.init()
  }
  
  // Output
  func configureRx() {
    
    self.commentService.displayError.bindTo(self._displayError).addDisposableTo(bag)
    self.commentService.loadingState.bindTo(self._loadingState).addDisposableTo(bag)
    self.commentService.paginationState.asObservable().bindTo(self.paginationState).addDisposableTo(bag)
    
    self.commentService.comments
      .asObservable().skip(1)
      .observeOn(Schedulers.shared.backgroundWorkScheduler)
      .map({ comments -> [CommentCellModel] in
        return comments.map { $0.commentModel() }
      })
      .map({ items -> [CommentCellModel] in
        return removeDuplicates(source: items)
      })
      .map({[weak self] items -> [ModelSection] in
        return self?.prepareForDatasource(list: items) ?? []
      })
      .observeOn(Schedulers.shared.mainScheduler)
      .bindTo(self.datasourceItems)
      .addDisposableTo(bag)
    
  }
  
  // MARK: - Additional
  
  deinit {
    print("-- ShotViewModel dead")
  }
}

extension ShotViewModel: ViewModelType {
  struct InputDependencies {
    let view: ShotInput
    let router: ShotRouterInput
    let commentService: CommentNetworkPagination
    let shotId: Int
  }
}

// MARK: - Additional helpers
extension ShotViewModel {
  
  /// Wrap ShotModels into datasource protocols
  ///
  /// - Parameter list: ShotModel
  /// - Returns: Wrapped array of ModelSection
  func prepareForDatasource(list: [CommentCellModel]) -> [ModelSection] {
    var renderItemsData: [ModelSectionItem] = []
    renderItemsData = list.map { ModelSectionItem(model: $0) }
    return [ModelSection(items: renderItemsData)]
  }
  
}

// MARK: - Network
extension ShotViewModel {
  func refreshComments() {
    self.commentService.refreshTrigger.onNext()
  }
  
  func obtainCommentsNextPage() {
    self.commentService.loadNextPageTrigger.onNext()
  }
}

