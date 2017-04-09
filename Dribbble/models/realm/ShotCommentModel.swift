//
//  ShotComment.swift
//  Dribbble
//
//  Created by Lobanov Aleksey on 15.02.17.
//  Copyright © 2017 Lobanov Aleksey. All rights reserved.
//

import ObjectMapper

class ShotCommentModel: ObjectMappable {
    
  dynamic var commentId = 0
  dynamic var body: String?
  dynamic var likes_url: String?
  dynamic var likes_count = 0
  dynamic var created_at: NSDate?
  dynamic var updated_at: NSDate?
  dynamic var updated_at_str: String?
  dynamic var user: UserModel?

  required convenience init?(map: Map) {
    self.init()
  }
  
  // Mappable
  override func mapping(map: Map) {
    commentId           <- map["id"]
    body                <- map["body"]
    likes_url           <- map["likes_url"]
    likes_count         <- map["likes_count"]
    created_at          <- (map["created_at"], ServerDateTransform())
    updated_at          <- (map["updated_at"], ServerDateTransform())
    updated_at_str      <- map["updated_at"]
    user                <- map["user"]
  }
  
  override class func primaryKey() -> String {
    return "commentId"
  }
  
}
