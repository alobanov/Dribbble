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

protocol ShotOutput {
  func refreshComments()
  func obtainCommentsNextPage()
  
  func configure(input: ShotViewModel.Input) -> ShotViewModel.Output
}

class ShotViewModel: RxViewModel, ShotOutput, RxViewModelType {
  
  // MARK: In/Out parameters
  struct InputDependencies {
    let router: ShotRouterInput
    let commentService: CommentNetworkPagination
    let shotId: Int
  }
  
  struct Input {
    let refreshComments: Observable<Void>
    let obtainComments: Observable<Void>
  }
  
  struct Output {
    let title: Observable<String>
    let datasourceItems: Observable<[ModelSection]>
    let paginationState: Observable<PaginationState>
    let shotId: Int
    
    let displayError: Observable<NSError>
    let loadingState: Observable<LoadingState>
  }
  
  // Mark:- Dependencies
  
  private var dp: InputDependencies
  
  // MARK:- properties
  
  private var title: Observable<String> = .just("Title")
  private var datasourceItems = Variable<[ModelSection]>([])
  private var paginationState = Variable<PaginationState>(.undefined)
  
  // MARK:- init
  init(dependencies:InputDependencies) {
    self.dp = dependencies
    
    super.init()
  }
  
  // Output
  func configure(input: ShotViewModel.Input) -> ShotViewModel.Output {
    
    self.dp.commentService.networkError.map { $0.error }.bind(to: self._displayError).addDisposableTo(bag)
    self.dp.commentService.commonNetworkState.map { $0.state }.bind(to: self._loadingState).addDisposableTo(bag)
    self.dp.commentService.paginationState.bind(to: self.paginationState).addDisposableTo(bag)
    
    input.obtainComments.bind(to: self.dp.commentService.loadNextPageTrigger).addDisposableTo(bag)
    input.refreshComments.bind(to: self.dp.commentService.refreshTrigger).addDisposableTo(bag)
    
    self.dp.commentService.comments
      .asObservable()
      .observeOn(Schedulers.shared.backgroundWorkScheduler) // move to bg
      .map { $0.map(CommentCellModel.init) }
//      .map { removeDuplicates(source: $0) }
      .map { $0.prepareForDatasource() }
      .observeOn(Schedulers.shared.mainScheduler) // back to main thread
      .bind(to: self.datasourceItems)
      .addDisposableTo(bag)
    
    return Output(title: self.title,
                  datasourceItems: self.datasourceItems.asObservable(),
                  paginationState: self.paginationState.asObservable(),
                  shotId: self.dp.shotId,
                  displayError: self.displayError,
                  loadingState: self.loadingState)
  }
  
  // MARK: - Additional
  
  func refreshComments() {
    self.dp.commentService.refreshTrigger.onNext()
  }
  
  func obtainCommentsNextPage() {
    self.dp.commentService.loadNextPageTrigger.onNext()
  }

  
  deinit {
    print("-- ShotViewModel dead")
  }
}
