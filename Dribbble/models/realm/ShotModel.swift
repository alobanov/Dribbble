//
//  ShotModel.swift
//  Tavern
//
//  Created by Lobanov on 26.10.15.
//  Copyright © 2015 Lobanov Aleksey. All rights reserved.
//

import ObjectMapper

struct ShotSize {
  static var width: CGFloat = 400
  static var height: CGFloat = 300
}

class ShotModel: ObjectMappable {
  dynamic var shotId = 0
  dynamic var animated: Bool = false
  dynamic var width: CGFloat = 0
  dynamic var height: CGFloat = 0
  dynamic var descr: String?
  dynamic var image: ShotImageModel?
  dynamic var user: UserModel?
  dynamic var created_at: NSDate?
  dynamic var updated_at: NSDate?
  dynamic var str_updated_at: NSString?
  
  // statistics
  dynamic var likes: Int = 0
  dynamic var views: Int = 0
  dynamic var comments: Int = 0
  
  required convenience init?(map: Map) {
    self.init()
  }
  
  // Mappable
  override func mapping(map: Map) {
    comments    <- map["comments_count"]
    likes       <- map["likes_count"]
    descr       <- map["description"]
    shotId      <- map["id"]
    image       <- map["images"]
    animated    <- map["animated"]
    width       <- map["width"]
    height      <- map["height"]
    views       <- map["views_count"]
    user        <- map["user"]
    
    created_at <- (map["created_at"], ServerDateTransform())
    updated_at <- (map["updated_at"], ServerDateTransform())
    
    str_updated_at <- map["updated_at"]
  }
  
  override class func primaryKey() -> String {
    return "shotId"
  }
  
  var unic: String? {
    return "\(String(describing: str_updated_at))"
  }
}
