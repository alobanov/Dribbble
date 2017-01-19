//
//  Observable+ResponseFilter.swift
//  Dribbble
//
//  Created by Lobanov Aleksey on 28.09.16.
//  Copyright © 2016 Lobanov Aleksey. All rights reserved.
//
import Foundation
import RxSwift
import Moya

extension ObservableType where E == Bool {
  public func noInternetAlert() -> Observable<E> {
    return scan(Bool(true), accumulator: { (oldV, newV) -> Bool in
      if (newV != oldV) {
        Popup.shared.hide()
      }
      return newV
    })
      .map({ state in
        if !state {
          Popup.shared.noInternet()
        }
        return state
      })
  }
}
