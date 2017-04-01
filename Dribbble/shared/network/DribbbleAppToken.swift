//
//  DribbbleAppToken.swift
//  Dribbble
//
//  Created by Lobanov Aleksey on 18.01.17.
//  Copyright © 2017 Lobanov Aleksey. All rights reserved.
//

import Foundation
import Keys


fileprivate struct DribbbleAPIConfig {
  fileprivate static let keys = DribbbleKeys()
  static let clientSecret = keys.dribbbleClientSecret()
  static let clientAccessToken = keys.dribbbleClientAccessToken()
  static let ts = Date().timeIntervalSince1970.description
  static let publicBearer = "Bearer: \(String(describing: clientAccessToken))"
}

private extension Date {
    var isInPast: Bool {
        let now = Date()
        return self.compare(now) == ComparisonResult.orderedAscending
    }
}

struct DribbleAppToken {
    enum DefaultsKeys: String {
        case TokenKey = "TokenKey"
    }
    
    // MARK: - Initializers
    
    let defaults: UserDefaults
    
    init(defaults: UserDefaults) {
        self.defaults = defaults
    }
    
    init() {
        self.defaults = UserDefaults.standard
    }
    
    
    // MARK: - Properties
    
    var token: String? {
        get {
            if let key = defaults.string(forKey: DefaultsKeys.TokenKey.rawValue) {
                return key
            } else {
                // public tocken
                return DribbbleAPIConfig.clientAccessToken
            }
        }
        set(newToken) {
            defaults.set(newToken, forKey: DefaultsKeys.TokenKey.rawValue)
        }
    }
    
    var isValid: Bool {
        if let token = defaults.string(forKey: DefaultsKeys.TokenKey.rawValue) {
            return token.isNotEmpty
        }
        
        return false
    }
    
}
