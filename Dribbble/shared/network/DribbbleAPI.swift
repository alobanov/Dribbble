//
//  DribbbleAPI.swift
//  Dribbble
//
//  Created by Lobanov Aleksey on 18.01.17.
//  Copyright © 2017 Lobanov Aleksey. All rights reserved.
//

import Foundation
import RxSwift
import Moya
import Alamofire

private extension String {
  var URLEscapedString: String {
    return self.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlHostAllowed)!
  }
}

/// Method identifier
enum NetworkReqestType {
  case shots
  case shotComments
  case unknown
}

enum DribbbleAPI {
  //
  // Shots http://developer.dribbble.com/v1/shots/
  //
  case shots(page: Int, list: String?, timeframe: String?, date: Date?, sort: String?)
  
  //
  // Shot comments http://developer.dribbble.com/v1/shots/471756/comments
  //
  case shotComments(shotID: Int, page: Int, perPage: Int)
}

extension DribbbleAPI : TargetType {
  /// The method used for parameter encoding.
  public var parameterEncoding: ParameterEncoding {
    return URLEncoding.default
  }
  
  public var task: Task {
    switch self {
    default:
      return .request
    }
  }
  
  var base: String { return "https://api.dribbble.com/v1/" }
  var baseURL: URL {
    return URL(string: base)!
  }
  
  var path: String {
    switch self {
    case .shots(_, _, _, _, _):
      return "shots"
      
    case .shotComments(let shotID, _, _):
      return "shots/\(shotID)/comments"
    }
  }
  
  var method: Moya.Method {
    switch self {
    case .shots, .shotComments:
      return HTTPMethod.get
    }
  }
  
  var parameters: [String: Any]? {
    switch self {
    case .shots(let page, let list, let timeframe, let date, let sort):
      var shotsPrm = [String: AnyObject]()
      shotsPrm["page"] = page as AnyObject?
      shotsPrm["per_page"] = 50 as AnyObject?
      if let l = list {shotsPrm["list"] = l as AnyObject?}
      if let t = timeframe {shotsPrm["timeframe"] = t as AnyObject?}
      if let d = date {shotsPrm["date"] = d as AnyObject?}
      if let s = sort {shotsPrm["sort"] = s as AnyObject?}
      print(shotsPrm)
      return shotsPrm
      
    case .shotComments(_, let page, let perPage):
      var commentPrm = [String: Int]()
      commentPrm["page"] = page
      commentPrm["per_page"] = perPage
      return commentPrm
      
    }
  }
  
  var sampleData: Data {
    switch self {
    case .shots(let page, _, _, _, _):
      if page == 1 {
        return JSONReader.readJSONData("Feed")
      } else {
        return JSONReader.readJSONData("FeedPage2")
      }
    case .shotComments:
      return JSONReader.readJSONData("Comment")
    }
  }
  
  var methodIdentifier: Int {
    switch self {
    case .shots:
      return 1
    case .shotComments:
      return 2
    }
  }
  
  
}

func urlTransform(_ route: TargetType) -> String {
  return route.baseURL.appendingPathComponent(route.path).absoluteString
}
