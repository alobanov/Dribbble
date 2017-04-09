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
    // router
    let router = FeedRouter()
    router.viewController = viewController
    
    // dependencies
    let realm = DBManager.shared.realmInstance
    let api = Networking.debugNetworking()
    let appSettings = AppSettingsStorage.shared
    
    // view model
    let service: FeedNetworkPagination = FeedNetworkService(api: api, realm: realm!, appSettings: appSettings)
    let dependencies = FeedViewModel.InputDependencies(router: router, feedService: service)
    
    let viewModel = FeedViewModel(
      dependencies: dependencies
    )
    
    // controller
    viewController.viewModel = viewModel
  }
}
