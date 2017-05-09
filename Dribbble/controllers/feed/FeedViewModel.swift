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

protocol FeedOutput {
  func configure(input: FeedViewModel.Input) -> FeedViewModel.Output
}

class FeedViewModel: RxViewModel, FeedOutput, RxViewModelType {
  
  // MARK: In/Out parameters
  struct InputDependencies {
    var router: FeedRouterInput
    let feedService: FeedNetworkPagination
  }
  
  struct Input {
    let changeLayoutTap: Driver<Void>
    let selectedCell: Driver<ModelSectionItem>
  }
  
  struct Output {
    let title: Observable<String>
    let datasourceItems: Observable<[ModelSection]>
    let loadNextPageTrigger: PublishSubject<Void>
    let refreshTrigger: PublishSubject<Void>
    let currentLayout: Observable<CurrentLayout>
    let paginationState: Observable<PaginationState>
    let displayError: Observable<NSError>
    let loadingState: Observable<LoadingState>
  }
  
  // MARK:- dependencies
  private var dp: InputDependencies
  
  // MARK:- properties
  // FeedOutput
  
  private var title: Observable<String> = .just("Dribbble")
  
  private var datasourceItems = Variable<[ModelSection]>([])
  private var loadNextPageTrigger = PublishSubject<Void>()
  private var refreshTrigger = PublishSubject<Void>()
  private var currentLayout = Variable<CurrentLayout>(.medium)
  private var paginationState = Variable<PaginationState>(.undefined)
  
  // MARK:- init
  
  init(dependencies: InputDependencies) {
    self.dp = dependencies
    
    super.init()
  }
  
  // Output
  
  func configure(input: Input) -> Output {
    
    // Get first page from cache
    self.dp.feedService.networkError.map { $0.error }.bind(to: self._displayError).addDisposableTo(bag)
    self.dp.feedService.commonNetworkState.map { $0.state }.bind(to: self._loadingState).addDisposableTo(bag)
    self.dp.feedService.paginationState.asObservable().bind(to: self.paginationState).addDisposableTo(bag)
    
    self.dp.feedService.shots
      .asObservable().skip(1)
      .map({ comments -> [FeedCellModel] in
        return comments.map(FeedCellModel.init)
      })
      .observeOn(Schedulers.shared.backgroundWorkScheduler)
      .map({ items -> [FeedCellModel] in
        return removeDuplicates(source: items)
      })
      .map({ items -> [ModelSection] in
        return items.prepareForDatasource()
      })
      .observeOn(Schedulers.shared.mainScheduler)
      .bind(to: self.datasourceItems)
      .addDisposableTo(bag)
    
    // refresh first page
    self.refreshTrigger
      .filter { !self.isRequestInProcess() }
      .bind(to: self.dp.feedService.refreshTrigger)
      .disposed(by: bag)
    
    // laod next page of shots
    self.loadNextPageTrigger
      .filter { !self.isRequestInProcess() }
      .bind(to: self.dp.feedService.loadNextPageTrigger)
      .disposed(by: bag)
    
    input.changeLayoutTap.throttle(1).drive(onNext: {
      self.currentLayout.value = self.currentLayout.value.nextLayoutType()
    }).addDisposableTo(self.bag)
    
    /// cell selected
    input.selectedCell.drive(onNext: { [weak self] model in
      guard let feedItem: FeedCellModel = model.model as? FeedCellModel else {
        return;
      }
      
      self?.dp.router.navigateToShot(byId: feedItem.uid)
    }).addDisposableTo(bag)
    
    self.dp.feedService.mapFirstPage()
    
    return Output(title: self.title,
                  datasourceItems: self.datasourceItems.asObservable(),
                  loadNextPageTrigger: self.loadNextPageTrigger,
                  refreshTrigger: self.refreshTrigger,
                  currentLayout: self.currentLayout.asObservable(),
                  paginationState: self.paginationState.asObservable(),
                  displayError: self.displayError,
                  loadingState: self.loadingState)
  }
  
  // MARK: - Additional
  
  deinit {
    print("-- FeedViewModel dead")
  }
}

