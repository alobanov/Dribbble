//
//  CommentNetworkService.swift
//  Dribbble
//
//  Created by Lobanov Aleksey on 17.02.17.
//  Copyright © 2017 Lobanov Aleksey. All rights reserved.
//

import Foundation
import RxSwift

protocol CommentNetworkPagination: NetworkPagination {
  var comments: Variable<[ShotCommentModel]> {get}
}

class CommentNetworkService: BasePaginationService, CommentNetworkPagination {
  
  // Private
  // Dependencies
  private var shotId: Int!
  
  // internal
  private var page = 1
  private let perPage = 10
  
  // Public
  var comments = Variable<[ShotCommentModel]>([])
  
  init(api: Networking, shotId: Int) {
    super.init(api: api)
    self.shotId = shotId
  }
  
  override func obtainData(by page: Int) {
    let response = api
      .provider
      .request(DribbbleAPI.shotComments(shotID: self.shotId, page: page, perPage: perPage))
      .mapJSONObjectArray(ShotCommentModel.self)
    
    // prepare result
    let result = self.handleResponse(response)
      .do(onNext: {[weak self] (comments) in
        if let pp = self?.perPage  {
          self?.paginationState.value = (comments.count < pp) ? .endOfList : .morePage;
        } 
      }, onError: {[weak self] _ in
        self?.page = page-1
      })
    
    // merge new result with exists data
    Observable.combineLatest(result, self.comments.asObservable()) { new, exists in
        return (page == 1) ? new : exists + new
      }
      .take(1)
      .bindTo(self.comments)
      .disposed(by: bag)
  }
  
  deinit {
    print("--- CommentNetworkService dead")
  }
}
