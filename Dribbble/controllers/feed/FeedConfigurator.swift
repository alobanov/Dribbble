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
    let api = Networking.debugNetworking()
    let realm = try! Realm()
    
    // view model
    let viewModel = FeedViewModel(
      dependencies: (view: viewController, router: router, api: api, realm: realm)
    )
    
    // controller
    viewController.viewModel = viewModel
  }
}
