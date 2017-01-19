//
//  ShotImageModel.swift
//  Tavern
//
//  Created by Lobanov Aleksey on 07.11.15.
//  Copyright © 2015 Lobanov Aleksey. All rights reserved.
//

import ObjectMapper
import RealmSwift

class ShotImageModel: ObjectMappable {
    
    dynamic var hidpi: String?
    dynamic var normal: String?
    dynamic var teaser: String?
    
  required convenience init?(map: Map) {
    self.init()
  }
  
    // Mappable
    override func mapping(map: Map) {
        hidpi       <- map["hidpi"]
        normal      <- map["normal"]
        teaser      <- map["teaser"]
    }
    
    override class func primaryKey() -> String {
        return "teaser"
    }
}
