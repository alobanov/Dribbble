//
//  FeedConfigurator.swift
//  Dribbble
//
//  Created by Lobanov Aleksey on 18.01.17.
//  Copyright (c) 2017 Lobanov Aleksey. All rights reserved.
//

import UIKit
import RealmSwift

class FeedConfigurator
{
  // MARK: Configuration
  
  class func configure(viewController: FeedViewController)
  {
    _ = DBManager.sharedInstance
    
    // router
    let router = FeedRouter()
    router.viewController = viewController
    
    // dependencies
    let api = Networking.debugNetworking()
    let realm = try! Realm()
    let appSettings = AppSettingsStorage.shared
    
    // view model
    let viewModel = FeedViewModel(
      dependencies: (view: viewController, router: router, api: api, realm: realm, appSettings: appSettings)
    )
    
    // controller
    viewController.viewModel = viewModel
  }
}
