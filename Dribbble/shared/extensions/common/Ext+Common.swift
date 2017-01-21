//
//  Ext+Common.swift
//  Dribbble
//
//  Created by Lobanov Aleksey on 10.10.16.
//  Copyright © 2016 Lobanov Aleksey. All rights reserved.
//

import Foundation

extension Int {
  func format(f: String) -> String {
    return String(format: "%\(f)d", self)
  }
}

extension Double {
  func format(f: String) -> String {
    return String(format: "%\(f)f", self)
  }
}
