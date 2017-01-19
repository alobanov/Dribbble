//
//  ErrorManager+ORMError.swift
//  Tavern
//
//  Created by Lobanov Aleksey on 13.03.16.
//  Copyright © 2016 Lobanov Aleksey. All rights reserved.
//

import Foundation

enum ORMError: Error {
  case ormNoRepresentor
  case ormNotSuccessfulHTTP
  case ormNoData
  case ormCouldNotMakeObjectError(objectName: String)
  case ormCouldNotFindNodeForParsing(nodeName: String)
  case ormRealmDatabase
}

extension ORMError {
  var error: NSError {
    switch self {
    case .ormNoRepresentor:
      return NSError(domain:ErrorManager.justDomain, code:-21, userInfo: [NSLocalizedDescriptionKey: "No responese from server"])
    case .ormNotSuccessfulHTTP:
      return NSError(domain:ErrorManager.justDomain, code:-22, userInfo: [NSLocalizedDescriptionKey: "Server error response (see logs)"])
    case .ormNoData:
      return NSError(domain:ErrorManager.justDomain, code:-23, userInfo: [NSLocalizedDescriptionKey: "No response data (empty data)"])
    case .ormCouldNotMakeObjectError(let objectName):
      return NSError(domain:ErrorManager.justDomain, code:-24, userInfo: [NSLocalizedDescriptionKey: "Error with serealization: \(objectName).Type"])
    case .ormCouldNotFindNodeForParsing(let nodeName):
      return NSError(domain:ErrorManager.justDomain, code:-25, userInfo: [NSLocalizedDescriptionKey: "Could not find node for parsing: '\(nodeName)'"])
    case .ormRealmDatabase:
      return NSError(domain:ErrorManager.justDomain, code:-26, userInfo: [NSLocalizedDescriptionKey: "Something wrong with Realm"])
    }
  }
}
