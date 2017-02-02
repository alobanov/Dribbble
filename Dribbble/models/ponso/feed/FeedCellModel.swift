//
//  ShotCellModel.swift
//  Dribbble
//
//  Created by Lobanov Aleksey on 29.01.17.
//  Copyright © 2017 Lobanov Aleksey. All rights reserved.
//

import Foundation

struct FeedCellModel: ModelItemDatasourseble, Hashable, Equatable {
  var shotId: Int = 1
  var commnets = ""
  var views = ""
  var likes = ""
  var imagePath = ""
  var unic: String?
  
  var hashValue: Int { get { return shotId.hashValue } }
  
  init(shot: ShotModel) {
    commnets = " \(shot.comments)"
    likes = " \(shot.likes)"
    shotId = shot.shotId
    views = " \(shot.views)"
    
    if !shot.animated {
      imagePath = shot.image!.hidpi ?? shot.image!.normal!
    } else {
      imagePath = shot.image!.teaser ?? ""
    }
    
    unic = "\(shot.str_updated_at!)\(shotId)"
  }
}

func ==(left:FeedCellModel, right:FeedCellModel) -> Bool {
  return left.hashValue == right.hashValue
}
