//
//  UITableView+Additions.swift
//  Dribbble
//
//  Created by Lobanov Aleksey on 10.10.16.
//  Copyright © 2016 Lobanov Aleksey. All rights reserved.
//

import UIKit

extension UITableView {
  
  func setupEstimatedRowHeight() {
    // configure table view
    self.rowHeight = UITableViewAutomaticDimension
    self.estimatedRowHeight = 60.0
    self.contentInset = UIEdgeInsets(top: -20, left: 0, bottom: 0, right: 0)
  }
  
  func setupEstimatedFooterHeight() {
    self.estimatedSectionFooterHeight = UITableViewAutomaticDimension;
    self.estimatedSectionFooterHeight = 25;
  }
  
  func setupEstimatedHeaderHeight() {
    self.estimatedSectionHeaderHeight = UITableViewAutomaticDimension;
    self.estimatedSectionHeaderHeight = 25;
  }
  
  func registerCell(by identifier:String) {
    self.register(UINib(nibName: identifier, bundle: nil),
         forCellReuseIdentifier: identifier)
  }
}
