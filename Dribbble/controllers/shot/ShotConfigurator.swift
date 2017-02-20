//
//  ShotConfigurator.swift
//  Dribbble
//
//  Created by Lobanov Aleksey on 11.02.17.
//  Copyright (c) 2017 Lobanov Aleksey. All rights reserved.
//

import UIKit

class ShotConfigurator
{
  // MARK: Configuration
  
  class func configure(viewController: ShotViewController, shotID: Int)
  {
    // router
    let router = ShotRouter()
//    router.viewController = viewController

    // dependencies
    let api = Networking.debugNetworking()
    let commentService = CommentNetworkService(api: api, shotId: shotID)
    
    // view model
    let viewModel = ShotViewModel(
      dependencies: (view: viewController, router: router, commentService: commentService, shotId: shotID)
    )
    
    // controller
    viewController.viewModel = viewModel
  }
  
  deinit {
    print("-- ShotConfigurator dead")
  }
}
