//
//  SettingStorage.swift
//  Dribbble
//
//  Created by Lobanov Aleksey on 20.01.17.
//  Copyright © 2017 Lobanov Aleksey. All rights reserved.
//

import Foundation

import ObjectMapper
import RealmSwift

class SettingStorage: ObjectMappable {
  
  dynamic var singleObjKey = 1
  dynamic var firstPageIDs: String?
  
  required convenience init?(map: Map) {
    self.init()
  }
  
  // Mappable
  override func mapping(map: Map) {
  }
  
  override class func primaryKey() -> String {
    return "singleObjKey"
  }
}
