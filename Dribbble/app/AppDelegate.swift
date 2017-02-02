//
//  AppDelegate.swift
//  Dribbble
//
//  Created by Lobanov Aleksey on 17.01.17.
//  Copyright © 2017 Lobanov Aleksey. All rights reserved.
//

import UIKit
import Kingfisher

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
      ImageCache.default.maxDiskCacheSize = UInt(50 * 1024 * 1024)
      ImageCache.default.maxCachePeriodInSecond = TimeInterval(60 * 60 * 24 * 3)
      
      return true
    }

}

