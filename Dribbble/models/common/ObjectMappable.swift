//
//  BaseDB.swift
//  Tavern
//
//  Created by Lobanov on 05.11.15.
//  Copyright © 2015 Lobanov Aleksey. All rights reserved.
//

import RealmSwift
import ObjectMapper

class ObjectMappable: Object, Mappable {
  required convenience init?(map: Map) {
    self.init()
  }
  
  // Mappable
  func mapping(map: Map) {}
}
