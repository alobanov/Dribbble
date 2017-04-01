//
//  ErrorManager+InAppError.swift
//  Tavern
//
//  Created by Lobanov Aleksey on 13.03.16.
//  Copyright © 2016 Lobanov Aleksey. All rights reserved.
//

import Foundation

enum AppError: Error {
  case appErrorEmptyData
  case appErrorUnknownError
  case appErrorNoActionID
  case appErrorCustom(message: String)
  
  // salf made 401 error
  case appErrorUnauthorizedAccess
  case dummyError
}


extension AppError {
    var error: NSError {
        switch self {
        case .appErrorEmptyData:
            return NSError(domain:ErrorManager.justDomain, code:-1, userInfo: [NSLocalizedDescriptionKey: "Response data is empty"])
        case .appErrorUnknownError:
          return NSError(domain:ErrorManager.justDomain, code:-2, userInfo: [NSLocalizedDescriptionKey: "Unknown error"])
        case .appErrorNoActionID:
          return NSError(domain:ErrorManager.justDomain, code:-3, userInfo: [NSLocalizedDescriptionKey: "Action ID is empty, start registration from the beginning"])
        case let .appErrorCustom(message):
          return NSError(domain:ErrorManager.justDomain, code:-3, userInfo: [NSLocalizedDescriptionKey: message])
        case .appErrorUnauthorizedAccess:
          return NSError(domain:ErrorManager.justDomain, code:401, userInfo: [NSLocalizedDescriptionKey: "Unauthorized access"])
        case .dummyError:
          return NSError(domain:ErrorManager.justDomain, code:0, userInfo: [NSLocalizedDescriptionKey: "unknown"])
        }
    }
}
