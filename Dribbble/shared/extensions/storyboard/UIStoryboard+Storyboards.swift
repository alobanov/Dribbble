//
//  UIStoryboard+Storyboards.swift
//  Dribbble
//
//  Created by Lobanov Aleksey on 21.07.16.
//  Copyright © 2016 Lobanov Aleksey. All rights reserved.
//

import UIKit

extension UIStoryboard {
  
  /// The uniform place where we state all the storyboard we have in our application
  
  enum Storyboard : String {
    case main =  "Main"
  }
  
  
  /// Convenience Initializers
  
  convenience init(storyboard: Storyboard, bundle: Bundle? = nil) {
    self.init(name: storyboard.rawValue, bundle: bundle)
  }
  
  
  /// Class Functions
  
  class func storyboard(_ storyboard: Storyboard, bundle: Bundle? = nil) -> UIStoryboard {
    return UIStoryboard(name: storyboard.rawValue, bundle: bundle)
  }
  
  
  /// New Way
  func instantiateViewController<T: UIViewController>() -> T where T: StoryboardIdentifiable {
    guard let viewController = self.instantiateViewController(withIdentifier: T.storyboardIdentifier) as? T else {
      fatalError("Couldn't instantiate view controller with identifier \(T.storyboardIdentifier) ")
    }
    
    return viewController
  }
  
  func instantiateRootViewController() -> UINavigationController {
    guard let navigation = self.instantiateInitialViewController() as? UINavigationController else {
      fatalError("Couldn't instantiate navigation view controller")
    }
    
    return navigation
  }
}
