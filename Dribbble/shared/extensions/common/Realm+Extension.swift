//
//  Realm+Extension.swift
//  Dribbble
//
//  Created by Lobanov Aleksey on 20.01.17.
//  Copyright © 2017 Lobanov Aleksey. All rights reserved.
//

import Foundation
import RealmSwift

extension Results{
  func get <T:Object> (offset: Int, limit: Int ) -> Array<T>{
    //create variables
    var lim = 0 // how much to take
    var off = 0 // start from
    var l: Array<T> = Array<T>() // results list
    
    //check indexes
    if off<=offset && offset<self.count - 1 {
      off = offset
    }
    if limit > self.count {
      lim = self.count
    }else{
      lim = limit
    }
    
    //do slicing
    for i in off..<lim{
      let dog = self[i] as! T
      l.append(dog)
    }
    
    //results
    return l
  }
}
