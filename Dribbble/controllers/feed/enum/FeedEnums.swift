//
//  FeedEnums.swift
//  Dribbble
//
//  Created by Lobanov Aleksey on 05.02.17.
//  Copyright © 2017 Lobanov Aleksey. All rights reserved.
//

import UIKit
import Font_Awesome_Swift

// Collection view structure
enum CurrentLayout: Int {
  case small
  case medium
  case large
  case count
  
  var icon: FAType {
    switch self {
    case .small:
      return FAType.FAThLarge
    case .medium:
      return FAType.FASquare
    default:
      return FAType.FATh
    }
  }
  
  func nextLayoutType() -> CurrentLayout {
    let nextType = 0
    if self.rawValue + 1 == CurrentLayout.count.rawValue {
      return CurrentLayout(rawValue: nextType)!
    }
    
    return CurrentLayout(rawValue: self.rawValue + 1)!
  }
}

enum FeedConstants: CGFloat {
  case heightStatisticOffset = 20
  case spacingDefault = 5.0
}
