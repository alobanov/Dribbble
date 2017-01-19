//
//  UserModel.swift
//  Tavern
//
//  Created by Lobanov Aleksey on 21.12.15.
//  Copyright © 2015 Lobanov Aleksey. All rights reserved.
//

import ObjectMapper

class UserModel: ObjectMappable {
    dynamic var userId = 0
    dynamic var name: String?
    dynamic var username: String?
    dynamic var html_url: String?
    dynamic var avatar_url: String?
    dynamic var bio: String?
    dynamic var location: String?
    dynamic var link_web: String?
    dynamic var link_twitter: String?
    
    dynamic var buckets_count = 0
    dynamic var comments_received_count = 0
    dynamic var followers_count = 0
    dynamic var followings_count = 0
    dynamic var likes_count = 0
    dynamic var likes_received_count = 0
    dynamic var projects_count = 0
    dynamic var rebounds_received_count = 0
    dynamic var shots_count = 0
    dynamic var teams_count = 0
    
    dynamic var can_upload_shot: Bool = false
    dynamic var pro: Bool = false
    
  required convenience init?(map: Map) {
    self.init()
  }
  
    // Mappable
    override func mapping(map: Map) {
        userId                  <- map["id"]
        name                    <- map["name"]
        username                <- map["username"]
        html_url                <- map["html_url"]
        avatar_url              <- map["avatar_url"]
        bio                     <- map["bio"]
        location                <- map["location"]
        link_web                <- map["link.web"]
        link_twitter            <- map["link.twitter"]
        buckets_count           <- map["buckets_count"]
        comments_received_count <- map["comments_received_count"]
        followers_count         <- map["followers_count"]
        followings_count        <- map["followings_count"]
        likes_count             <- map["likes_count"]
        likes_received_count    <- map["likes_received_count"]
        projects_count          <- map["projects_count"]
        rebounds_received_count <- map["rebounds_received_count"]
        shots_count             <- map["shots_count"]
        can_upload_shot         <- map["can_upload_shot"]
        pro                     <- map["pro"]
    }
    
    override class func primaryKey() -> String {
        return "userId"
    }
}
