//
//  AppCellTypes.swift
//  Dribbble
//
//  Created by Lobanov Aleksey on 18.01.17.
//  Copyright © 2017 Lobanov Aleksey. All rights reserved.
//

import Foundation
import UIKit.UITableViewCell

protocol CellTypeble {
  var type: UITableViewCell.Type { get }
}

protocol CollectionCellTypeble {
  var type: UICollectionViewCell.Type { get }
}


enum FeedCells: CollectionCellTypeble {
  case shotCell
  
  var type: UICollectionViewCell.Type {
    switch self {
    case .shotCell:
      return ShotSmallCell.self
    }
  }
}
