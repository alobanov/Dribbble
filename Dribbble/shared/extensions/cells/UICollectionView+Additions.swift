//
//  UICollectionView+Additions.swift
//  Dribbble
//
//  Created by Lobanov Aleksey on 18.01.17.
//  Copyright © 2017 Lobanov Aleksey. All rights reserved.
//

import Foundation
import UIKit.UICollectionView

extension UICollectionView{
  func registerCell(by identifier:String) {
    self.register(UINib(nibName: identifier, bundle: nil),
                                  forCellWithReuseIdentifier: identifier)
  }
}
