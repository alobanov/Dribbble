//
//  Observable+Networking.swift
//  Tavern
//
//  Created by Lobanov on 13.10.15.
//  Copyright © 2015 Lobanov Aleksey. All rights reserved.
//

import RxSwift
import ObjectMapper
import RealmSwift
import Moya

// MARK:- Network json mappier
extension Observable {
  func mapSimpleJSON() -> Observable<[String: AnyObject]> {
    return map {representor in
      guard let response = representor as? Response else {
        throw ORMError.ormNoRepresentor.error
      }
      
      // Allow successful HTTP codes
      if let err = ErrorManager.sharedInstance.haveResponseError(response.response as? HTTPURLResponse) {
        throw err
      }
      
      guard let json = try JSONSerialization.jsonObject(with: response.data, options: .mutableContainers) as? [String: AnyObject] else {
        throw ORMError.ormCouldNotMakeObjectError(objectName: "Raw json").error
      }
      
      if let code = json["ReturnCode"] as? Int, let message = json["Message"] as? String {
        if code != 0 {
          throw NSError(domain:ErrorManager.justDomain, code:code, userInfo: [NSLocalizedDescriptionKey: message])
        }
      }
      
      return json
    }
  }
  
  func mapJSONObject<T: ObjectMappable>(_ type: T.Type, realm: Realm? = nil) -> Observable<T> {
    func resultFromJSON(_ object: [String: AnyObject], classType: T.Type) -> T? {
      return Mapper<T>().map(JSON: object)
    }
    
    return map {representor in
      guard let response = representor as? Response else {
        throw ORMError.ormNoRepresentor.error
      }
      
      // Allow successful HTTP codes
      if let err = ErrorManager.sharedInstance.haveResponseError(response.response as? HTTPURLResponse) {
        throw err
      }
      
      guard let json = try JSONSerialization.jsonObject(with: response.data, options: .mutableContainers) as? [String: AnyObject] else {
        throw ORMError.ormCouldNotMakeObjectError(objectName: NSStringFromClass(T.self)).error
      }
      
      let obj: T = resultFromJSON(json, classType: type)!
      
      do {
        if let r = realm {
          let objR: T = resultFromJSON(json, classType: type)!
          r.beginWrite()
          r.add(objR, update: true)
          try r.commitWrite()
        }
        
        return obj
      } catch {
        throw ORMError.ormCouldNotMakeObjectError(objectName: NSStringFromClass(T.self)).error
      }
    }
  }
  
  func mapJSONObjectArray<T: ObjectMappable>(_ type: T.Type, realm: Realm? = nil) -> Observable < [T] > {
    func resultFromJSON(_ object: [String: AnyObject], classType: T.Type) -> T? {
      return Mapper<T>().map(JSON: object)
    }
    
    return map {response in
      guard let response = response as? Response else {
        throw ORMError.ormNoRepresentor.error
      }
      
      // Allow successful HTTP codes
      if let err = ErrorManager.sharedInstance.haveResponseError(response.response as? HTTPURLResponse) {
        throw err
      }
      
      guard let json = try JSONSerialization.jsonObject(with: response.data, options: .mutableContainers) as? [[String : AnyObject]] else {
        throw ORMError.ormCouldNotMakeObjectError(objectName: NSStringFromClass(T.self)).error
      }
      
      // Objects are not guaranteed, thus cannot directly map.
      var objects = [T]()
      for dict in json {
        if let obj = resultFromJSON(dict, classType: type) {
          objects.append(obj)
        }
      }
      
      if let r = realm {
        do {
          var objectsR = [T]()
          for dict in json {
            if let obj = resultFromJSON(dict, classType: type) {
              objectsR.append(obj)
            }
          }
          
          r.beginWrite()
          r.add(objectsR, update: true)
          try r.commitWrite()
        } catch {
          throw ORMError.ormCouldNotMakeObjectError(objectName: NSStringFromClass(T.self)).error
        }
      }
      
      return objects
    }
  }
}

// MARK:- Mapping from serialized dictionary
extension Observable {
  func mapModelFromDict<T: ObjectMappable>(_ type: T.Type, realm: Realm? = nil) -> Observable<T> {
    func resultFromJSON(_ object: [String: AnyObject], classType: T.Type) -> T? {
      return Mapper<T>().map(JSON: object)
    }
    
    return map { dataDict in
      guard let json = dataDict as? [String: AnyObject] else {
        throw ORMError.ormNoRepresentor.error
      }
      
      let obj: T = resultFromJSON(json, classType: type)!
      
      if let r = realm {
        do {
          let objR: T = resultFromJSON(json, classType: type)!
          r.beginWrite()
          r.add(objR, update: true)
          try r.commitWrite()
        } catch {
          throw ORMError.ormCouldNotMakeObjectError(objectName: NSStringFromClass(T.self)).error
        }
      }
      
      return obj
    }
  }
  
  func mapModelFromArray<T: ObjectMappable>(_ type: T.Type, realm: Realm? = nil) -> Observable < [T] > {
    func resultFromJSON(_ object: [String: AnyObject], classType: T.Type) -> T? {
      return Mapper<T>().map(JSON: object)
    }
    
    return map { dataArray in
      guard let json = dataArray as? [[String: AnyObject]] else {
        throw ORMError.ormNoRepresentor.error
      }
      
      var objects = [T]()
      for dict in json {
        if let obj = resultFromJSON(dict, classType: type) {
          objects.append(obj)
        }
      }
      
      if let r = realm {
        do {
          var objectsR = [T]()
          for dict in json {
            if let obj = resultFromJSON(dict, classType: type) {
              objectsR.append(obj)
            }
          }
          
          r.beginWrite()
          r.add(objectsR, update: true)
          try r.commitWrite()
        } catch {
          throw ORMError.ormCouldNotMakeObjectError(objectName: NSStringFromClass(T.self)).error
        }
      }
      
      return objects
    }
  }
}

// Mapper for local models without Realm and saving
extension Observable {
  func mapJSONLocalObject<T: Mappable>(_ type: T.Type) -> Observable<T> {
    func resultFromJSON(_ object: [String: AnyObject], classType: T.Type) -> T? {
      return Mapper<T>().map(JSON: object)
    }
    
    return map {representor in
      guard let response = representor as? Response else {
        throw ORMError.ormNoRepresentor.error
      }
      
      // Allow successful HTTP codes
      if let err = ErrorManager.sharedInstance.haveResponseError(response.response as? HTTPURLResponse) {
        throw err
      }
      
      guard let json = try JSONSerialization.jsonObject(with: response.data, options: .mutableContainers) as? [String: AnyObject] else {
        throw ORMError.ormCouldNotMakeObjectError(objectName: "\(T.self)").error
      }
      
      let obj: T = resultFromJSON(json, classType: type)!
      
      return obj
    }
  }
}
