//
//  Networking.swift
//  Dribbble
//
//  Created by Lobanov Aleksey on 18.01.17.
//  Copyright © 2017 Lobanov Aleksey. All rights reserved.
//

import Foundation
import Moya
import RxSwift
import Alamofire

// MARK: - Network setitngs

struct Configuration {
  static var shared = Configuration()
  
  init() {}
  
  lazy var customManager: Manager = {
    let serverTrustPolicies: [String: ServerTrustPolicy] = [
      "ge.Dribbble.ccBeta": .pinCertificates(
        certificates: ServerTrustPolicy.certificates(),
        validateCertificateChain: true,
        validateHost: true
      ),
      "95.47.137.58": .disableEvaluation
    ]
    
    let session = URLSessionConfiguration.default
    let m = Manager(configuration: session, serverTrustPolicyManager: ServerTrustPolicyManager(policies: serverTrustPolicies))
    return m
  }()
  
  lazy var defaultManager: Manager = {
    return Manager.default
  }()
}

// MARK: - Online provider base

class OnlineProvider<Target>: RxMoyaProvider<Target> where Target: TargetType {
  private let online: Observable<Bool>
  private let isNoInternet = false
  
  init(endpointClosure: @escaping MoyaProvider<Target>.EndpointClosure = MoyaProvider.defaultEndpointMapping,
       requestClosure: @escaping MoyaProvider<Target>.RequestClosure = MoyaProvider.defaultRequestMapping,
       stubClosure: @escaping MoyaProvider<Target>.StubClosure = MoyaProvider.neverStub,
       manager: Manager = Alamofire.SessionManager.default,
       plugins: [PluginType] = [],
       online: Observable<Bool> = connectedToInternetOrStubbing()) {
    
    self.online = online
    super.init(endpointClosure: endpointClosure, requestClosure: requestClosure, stubClosure: stubClosure, manager: manager, plugins: plugins)
  }
  
  override func request(_ token: Target) -> Observable<Moya.Response> {
    let actualRequest = super.request(token)
    
    return online
      .noInternetAlert() // show "no internet" popup alert
      .ignore(false)     // Wait until we're online
      .take(1)           // Take 1 to make sure we only invoke the API once.
      .flatMap { _ in    // Turn the online state into a network request
        return actualRequest
      }
  }
}

// MARK: - Network configurator

protocol NetworkingType {
  associatedtype T: TargetType
  var provider: OnlineProvider<T> { get }
}

struct Networking: NetworkingType {
  typealias T = DribbbleAPI
  let provider: OnlineProvider<DribbbleAPI>
}

// Static methods
extension NetworkingType {
  
  /**
   Networking
   */
  static func debugNetworking() -> Networking {
    return Networking(provider: OnlineProvider(endpointClosure: endpointsClosure,
                                               requestClosure: endpointResolver(),
                                               plugins: [])) //[NetworkLoggerPlugin(verbose: false)]
  }
  
  static func mockNetworking() -> Networking {
    return Networking(provider: OnlineProvider(endpointClosure: endpointsClosure, stubClosure: MoyaProvider.immediatelyStub))
  }
  
  static func prodNetworking() -> Networking {
    return Networking(provider: OnlineProvider(manager: Configuration.shared.defaultManager, plugins: []))
  }
  
  /**
   Endpoint
   */
  static func endpointsClosure<T>(_ target: T) -> Endpoint<T> where T: TargetType, T: TargetType {
    let url = urlTransform(target)
    let endpoint: Endpoint<T> = Endpoint(url: url,
                                         sampleResponseClosure: {.networkResponse(200, target.sampleData)},
                                         method: target.method,
                                         parameters: target.parameters)
    
    switch target {
    default:
      let token = DribbleAppToken().token ?? ""
      return endpoint.adding(httpHeaderFields: ["Authorization": "Bearer \(token)"])
    }
  }
  
  /**
   Request modification
   */
  static func endpointResolver<T>() -> MoyaProvider<T>.RequestClosure where T: TargetType {
    return { (endpoint, closure) in
//      var req = endpoint.urlRequest!
//      if var tmpStrURL = req.url?.absoluteString {
//        tmpStrURL = tmpStrURL.replacingOccurrences(of: "%5B%5D", with: "")
//        req.url = URL(string: tmpStrURL)
//      }
      closure(.success(endpoint.urlRequest!))
    }
  }
}
