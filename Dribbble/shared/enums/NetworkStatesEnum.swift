//
//  NetworkStatesEnum.swift
//  Dribbble
//
//  Created by Lobanov Aleksey on 17.02.17.
//  Copyright © 2017 Lobanov Aleksey. All rights reserved.
//

import Foundation

enum PaginationState {
  case firstPage
  case morePage
  case endOfList
  case undefined
}

// MARK: - Enum Values
enum LoadingState: Equatable {
  /// Content is available and not loading any content
  case normal
  /// No Content is available
  case empty
  /// Got an error loading content
  case error
  /// Is loading content
  case loading
  // Prepearing state
  case unknown
}

// MARK: - Equatable
func == (lhs: LoadingState, rhs: LoadingState) -> Bool {
  switch (lhs, rhs) {
  case (.normal, .normal):
    return true
  case (.empty, .empty):
    return true
  case (.error, .error):
    return true
  case (.loading, .loading):
    return true
  default:
    return false
  }
}
