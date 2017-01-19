//
//  NetworkMock.swift
//  Dribbble
//
//  Created by Lobanov Aleksey on 18.01.17.
//  Copyright © 2017 Lobanov Aleksey. All rights reserved.
//

import Foundation

@testable
import Dribbble

class NetworkMock {
  static var api = Networking.mockNetworking().provider
  static var apiHelper = NetworkHelper(api: Networking.mockNetworking())
}
