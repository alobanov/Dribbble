//
//  ShotRouter.swift
//  Dribbble
//
//  Created by Lobanov Aleksey on 11.02.17.
//  Copyright (c) 2017 Lobanov Aleksey. All rights reserved.
//

import UIKit

protocol ShotRouterInput
{
  func navigateTo()
}

class ShotRouter: ShotRouterInput
{
  weak var viewController: ShotViewController!
  
  // MARK: Navigation
  
  func navigateTo() {
    // navigate here
  }
}
