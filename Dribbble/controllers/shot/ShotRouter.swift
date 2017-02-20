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
  func passDataToNextScene(segue: UIStoryboardSegue)
  func navigateTo()
}

class ShotRouter: ShotRouterInput
{
  weak var viewController: ShotViewController!
  
  // MARK: Navigation
  
  func navigateTo() {
    // navigate here
  }
  
  // MARK: Communication
  
  func passDataToNextScene(segue: UIStoryboardSegue)
  {
//    if segue.identifier == ViewController.segueID {
//      passDataToController(segue: segue)
//    }
  }
  
  func passDataToProfile(segue: UIStoryboardSegue) {
//    let vc = segue.destination as! ViewController
//    Configurator.configure(viewController: vc)
  }
  
  deinit {
    print("-- ShotRouter dead")
  }
}
