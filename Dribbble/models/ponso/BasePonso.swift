//
//  BasePonso.swift
//  Dribbble
//
//  Created by Lobanov Aleksey on 17.02.17.
//  Copyright © 2017 Lobanov Aleksey. All rights reserved.
//

import Foundation

protocol PonsoUnicIdentifirable: Hashable, Equatable {
  var uid: Int {get}
}

extension PonsoUnicIdentifirable {
  public static func ==(lhs: Self, rhs: Self) -> Bool {
    return lhs.hashValue == rhs.hashValue
  }
  
  var hashValue: Int { return uid.hashValue }
}
