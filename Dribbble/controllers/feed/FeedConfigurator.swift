//
//  FeedConfigurator.swift
//  Dribbble
//
//  Created by Lobanov Aleksey on 18.01.17.
//  Copyright (c) 2017 Lobanov Aleksey. All rights reserved.
//

import UIKit

class FeedConfigurator
{
  // MARK: Configuration
  
  class func configure(viewController: FeedViewController)
  {
    // router
    let router = FeedRouter()
    router.viewController = viewController
    
    // dependencies
    let api = NetworkHelper(api: Networking.debugNetworking())
    
    // view model
    let viewModel = FeedViewModel(
      dependencies: (view: viewController, router: router, api: api)
    )
    
    // controller
    viewController.viewModel = viewModel
  }
}
