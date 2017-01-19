//
//  CellIdentifiable.swift
//  Dribbble
//
//  Created by Lobanov Aleksey on 09.10.16.
//  Copyright © 2016 Lobanov Aleksey. All rights reserved.
//

import UIKit

protocol CellIdentifiable {
  static var cellIdentifier: String { get }
}

extension CellIdentifiable where Self: UITableViewCell {
  static var cellIdentifier: String {
    return String(describing: self)
  }
}
