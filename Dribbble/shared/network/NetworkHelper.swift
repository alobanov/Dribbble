//
//  NetworkHelper.swift
//  Dribbble
//
//  Created by Lobanov Aleksey on 18.01.17.
//  Copyright © 2017 Lobanov Aleksey. All rights reserved.
//

import Foundation
import Moya
import RxSwift
import Alamofire

class NetworkHelper {
  
  private var api: Networking!
  
  // Singletone
  private let $ = Schedulers.shared
  
  init(networking: Networking) {
    api = networking
  }
  
  deinit {
    print("NH is dead!")
  }
  
  // MARK: - Registration
  
  /**
   Authorization login
   
   - parameter user: mail or telephone
   - parameter pass: string
   
   - returns: LoginResult
   */
  func shots(page: Int, list: String?, timeframe: String?, date: Date?, sort: String?) -> Observable <[ShotModel]> {
    return api.provider.request(DribbbleAPI.shots(page: page, list: list, timeframe: timeframe, date: date, sort: sort))
      .mapJSONObjectArray(ShotModel.self, writeDB: true)
  }
}

