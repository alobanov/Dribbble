//
//  FeedRouter.swift
//  Dribbble
//
//  Created by Lobanov Aleksey on 18.01.17.
//  Copyright (c) 2017 Lobanov Aleksey. All rights reserved.
//

import UIKit

protocol FeedRouterInput
{
  func passDataToNextScene(segue: UIStoryboardSegue)
  func navigateToShot(byId: Int)
}


class FeedRouter: FeedRouterInput
{
  weak var viewController: FeedViewController!
  
  // MARK: Navigation
  
  func navigateToShot(byId: Int) {
    // navigate here
    let shot: ShotViewController = UIStoryboard(storyboard: .main).instantiateViewController()
    ShotConfigurator.configure(viewController: shot, shotID: byId)
    
    viewController.navigationController?.pushViewController(shot, animated: true)
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
}
