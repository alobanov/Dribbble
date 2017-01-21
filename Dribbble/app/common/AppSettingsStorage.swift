//
//  AppSettingsStorage.swift
//  Dribbble
//
//  Created by Lobanov Aleksey on 21.01.17.
//  Copyright © 2017 Lobanov Aleksey. All rights reserved.
//

import Foundation
import SwiftyUserDefaults

struct UDSettingsStorage {
  static let feedIdsOfFirstPage = DefaultsKey<Array<Int>>("feedIdsOfFirstPage")
}

// MARK: - Manager
class AppSettingsStorage {
  
  // Singletone
  static let shared = AppSettingsStorage()
  
  private init() {}
  
  // MARK: - Defaults state
  var feedFirstPage: Array<Int> {
    get { return Defaults[UDSettingsStorage.feedIdsOfFirstPage] }
    set { Defaults[UDSettingsStorage.feedIdsOfFirstPage] = newValue }
  }
}

